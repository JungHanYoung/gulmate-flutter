import 'package:flutter/material.dart';
import 'package:gulmate/widgets/GulmateLogo.dart';
import 'package:gulmate/screens/sign_up/create_family/create_family_screen.dart';
import 'package:gulmate/screens/sign_up/join_family/join_family_screen.dart';

class CheckInvitedPage extends StatelessWidget {

  String email;

  CheckInvitedPage({@required this.email});


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
              Center(child: GulmateLogo(
                size: 180.0,
              )),
              SizedBox(
                height: 50.0,
              ),
              Text("$email 님 안녕하세요."),
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
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => JoinFamilyScreen(),
                  ));
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
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => CreateFamilyScreen()
                  ));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
