import 'package:flutter/material.dart';
import 'package:gulmate/const/resources.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

      ),
      body: ListView(
        children: <Widget>[
          Container(
            child: Image.asset(GulmateResources.PROFILE_PLACEHOLDER),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Text("이메일"),
                TextField(
                  readOnly: true,
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Text("이메일"),
                TextField(
                  readOnly: true,
                ),
              ],
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Text("이메일"),
                TextField(
                  readOnly: true,
                ),
              ],
            ),
          ),
          RaisedButton(
            onPressed: () {},
            child: Text("수정 완료"),
          ),
        ],
      ),
    );
  }
}
