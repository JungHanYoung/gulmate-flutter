import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gulmate/const/color.dart';
import 'package:gulmate/screens/home/home_screen.dart';
import 'package:gulmate/screens/views/check_invite/check_invite_wrapper.dart';
import 'package:gulmate/screens/views/sign_in/sign_in_view.dart';

import 'bloc/blocs.dart';
import 'wrapper/intro_wrapper.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
    ));
    return MaterialApp(
      title: '귤메이트',
      theme: ThemeData(
        accentColor: Color(0xFFFF6D00),
        fontFamily: "Spoqa",
        textSelectionColor: PRIMARY_COLOR,
      ),
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) => _buildScreenByAuth(state),
      ),
    );
  }

  Widget _buildScreenByAuth(AuthenticationState state) {
    if (state is AuthenticationLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (state is AuthenticationUninitialized) {
      return IntroWrapper();
    } else if (state is AuthenticationUnauthenticated) {
      return SignInView();
    } else if (state is AuthenticationAuthenticatedWithoutFamily) {
      return CheckInviteWrapper();
    } else if (state is AuthenticationAuthenticatedWithFamily) {
      return HomeScreen();
    } else {
      return Scaffold(
        body: Center(
          child: Text("Bad Access"),
        ),
      );
    }
  }
}
