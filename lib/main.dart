import 'package:flutter/material.dart';
import 'package:gulmate/introduction_screen/my_introduction_screen.dart';
import 'package:quick_actions/quick_actions.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '귤메이트',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Color(0xFFFF6D00),
//        fontFamily: 'Spoqa',
      ),
      home: SafeArea(child: MyIntroductionScreen()),
    );
  }
}
