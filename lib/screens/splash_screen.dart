import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gulmate/bloc/intro/intro.dart';
import 'package:gulmate/const/resources.dart';


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

  final Image iconImage = Image.asset(GulmateResources.GULMATE_LOGO_SYMBOL);
  final double animatedEnd = 2000.0;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isAnimating = true;
    });
    Future.delayed(Duration(milliseconds: 1500))
        .then((value) {
      _controller.forward();
    });
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Future.delayed(Duration(seconds: 1))
            .then((value) {
              BlocProvider.of<IntroBloc>(context).add(IntroUpdateEvent(IntroState.introduction));
          });
        }
      });
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
        _buildAnimatedImage(offset: Offset(top1, -50)),
        _buildAnimatedImage(offset: Offset(top2, -50)),
        _buildAnimatedImage(offset: Offset(top3, -50)),
        _buildAnimatedImage(offset: Offset(top1, 290)),
        _buildAnimatedImage(offset: Offset(top2, 290)),
        _buildAnimatedImage(offset: Offset(top3, 290)),
        _buildAnimatedImage(offset: Offset(size.width / 2 -60, 210 + offsetTop)),
        _buildAnimatedImage(offset: Offset(size.width / 2 - 60, 542 + offsetTop)),
        FadeTransition(
          opacity: Tween(begin: 0.0, end: 1.0).animate(_controller),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Image.asset(GulmateResources.GULMATE_LOGO_TYPEFACE_WHITE),
                Text("귤메이트", style: TextStyle(fontSize: 20.0, color: Colors.white)),
              ],
            ),
          ),
        )
      ],
    ));
  }

  Widget _buildAnimatedImage({@required Offset offset})
    => AnimatedPositioned(
        child: iconImage,
        duration: const Duration(milliseconds: 2000),
        left: offset.dx,
        top: _isAnimating ? offset.dy - animatedEnd : offset.dy,
        curve: Curves.easeIn,
      );
}
