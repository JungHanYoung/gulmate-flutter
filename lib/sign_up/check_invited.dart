import 'package:flutter/material.dart';

class CheckInvitedPage extends StatelessWidget {
  const CheckInvitedPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 70.0,
              ),
              Center(child: FlutterLogo(size: 180.0,)),
              SizedBox(
                height: 50.0,
              ),
              Align(
                alignment: Alignment.center,
                child: Text("혹시 초대를 받으셨나요?", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
              ),
              SizedBox(
                height: 208.0,
              ),
              FlatButton(
                padding: const EdgeInsets.symmetric(vertical: 17.0),
                child: Text(
                  "네, 초대 받았습니다.",
                  style: TextStyle(fontSize: 16.0),
                ),
                color: Colors.black,
                textColor: Colors.white,
                onPressed: () {
                  print("초대쪽으로");
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              FlatButton(
                padding: const EdgeInsets.symmetric(vertical: 17.0),
                child: Text(
                  "아니오, 제가 첫 가족 구성원입니다.",
                  style: TextStyle(fontSize: 16.0),
                ),
                color: Colors.black,
                textColor: Colors.white,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
