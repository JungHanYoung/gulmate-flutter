import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gulmate/screens/introduction_screen/my_introduction_screen.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {



  static final offsetTop = 1000.0;
  final top1 = 44.0 + offsetTop;
  final top2 = 376.0 + offsetTop;
  final top3 = 708.0 + offsetTop;
  bool _isAnimating = false;

  AnimationController _controller;
  Animation<double> _animation;

  final Image iconImage = Image.asset("images/logo_symbol/logoSymbolYy.png");
  final double animatedEnd = 2000.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 2)).then((value) {
      setState(() {
        _isAnimating = true;
      });
      Future.delayed(Duration(milliseconds: 1500))
        .then((value) {
          _controller.forward();
      });
    });
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Future.delayed(Duration(seconds: 1))
            .then((value) {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => MyIntroductionScreen()));
          });
        }
      });
//    )..addStatusListener((status) {
//        if (status == AnimationStatus.completed) {
//          print("animation complete!!");
//        }
//      });
//    _animation = Tween<double>(begin: 0, end: 3000).animate(_controller);
//    _controller.forward();
//    Future.delayed(const Duration(seconds: 2))
//      .then((value) {
//        _controller.forward();
//    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(color: Color(0xFFFF6D00)),
        ),
        _buildAnimatedImage(top: top1, left: -50),
        _buildAnimatedImage(top: top2, left: -50),
        _buildAnimatedImage(top: top3, left: -50),
        _buildAnimatedImage(top: top1, left: 290),
        _buildAnimatedImage(top: top2, left: 290),
        _buildAnimatedImage(top: top3, left: 290),
        _buildAnimatedImage(top: 210 + offsetTop, left: size.width / 2 - 60),
        _buildAnimatedImage(top: 542 + offsetTop, left: size.width / 2 - 60),
        FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(_controller),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset("images/logo_symbol/logoTypeface_white.png"),
                Text("귤메이트", style: TextStyle(fontSize: 20.0, color: Colors.white)),
              ],
            ),
          ),
        )
      ],
    ));
  }

  Widget _buildAnimatedImage({@required double top, @required double left}) =>
      AnimatedPositioned(
        child: iconImage,
        duration: const Duration(milliseconds: 2000),
        left: left,
        top: _isAnimating ? top - animatedEnd : top,
        curve: Curves.easeIn,
      );
}
