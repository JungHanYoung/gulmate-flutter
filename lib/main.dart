import 'package:flutter/material.dart';
import 'package:gulmate/screens/splash_screen.dart';
import 'package:gulmate/services/auth_service.dart';
import 'package:gulmate/services/family_service.dart';
import 'package:provider/provider.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>.value(value: AuthService()),
        ChangeNotifierProvider<FamilyService>.value(value: FamilyService()),
      ],
      child: MaterialApp(
        title: '귤메이트',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Color(0xFFFF6D00),
          fontFamily: "Spoqa",
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
//      home: FutureBuilder(
//        future: Future.delayed(Duration(seconds: 2)),
//        builder: (context, snapshot) {
//          return MyIntroductionScreen();
//        },
//      )
//      home: CustomSplash(
//        imagePath: 'images/logo_symbol/logoSymbolYy.png',
//        backGroundColor: Colors.deepOrange,
//        animationEffect: 'zoom-in',
//        logoSize: 200,
//        home: MyIntroductionScreen(),
//        customFunction: () {
//          print("animated..");
//          return "value";
//        },
//        duration: 2500,
//        type: CustomSplashType.StaticDuration,
//      ),
//      home: SafeArea(child: MyIntroductionScreen()),
      ),
    );
  }
}
