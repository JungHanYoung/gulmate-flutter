import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart' hide Message;
import 'package:get_it/get_it.dart';
import 'package:gulmate/EnvironmentConfig.dart';
import 'package:gulmate/bloc/blocs.dart';
import 'package:gulmate/helper/notification_helper.dart';
import 'package:gulmate/model/model.dart';
import 'package:gulmate/repository/repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {

  ChatRepository _chatRepository;
  FamilyRepository _familyRepository;
  UserRepository _userRepository;
  final AppTabBloc appTabBloc;
  final AuthenticationBloc authenticationBloc;
  StreamSubscription _appTabSubscription;
  StompClient _stompClient;
  int _cmi;

  ChatBloc({
    @required this.appTabBloc,
    @required this.authenticationBloc}) {
    _chatRepository = GetIt.instance.get<ChatRepository>();
    _familyRepository = GetIt.instance.get<FamilyRepository>();
    _userRepository = GetIt.instance.get<UserRepository>();
    _familyRepository.family.id;

    _stompClient = StompClient(
        config: StompConfig(
          url: "ws://${EnvironmentConfig.API_DOMAIN}/ws",
          stompConnectHeaders: {
            'Authorization': 'Bearer ${_userRepository.token}',
          },
          onConnect: (client, frame) {
            final destination = "/sub/family/${_familyRepository.family.id}";
            client.subscribe(destination: destination, callback: (frame) {
              add(ReceiveChatMessage.fromJson(jsonDecode(frame.body)));
            });
          }
        )
    );
    _stompClient.activate();

    _appTabSubscription = appTabBloc.listen((state) {

      if(state == AppTab.chatting) {
        add(FetchChatMessage());
      }
    });
    authenticationBloc.listen((state) {
      if(state is AuthenticationUnauthenticated) {
        _stompClient.deactivate();
        _stompClient = null;
      } else if(state is AuthenticationAuthenticatedWithFamily) {
        if(_stompClient == null) {
          _stompClient = StompClient(config: StompConfig(
              url: "${EnvironmentConfig.IS_PROD ? "wss" : "ws"}://${EnvironmentConfig.API_DOMAIN}/ws",
              stompConnectHeaders: {
                'Authorization': 'Bearer ${_userRepository.token}',
              },
              onConnect: (client, frame) {
                final destination = "/sub/family/${_familyRepository.family.id}";
                client.subscribe(destination: destination, callback: (frame) {
                  add(ReceiveChatMessage.fromJson(jsonDecode(frame.body)));
                });
              }
          ));
        }
      }
    });
    SharedPreferences.getInstance()
    .then((pref) {
      _cmi = pref.getInt("chatMessageId");
    });
  }

  @override
  ChatState get initialState => ChatLoading();

  @override
  Stream<ChatState> mapEventToState(ChatEvent event) async* {
    if(event is FetchChatMessage) {
      yield* _mapFetchChatMessageToState(event);
    } else if(event is SendChatMessage) {
      yield* _mapSendChatMessageToState(event);
    } else if(event is ReceiveChatMessage) {
      yield* _mapReceiveChatMessageToState(event);
    }
  }

  Stream<ChatState> _mapFetchChatMessageToState(FetchChatMessage event) async* {
    try {
      yield ChatLoading();
      final messageList = await _chatRepository.fetchMessageList();
      yield ChatLoaded(messageList);
    } catch(e) {
      print(e);
      yield ChatLoading();
    }
  }

  @override
  Future<void> close() {
    _appTabSubscription.cancel();
    return super.close();
  }

  Stream<ChatState> _mapSendChatMessageToState(SendChatMessage event) async* {
    final authState = (authenticationBloc.state as AuthenticationAuthenticatedWithFamily);

//    print("ChatBloc : send chat message ${event.message}");
//    print("stomp connected: ${_stompClient.connected}, Send Chat Message ${event.message}");
    String rawJson = jsonEncode({
      'message': event.message,
      'accountId': authState.currentAccount.id
    });
    _stompClient.send(destination: "/app/${_familyRepository.family.id}/chat", body: rawJson);
  }

  Stream<ChatState> _mapReceiveChatMessageToState(ReceiveChatMessage event) async* {
    final authState = (authenticationBloc.state as AuthenticationAuthenticatedWithFamily);
    final messageCreator = authState.currentFamily.accountList.firstWhere((account) => account.id == event.accountId);
    if(authState.currentAccount.id != event.accountId) {
      _showNotification(event.message, messageCreator);
    }
    if(state is ChatLoaded) {
      final messageList = (state as ChatLoaded).messageList;
      yield ChatLoading();
      messageList.add(Message(message: event.message, creator: messageCreator));
      yield ChatLoaded(messageList);
      _cmi = event.messageId;
      SharedPreferences.getInstance().then((pref) {
        pref.setInt("chatMessageId", _cmi);
      });
    }
  }

  void _showNotification(String message, Account messageCreator) {
    var androidDetails = AndroidNotificationDetails("chat message id", "chat message name", "chat message description");
    var iosDetails = IOSNotificationDetails();
    NotificationHelper.notification.show(0, "${messageCreator.name}", "$message", NotificationDetails(androidDetails, iosDetails));
  }
}