import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gulmate/bloc/authentication/authentication.dart';
import 'package:gulmate/bloc/authentication/authentication_bloc.dart';
import 'package:gulmate/bloc/login/login_bloc.dart';
import 'package:gulmate/screens/views/sign_in/widgets/social_login_button.dart';

class Signin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return BlocProvider<LoginBloc>(
          create: (context) => LoginBloc(
              authenticationBloc: BlocProvider.of<AuthenticationBloc>(context)),
          child: Scaffold(
            backgroundColor: Color(0xFFFF6D00),
            body: state is AuthenticationLoading ?
            Center(
              child: CircularProgressIndicator(backgroundColor: Colors.white,),
            )
        :Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: deviceSize.height * 0.15,
                  ),
                  Center(
                      child: Image(
                          image: AssetImage(
                              'images/logo_symbol/logoSymbolYy.png'))),
                  SizedBox(height: 30.0),
                  Center(
                      child: Image(
                          image: AssetImage(
                              'images/logo_symbol/logoTypeface_white.png'))),
                  SizedBox(
                    height: 20.0,
                  ),
                  Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        "귤메이트",
                        style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w300),
                      )),
                  SizedBox(
                    height: deviceSize.height * 0.15,
                  ),
                  SocialLoginButton(provider: OAuthProvider.GOOGLE),
                  SizedBox(
                    height: 20.0,
                  ),
                  SocialLoginButton(provider: OAuthProvider.FACEBOOK),
                ],
              ),
            )
          ),
        );
      },
    );
  }
}
