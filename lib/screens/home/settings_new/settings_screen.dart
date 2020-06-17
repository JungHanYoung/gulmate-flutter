import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gulmate/bloc/authentication/authentication.dart';
import 'package:gulmate/bloc/blocs.dart';
import 'package:gulmate/const/resources.dart';
import 'package:gulmate/screens/home/setting/invite_key_bottom_sheet.dart';
import 'package:gulmate/screens/home/settings_new/edit_my_profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, auth) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              SizedBox(height: 20,),
              Image(
                height: 40,
                  image: AssetImage(GulmateResources.GULMATE_LOGO_TYPEFACE_ACCENT)),
              SizedBox(height: 36,),
              Expanded(child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SizedBox(
                      width: 100,
                        height: 100,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundImage: NetworkImage("${(auth as AuthenticationAuthenticatedWithFamily).currentAccount.photoUrl}"),
                        ),),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    child: Text(
                        "${(auth as AuthenticationAuthenticatedWithFamily).currentAccount.nickname ?? (auth as AuthenticationAuthenticatedWithFamily).currentAccount.name}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color.fromRGBO(34, 34, 34, 1)
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    alignment: Alignment.center,
                    child: Text(
                        "${(auth as AuthenticationAuthenticatedWithFamily).currentFamily.familyName}",
                      style: TextStyle(fontSize: 16, color: Color.fromRGBO(153, 153, 153, 1)),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        decoration: BoxDecoration(
                            border: Border(top:BorderSide(color: Color.fromRGBO(221, 221, 221, 1)))
                        ),
                        child: FlatButton(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            onPressed: () {
                              print("내정보 수정하기");
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditMyProfileScreen()));
                            }, child: Text("내정보 수정하기", style: TextStyle(color: Color.fromRGBO(34, 34, 34, 1), fontSize: 16),)),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border(top:BorderSide(color: Color.fromRGBO(221, 221, 221, 1)))
                        ),
                        child: FlatButton(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            onPressed: () {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) => InviteKeyBottomSheet(inviteKey: (auth as AuthenticationAuthenticatedWithFamily).currentFamily.inviteKey)
                              );
                              print("가족 초대하기");
                            }, child: Text("가족 초대하기", style: TextStyle(color: Color.fromRGBO(34, 34, 34, 1), fontSize: 16),)),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border(top:BorderSide(color: Color.fromRGBO(221, 221, 221, 1)))
                        ),
                        child: FlatButton(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            onPressed: () {
                              print("가족 탈퇴하기");
                              showCupertinoDialog(context: context, builder: (context) => CupertinoAlertDialog(
                                title: Text("가족 탈퇴"),
                                content: Text("가족 탈퇴를 진행하시겠습니까?"),
                                actions: <Widget>[
                                  FlatButton(onPressed: () {
                                    print("취소");
                                    Navigator.of(context).pop();
                                  }, child: Text("취소")),
                                  FlatButton(onPressed: () {
                                    print("확인");
                                    BlocProvider.of<FamilyBloc>(context).add(WithdrawFamily());
                                    Navigator.of(context).pop();
                                  }, child: Text("확인", style: TextStyle(color: Colors.red),)),
                                ],
                              ));
                            }, child: Text("가족 탈퇴하기", style: TextStyle(color: Color.fromRGBO(224, 32, 32, 1), fontSize: 16),)),
                      ),
                    ],
                  ),

                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
