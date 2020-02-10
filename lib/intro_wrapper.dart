import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gulmate/screens/error_screen.dart';
import 'package:gulmate/screens/introduction_screen/my_introduction_screen.dart';
import 'package:gulmate/screens/sign_up/sign_in.dart';
import 'package:gulmate/screens/splash_screen.dart';

import 'bloc/intro/intro.dart';

class IntroWrapper extends StatelessWidget {
  final Widget child;

  IntroWrapper({
    @required this.child
  }) : assert(child != null);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IntroBloc, IntroState>(
      builder: (context, intro) => _buildIntroBody(intro),
    );
  }

  Widget _buildIntroBody(IntroState intro) {
    switch(intro) {
      case IntroState.splash:
        return SplashScreen();
      case IntroState.introduction:
        return MyIntroductionScreen();
      case IntroState.signIn:
        return Signin();
      default:
        return ErrorScreen();
    }
  }
}
