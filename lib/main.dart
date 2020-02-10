import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gulmate/bloc/authentication/authentication.dart';
import 'package:gulmate/const/color.dart';
import 'package:gulmate/screens/home/home_screen.dart';
import 'package:gulmate/screens/views/check_invite/check_invite_wrapper.dart';
import 'package:gulmate/screens/views/intro/intro_wrapper.dart';
import 'package:gulmate/screens/views/sign_in/sign_in_view.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '귤메이트',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Color(0xFFFF6D00),
        fontFamily: "Spoqa",
        textSelectionColor: DEFAULT_BACKGROUND_COLOR,
      ),
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) => _buildScreenByAuth(state),
      )
//      BlocListener<AuthenticationBloc, AuthenticationState>(listener: (context, state) {
//        if(state is AuthenticationUninitialized) {
//          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => IntroWrapper()));
//        } else if(state is AuthenticationUnauthenticated) {
//          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignInWrapper()));
//        } else if(state is AuthenticationAuthenticated) {
//
//        } else if(state is AuthenticationLoading) {
//
//        }
//      }) ,
//      BlocBuilder<AuthenticationBloc, AuthenticationState>(builder: (context, state) {
//          if(state is AuthenticationUninitialized) {
//            return IntroWrapper();
//          } else if(state is AuthenticationUnauthenticated) {
//            return Signin();
//          } else if(state is AuthenticationAuthenticated) {
//            return BlocBuilder<FamilyBloc, FamilyState>(
//              builder: (context, familyState) {
//                if(familyState is FamilyLoading) {
//                  return LoadingIndicator();
//                } else if(familyState is FamilyNotLoaded) {
//                  return CheckInvitedPage();
//                } else {
//                  return HomeScreen();
//                }
//              },
//            );
//          } else {
//            return ErrorScreen();
//          }
//        },),
    );
  }

  Widget _buildScreenByAuth(AuthenticationState state) {
    if(state is AuthenticationLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator(),),);
    } else if(state is AuthenticationUninitialized) {
      return IntroWrapper();
    } else if(state is AuthenticationUnauthenticated) {
      return SignInView();
    } else if(state is AuthenticationAuthenticatedWithoutFamily) {
      return CheckInviteWrapper();
    } else if(state is AuthenticationAuthenticatedWithFamily) {
      return HomeScreen();
    } else {
      return Scaffold(body: Center(child: Text("Bad Access"),),);
    }

  }
}
