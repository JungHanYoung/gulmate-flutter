import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gulmate/bloc/login/login_bloc.dart';
import 'package:gulmate/bloc/login/login_event.dart';
import 'package:gulmate/screens/error_screen.dart';


enum OAuthProvider {
  GOOGLE, FACEBOOK
}

class SocialLoginButton extends StatelessWidget {
  final OAuthProvider provider;

  SocialLoginButton({
    @required this.provider
}) : assert(provider != null);

  @override
  Widget build(BuildContext context) {
    if(provider == OAuthProvider.GOOGLE) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: FlatButton(
          padding: const EdgeInsets.symmetric(
              vertical: 17.0, horizontal: 36),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(FontAwesomeIcons.google),
            ),
            Text(
              "구글 계정으로 로그인 하기",
              style: TextStyle(
                  fontSize: 16.0, fontWeight: FontWeight.bold),
            )
          ]),
          color: Colors.white,
          textColor: Color(0xFFDB3236),
          onPressed: () async {
            try {
              BlocProvider.of<LoginBloc>(context).add(GoogleLoginButtonPressed());
            } catch (e) {
              showDialog(
                  context: context,
                  child: AlertDialog(
                    title: Text("Facebook Login Error"),
                    content: Text("페이스북 로그인에 실패하였습니다."),
                  ));
            }
          },
        ),
      );
    } else if(provider == OAuthProvider.FACEBOOK) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: FlatButton(
          padding: const EdgeInsets.symmetric(vertical: 17.0),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Icon(FontAwesomeIcons.facebookSquare),
            ),
            Text(
              "페이스북으로 로그인 하기",
              style: TextStyle(
                  fontSize: 16.0, fontWeight: FontWeight.bold),
            )
          ]),
          color: Colors.white,
          textColor: Color(0xFF3B5998),
          onPressed: () async {
            try {
              BlocProvider.of<LoginBloc>(context).add(FacebookLoginButtonPressed());
            } catch (e) {
              showDialog(
                  context: context,
                  child: AlertDialog(
                    title: Text("Facebook Login Error"),
                    content: Text("페이스북 로그인에 실패하였습니다."),
                  ));
            }
          },
        ),
      );
    } else {
      return ErrorScreen();
    }
  }
}
