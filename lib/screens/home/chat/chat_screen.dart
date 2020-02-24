import 'package:flutter/material.dart';
import 'package:gulmate/const/color.dart';
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

  StompClient _stompClient;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _stompClient = StompClient(
      config: StompConfig(
        url: 'ws://localhost:8080/gs-guide-websocket',
        stompConnectHeaders: {
          "Authorization": "Bearer qojp1mp91mcp93ekpf"
        },
        onConnect: onConnectCallback,
        onDebugMessage: (message) {
          print("debug");
        },
        onWebSocketError: (frame) {
          print("websocket error");
        },
        onStompError: (frame) {
          print('stomp error');
        }
      ),
    );
    _stompClient.activate();
  }

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
              Text(
                "패밀리 이름",
                style: TextStyle(
                  color: PRIMARY_COLOR,
                  fontSize: 30,
                ),
              ),
              Icon(Icons.search),
            ],
          ),
        ),
        Expanded(
            child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 25),
                itemCount: dummy.length,
                itemBuilder: (context, index) {
                  bool isMe = dummy[index]['isMe'];
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
                        child: Text(dummy[index]['message'], style: TextStyle(fontSize: 16),),
                      ),
                    )
                  ];
                  if (!isMe) {
                    children.insert(0, CircleAvatar());
                  }
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: children,
                    ),
                  );
                }))
      ],
    );
  }
}
