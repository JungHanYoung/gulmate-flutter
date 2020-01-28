import 'package:flutter/material.dart';

class AlbumScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Text("갤러리"),
          ListView(
            children: <Widget>[
              Card(
                child: Column(
                  children: <Widget>[

                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
