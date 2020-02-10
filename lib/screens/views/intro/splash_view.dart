import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gulmate/bloc/intro/intro.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with TickerProviderStateMixin {

  static final offsetTop = 1000.0;
  final top1 = 44.0 + offsetTop;
  final top2 = 376.0 + offsetTop;
  final top3 = 708.0 + offsetTop;
  bool _isAnimating = false;

  AnimationController _fadeInController;

  final Image iconImage = Image.asset("images/logo_symbol/logoSymbolYy.png");
  final double animatedEnd = 2000.0;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isAnimating = true;
    });
    _fadeInController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this
    )..addStatusListener((status) {
      if(status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 1))
            .then((_) {
          BlocProvider.of<IntroBloc>(context).add(IntroUpdateEvent(IntroState.introduction));
        });
      }
    });
    Future.delayed(const Duration(milliseconds: 2000))
        .then((_) {
      _fadeInController.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFFF6D00),
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            _buildAnimatedImage(offset: Offset(top1, -50)),
            _buildAnimatedImage(offset: Offset(top2, -50)),
            _buildAnimatedImage(offset: Offset(top3, -50)),
            _buildAnimatedImage(offset: Offset(top1, 290)),
            _buildAnimatedImage(offset: Offset(top2, 290)),
            _buildAnimatedImage(offset: Offset(top3, 290)),
            _buildAnimatedImage(offset: Offset(size.width / 2 -60, 210 + offsetTop)),
            _buildAnimatedImage(offset: Offset(size.width / 2 - 60, 542 + offsetTop)),
            FadeTransition(
              opacity: Tween(begin: 0.0, end: 1.0).animate(_fadeInController),
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

  Widget _buildAnimatedImage({@required Offset offset})
    => AnimatedPositioned(
      child: iconImage,
      duration: const Duration(milliseconds: 2000),
      left: offset.dx,
      top: _isAnimating ? offset.dy - animatedEnd : offset.dy,
      curve: Curves.easeIn,
      onEnd: () {
        _fadeInController.forward();
      },
    );
}
