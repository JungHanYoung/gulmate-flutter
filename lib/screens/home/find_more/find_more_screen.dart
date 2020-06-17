import 'package:flutter/material.dart';
import 'package:gulmate/const/resources.dart';

class FindMoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Image.asset(GulmateResources.PROFILE_PLACEHOLDER),
                  Text("홍길동"),
                  Text("가족 그룹 명"),
                ],
              ),
            ),
            Container(
              child: Text("내 정보 수정하기"),
            ),
            Container(
              child: Text("새로운 가족 구성 만들기"),
            ),
            Container(
              child: Text("가족 초대하기"),
            ),
            Container(
              child: Text("가족 그룹에서 나가기"),
            ),
          ],
        )
    );
  }
}
