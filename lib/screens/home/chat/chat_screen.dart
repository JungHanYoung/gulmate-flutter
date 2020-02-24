import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:gulmate/bloc/blocs.dart';
import 'package:gulmate/const/color.dart';
import 'package:gulmate/model/message.dart';
import 'package:gulmate/repository/repository.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

const dummy = [
  {
    "message": "다들 오늘 몇시에 와?",
    "isMe": false,
  },
  {
    "message": "나는 잘 모르겠어 조별과제 때문에 늦게 들어갈 것 같아",
    "isMe": false,
  },
  {
    "message": "나도 잘 모르겠네 내일 시험이라서 시험공부 해야대",
    "isMe": true,
  },
  {
    "message": "나 혼자 저녁 먹어야겠네",
    "isMe": false,
  },
];

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  final _messageController = TextEditingController();

  void onConnectCallback(StompClient client, StompFrame connectFrame) {
    print(connectFrame.body);
    client.subscribe(destination: "/topic/greetings", callback: (frame) {
      print(frame.body);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          color: Color.fromRGBO(245, 245, 245, 1),
          padding:
              const EdgeInsets.only(top: 90, left: 25, right: 25, bottom: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              BlocBuilder<FamilyBloc, FamilyState>(
                builder: (context, state) => Text(
                  (state as FamilyLoaded).family.familyName,
                  style: TextStyle(
                    color: PRIMARY_COLOR,
                    fontSize: 30,
                  ),
                ),
              ),
              Icon(Icons.search),
            ],
          ),
        ),
        BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, auth)
            => BlocBuilder<ChatBloc, ChatState>(
            builder: (context, state) {
              if(state is ChatLoading) {
                return Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              } else if(state is ChatLoaded) {
                final messageList = state.messageList;
                return Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    reverse: true,
                    children: messageList.reversed.map((Message chatMessage) {
                      bool isMe = chatMessage.creator.id == (auth as AuthenticationAuthenticatedWithFamily).currentAccount.id;
                      String message = chatMessage.message;
                      final children = <Widget>[
                        Flexible(
                          child: Container(
                            width: 261,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 26, vertical: 12),
                            decoration: BoxDecoration(
                              color: isMe ? Color.fromRGBO(255, 212, 0, 1) : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(message, style: TextStyle(fontSize: 16),),
                          ),
                        )
                      ];
                      if (!isMe) {
                        children.insert(0, Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(chatMessage.creator.photoUrl),
                          ),
                        ));
                      }
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: children,
                        ),
                      );
                    }).toList(),
                  ),
                );
//                return Expanded(
//                    child: ListView.builder(
//                        padding: EdgeInsets.symmetric(horizontal: 25),
//                        reverse: true,
//                        itemCount: messageList.length,
//                        itemBuilder: (context, index) {
//                          bool isMe = messageList[index].creator.id == (auth as AuthenticationAuthenticatedWithFamily).currentAccount.id;
//                          String message = messageList[index].message;
//                          final children = <Widget>[
//                            Flexible(
//                              child: Container(
//                                width: 261,
//                                padding: const EdgeInsets.symmetric(
//                                    horizontal: 26, vertical: 12),
//                                decoration: BoxDecoration(
//                                  color: isMe ? Color.fromRGBO(255, 212, 0, 1) : Colors.white,
//                                  borderRadius: BorderRadius.circular(16),
//                                ),
//                                child: Text(message, style: TextStyle(fontSize: 16),),
//                              ),
//                            )
//                          ];
//                          if (!isMe) {
//                            children.insert(0, Padding(
//                              padding: const EdgeInsets.only(right: 4.0),
//                              child: CircleAvatar(
//                                backgroundImage: NetworkImage(messageList[index].creator.photoUrl),
//                              ),
//                            ));
//                          }
//                          return Container(
//                            padding: const EdgeInsets.symmetric(vertical: 8),
//                            child: Row(
//                              mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
//                              crossAxisAlignment: CrossAxisAlignment.start,
//                              children: children,
//                            ),
//                          );
//                        })
//                );
              } else {
                return Expanded(
                  child: Center(
                    child: Text("Error: Fetch chat message list"),
                  ),
                );
              }
          }),
        ),
        Container(
          margin: const EdgeInsets.only(left: 25, right: 25, bottom: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30)
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: TextField(
                  showCursor: false,
                  style: TextStyle(fontSize: 16),
                  maxLines: 3,
                  minLines: 1,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                  controller: _messageController,
                ),
              )),
              InkWell(
                onTap: _sendMessage,
                child: Container(
                  padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12, top: 12),
                  decoration: BoxDecoration(
                    color: PRIMARY_COLOR,
                    shape: BoxShape.circle
                  ),
                  child: Icon(Icons.keyboard_return, color: Colors.white, size: 16,),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _sendMessage() {
    if(_messageController.text.isNotEmpty) {
      final message = _messageController.text;
      BlocProvider.of<ChatBloc>(context).add(SendChatMessage(message));
      _messageController.clear();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
