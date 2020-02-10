import 'package:flutter/material.dart';
import 'package:gulmate/const/color.dart';
import 'package:gulmate/screens/home/home_screen.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: DEFAULT_BACKGROUND_COLOR,
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned(
            top: size.height * 0.35,
              right: size.width * 0.05,
              child: Image.asset("images/logo_symbol/logoSymbolYy.png")),
          Positioned(
              top: size.height * 0.52,
              left: -size.width * 0.16,
              child: Image.asset("images/logo_symbol/logoSymbolYy.png")),
          Positioned(
              top: size.height * 0.7,
              right: -size.width * 0.1,
              child: Image.asset("images/logo_symbol/logoSymbolYy.png")),
          Positioned(
              top: size.height * 0.85,
              left: size.width * 0.03,
              child: Image.asset("images/logo_symbol/logoSymbolYy.png")),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 144,
                ),
                Text(
                  "축하합니다!\n귤메이트 가족이 만들어졌어요.",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20,),
                Text(
                  "함께 귤 까먹으며\n일상을 함께 해볼까요?",
                  style: TextStyle(
                      fontWeight: FontWeight.w300, color: Colors.white, fontSize: 16),
                ),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          RaisedButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
                            },
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              "네! 좋아요",
                              style: TextStyle(
                                  color: DEFAULT_BACKGROUND_COLOR,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16),
                            ),
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ]
      ),
    );
  }
}
