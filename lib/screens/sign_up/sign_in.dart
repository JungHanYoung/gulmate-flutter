import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:gulmate/screens/sign_up/check_invited.dart';


class Signin extends StatefulWidget {
  Signin({
    Key key,
  }) : super(key: key);

  @override
  _SigninState createState() => _SigninState();
}

class _SigninState extends State<Signin> {

  bool _isSigning = false;
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: const <String>["email"]);
  FacebookLogin _facebookSignIn = FacebookLogin();

  Future<String> _handleGoogleSignIn() async {
    GoogleSignInAccount account = await _googleSignIn.signIn();
    print(account.email);
    return account.email;
  }

  Future<String> _handleFacebookSignIn() async {
    _facebookSignIn.loginBehavior = FacebookLoginBehavior.nativeOnly;
    final result = await _facebookSignIn.logIn(["email"]);
    print(result.status);

    switch(result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;
        print("success Facebook Login ${result.accessToken.token}");
        final graphResponse = await Dio().get('https://graph.facebook.com/v2.12/me?fields=name,email&access_token=$token');
        final rawData =json.decode(graphResponse.data);
        print(rawData['email']);
        return rawData['email'];
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
    final deviceSize = MediaQuery.of(context).size;
    return StreamBuilder<GoogleSignInAccount>(
      stream: _googleSignIn.onCurrentUserChanged,
      builder: (context, snapshot) {
        print(snapshot.data?.email);
        return SafeArea(
          bottom: true,
          child: Scaffold(
            backgroundColor: Color(0xFFFF6D00),
            body: ModalProgressHUD(
              inAsyncCall: _isSigning,
              progressIndicator: CircularProgressIndicator(backgroundColor: Colors.white,),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: deviceSize.height / 10,
                    ),
                    Center(child: Image(image: AssetImage('images/logo_symbol/logoSymbolYy.png'))),
                    SizedBox(height: 30.0),
                    Center(child: Image(image: AssetImage('images/logo_symbol/logoTypeface.png'))),
                    SizedBox(
                      height: 20.0,
                    ),
                    Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          "귤메이트",
                          style: TextStyle(fontSize: 20.0, color: Colors.white, fontWeight: FontWeight.w300),
                        )),
                    SizedBox(
                      height: deviceSize.height * 0.15,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: FlatButton(
                        padding: const EdgeInsets.symmetric(vertical: 17.0, horizontal: 36),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                            children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Icon(FontAwesomeIcons.google),
                          ), Text("구글 계정으로 로그인 하기", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),)]),
                        color: Colors.white,
                        textColor: Color(0xFFDB3236),
                        onPressed: () async {
                          print("구글로 로그인 성공");
                          String email = await _handleGoogleSignIn();
                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) => CheckInvitedPage(email: email),
                          ));
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: FlatButton(
                        padding: const EdgeInsets.symmetric(vertical: 17.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                            children: [Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Icon(FontAwesomeIcons.facebookSquare),
                            ), Text("페이스북으로 로그인 하기", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),)]),
                        color: Colors.white,
                        textColor: Color(0xFF3B5998),
                        onPressed: () async {
                          setState(() {
                            _isSigning = true;
                          });
                          String email = await _handleFacebookSignIn();  // COMPLETED: FACEBOOK 로그인 확인 완료, 토큰으로 이메일 조회
                          setState(() {
                            _isSigning = false;
                          });
                          Navigator.pushReplacement(context, MaterialPageRoute(
                            builder: (context) => CheckInvitedPage(email: email,),
                          ));
//                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CreateFamilyScreen()));
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    );
  }
}