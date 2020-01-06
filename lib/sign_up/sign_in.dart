import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class Signin extends StatelessWidget {
  Signin({
    Key key,
  }) : super(key: key);

  GoogleSignIn signIn = GoogleSignIn(scopes: const <String>["email"]);
  FacebookLogin _facebookLogin = FacebookLogin();

  Future<void> _handleGoogleSignIn() async {
    GoogleSignInAccount account = await signIn.signIn();
    print(account.email);
  }

  Future<void> _handleFacebookSignIn() async {
    _facebookLogin.loginBehavior = FacebookLoginBehavior.nativeOnly;
    final result = await _facebookLogin.logIn(["email"]);

    switch(result.status) {
      case FacebookLoginStatus.loggedIn:
        print("success Facebook Login ${result.accessToken.token}");
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("페이스북 로그인 취소");
        break;
      case FacebookLoginStatus.error:
        print("에러 발생");
        break;
      default:
        break;
    }
  }

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
                  alignment: Alignment.topCenter,
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.bold),
                  )),
              SizedBox(
                height: 208.0,
              ),
              FlatButton(
                padding: const EdgeInsets.symmetric(vertical: 17.0),
                child: Text("구글로 로그인 하기"),
                color: Colors.red,
                textColor: Colors.white,
                onPressed: () {
                  print("구글로 로그인 성공");
                  _handleGoogleSignIn();
//                  Navigator.pushReplacement(context, MaterialPageRoute(
//                    builder: (context) => CheckInvitedPage(),
//                  ));
                },
              ),
              SizedBox(
                height: 10.0,
              ),
              FlatButton(
                padding: const EdgeInsets.symmetric(vertical: 17.0),
                child: Text("페이스북으로 로그인 하기"),
                color: Colors.blue[900],
                textColor: Colors.white,
                onPressed: () async {
                  await _handleFacebookSignIn();
                  print("페이스북으로 로그인 성공");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}