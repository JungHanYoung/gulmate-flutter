import 'dart:math';

import 'package:flutter/material.dart';

class GulmateLogo extends StatefulWidget {

  double size;
  Duration duration;
  Curve curve;

  GulmateLogo({
    Key key,
    this.size,
    this.curve = Curves.fastOutSlowIn,
    this.duration = const Duration(milliseconds: 750),
  }) : super(key: key);

  @override
  _GulmateLogoState createState() => _GulmateLogoState();
}

class _GulmateLogoState extends State<GulmateLogo> with SingleTickerProviderStateMixin {

  AnimationController _animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animation = AnimationController(
      duration: const Duration(milliseconds: 750),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final IconThemeData iconTheme = IconTheme.of(context);
    final double iconSize = widget.size ?? iconTheme.size;

//    return AnimatedContainer(
//      width: iconSize,
//      height: iconSize,
//      duration: widget.duration,
//      curve: widget.curve,
//      decoration: BoxDecoration(
//        image: DecorationImage(
//          image: AssetImage("images/logo_symbol/logoSymbolYy.png"),
//          fit: BoxFit.cover,
//        )
//      )
//    );

    return AnimatedBuilder(
      animation: Tween(begin: 0, end: 2 * pi).animate(_animation),
      builder: (context, child) {
        return Transform.rotate(angle: _animation.value, child: FlutterLogo());
      },
    );
  }
}
