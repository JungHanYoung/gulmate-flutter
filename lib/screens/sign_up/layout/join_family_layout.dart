import 'package:flutter/material.dart';

class JoinFamilyLayout extends StatelessWidget {

  final Widget child;

  JoinFamilyLayout({
    @required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: size.height * 0.15),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
                boxShadow: [
                  BoxShadow(offset: Offset(1,1), blurRadius: 10.0, spreadRadius: 10.0, color: Color.fromRGBO(249, 249, 249, 1)),
                ]
            ),
            padding: const EdgeInsets.only(top: 50, left: 25, right: 25, bottom: 30),
            child: child,
          )
        ],
      ),
    );
  }
}
