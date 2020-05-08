import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:gulmate/bloc/authentication/authentication.dart';
import 'package:gulmate/const/color.dart';
import 'package:gulmate/screens/home/setting/invite_key_bottom_sheet.dart';

const _personalColors = <Color>[
  Colors.blue,
  Colors.black38,
  Colors.deepPurple,
  Colors.green,
  Colors.lightBlueAccent,
  Colors.black12,
  Colors.deepPurpleAccent,
  Colors.orange,
  Colors.pinkAccent,
  Colors.redAccent,
  Colors.teal,
  Colors.yellowAccent,
];

class SettingScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  static const _titleTextStyle = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  static const _headTextStyle = const TextStyle(
    color: Color.fromRGBO(153, 153, 153, 1),
  );
  static const _descriptionTextStyle = const TextStyle(
    color: Color.fromRGBO(153, 153, 153, 1),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Gulmate",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: PRIMARY_COLOR,
        elevation: 1.0,
      ),
      body: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) => ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "MEMBERS",
                    style: _titleTextStyle,
                  ),
                  Text(
                    "These are the people inside your gulmate, and you can invite more people to join below",
                    style: _descriptionTextStyle,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ...(state as AuthenticationAuthenticatedWithFamily)
                      .currentFamily
                      .accountList
                      .map((account) {
                    return _buildMember(
                        account.name, account.photoUrl, Colors.green);
                  }).toList(),
                  Divider(),
                  InkWell(
                      onTap: () {
                        print("다른 가족 초대하기 누름");
                        showModalBottomSheet(
                            context: context,
                            builder: (context) => InviteKeyBottomSheet(
                                inviteKey: (state
                                        as AuthenticationAuthenticatedWithFamily)
                                    .currentFamily
                                    .inviteKey));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12.0, top: 8),
                        child: Row(
                          children: <Widget>[
                            Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.add,
                                color: PRIMARY_COLOR,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Text(
                                "다른 가족 초대하기",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 25),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 16),
                  Text(
                    "Appearance",
                    style: _titleTextStyle,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "This is how you appear in the gulmate",
                    style: _descriptionTextStyle,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Container(
                        alignment: Alignment.centerLeft,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(
                              (state as AuthenticationAuthenticatedWithFamily)
                                  .currentAccount
                                  .photoUrl),
                        )),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              color: Color.fromRGBO(221, 221, 221, 1)),
                          bottom: BorderSide(
                              color: Color.fromRGBO(221, 221, 221, 1))),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Flexible(flex: 1, child: Text("별명")),
                        Expanded(
                            flex: 3,
                            child: TextField(
                              onSubmitted: (nick) {
                                print(nick);
                              },
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: (state
                                          as AuthenticationAuthenticatedWithFamily)
                                      .currentAccount
                                      .name),
                            )),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            assert(_personalColors.length == 12);
                            List<List<Color>> colorFor2dArr =
                                List<List<Color>>();
                            for (int i = 0;
                                i < _personalColors.length ~/ 4;
                                i++) {
                              var tempList = List<Color>();
                              for (int j = 0; j < 4; j++) {
                                tempList.add(_personalColors[(4 * i) + j]);
                              }
                              colorFor2dArr.add(tempList);
                            }
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25, vertical: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Text(
                                    "색 선택",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "귤메이트에서 각 사람을 표현하는 색을 선택합니다.",
                                    style: TextStyle(
                                        color:
                                            Color.fromRGBO(153, 153, 153, 1)),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Expanded(
                                    child: BlockPicker(
                                      pickerColor: Colors.green,
                                      onColorChanged: (color) {
                                        print(color);
                                      },
                                      itemBuilder:
                                          (color, isCurrentColor, changeColor) {
                                        return Container(
                                          margin: const EdgeInsets.all(5),
                                          padding: const EdgeInsets.all(1),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: color,
                                          ),
                                          child: InkWell(
                                            onTap: changeColor,
                                            child: true
                                                ? CircleAvatar()
                                                : SizedBox.shrink(),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            );
                          });
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(flex: 1, child: Text("색")),
                          Expanded(
                            flex: 3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Container(
                                  width: 40,
                                  height: 20,
                                  decoration: BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                                Icon(Icons.chevron_right)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              color: Colors.white,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Account",
                      style: _titleTextStyle,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "your account details",
                      style: _descriptionTextStyle,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                  color: Color.fromRGBO(221, 221, 221, 1)))),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                              child: Text(
                            "이름",
                            style: _headTextStyle,
                          )),
                          Flexible(
                              flex: 3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text("정한영"),
                                ],
                              )),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(
                                  color: Color.fromRGBO(221, 221, 221, 1)))),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Flexible(
                              child: Text(
                            "이메일",
                            style: _headTextStyle,
                          )),
                          Flexible(
                              flex: 3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text("8735132@naver.com"),
                                ],
                              )),
                        ],
                      ),
                    )
                  ]),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: FlatButton(
                color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  onPressed: () {
                    BlocProvider.of<AuthenticationBloc>(context).add(LoggedOut());
                  },
                  child: Text(
                    "로그아웃",
                    style: TextStyle(color: Colors.red),
                  )),
            ),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  Padding _buildMember(String memberName, String memberImageUrl, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundImage: NetworkImage(memberImageUrl),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    memberName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(memberName),
                ],
              ),
            ),
          ),
          CircleAvatar(
            backgroundColor: color,
          ),
        ],
      ),
    );
  }
}
