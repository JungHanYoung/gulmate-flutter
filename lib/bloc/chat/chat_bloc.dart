import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:gulmate/bloc/blocs.dart';
import 'package:gulmate/bloc/chat/chat_event.dart';
import 'package:gulmate/bloc/chat/chat_state.dart';
import 'package:gulmate/model/message.dart';
import 'package:gulmate/repository/chat_repository.dart';
import 'package:gulmate/repository/family_repository.dart';
import 'package:gulmate/repository/repository.dart';
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


  ChatBloc({
    @required this.appTabBloc,
    @required this.authenticationBloc}) {
    _chatRepository = GetIt.instance.get<ChatRepository>();
    _familyRepository = GetIt.instance.get<FamilyRepository>();
    _userRepository = GetIt.instance.get<UserRepository>();
    _appTabSubscription = appTabBloc.listen((state) {
      if(state == AppTab.chatting) {
        add(FetchChatMessage());
      }
    });
  }

  @override
  // TODO: implement initialState
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
      _stompClient = StompClient(
          config: StompConfig(
            url: "ws://192.168.0.111:8080/ws",
            stompConnectHeaders: {
              'Authorization': 'Bearer ${_userRepository.token}'
            },
            onConnect: (client, frame) {
              print('stomp client connected: ${client.connected}');
              final destination = "/sub/family/${_familyRepository.family.id}";
              client.subscribe(destination: destination, callback: (frame) {
                print("subscribe: ${frame.body}");
                add(ReceiveChatMessage(jsonDecode(frame.body)));
              });
            },
            onStompError: (error) {
              print(error.toString());
            },
            onWebSocketDone: () {
              print("on websocket done");
            }
          ),
      );
      _stompClient.activate();
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
    if(state is ChatLoaded) {
      final messageList = (state as ChatLoaded).messageList;
      yield ChatLoading();
      messageList.add(Message(message: event.message, creator: messageCreator));
      yield ChatLoaded(messageList);
    }
  }
}