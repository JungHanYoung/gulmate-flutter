import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gulmate/bloc/intro/intro.dart';
import 'package:gulmate/screens/views/intro/splash_view.dart';

import 'introduction_view.dart';

class IntroWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IntroBloc, IntroState>(
      builder: (context, intro) => _buildIntroView(intro),
    );
  }

  Widget _buildIntroView(IntroState intro) {
    switch(intro) {
      case IntroState.splash:
        return SplashView();
      case IntroState.introduction:
        return IntroductionView();
      default:
        return Scaffold();
    }
  }
}
