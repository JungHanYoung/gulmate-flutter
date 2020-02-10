import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:gulmate/screens/sign_up/layout/join_family_layout.dart';
import 'package:gulmate/screens/sign_up/welcome/welcome_screen.dart';
import 'package:gulmate/services/auth_service.dart';
import 'package:gulmate/services/family_service.dart';
import 'package:provider/provider.dart';

class ShowInviteLinkScreen extends StatefulWidget {

  @override
  _ShowInviteLinkScreenState createState() => _ShowInviteLinkScreenState();
}

class _ShowInviteLinkScreenState extends State<ShowInviteLinkScreen> {

  bool _isCopiedLink = false;
  bool _loadingCopied = false;

  @override
  Widget build(BuildContext context) {
    AuthService authService = Provider.of<AuthService>(context, listen: false);
    FamilyService familyService = Provider.of<FamilyService>(context, listen: false);
    return JoinFamilyLayout(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text("${authService.account.name}님의\n가족을 초대해주세요",
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                  color: Color(0xFF222222))),
          SizedBox(height: 20),
          Text(
            "아래 초대 링크를 복사하셔서\n이메일 또는 메신저로 링크를 보내 주세요.",
            style: TextStyle(
              color: Color.fromRGBO(153, 153, 153, 1),
              fontSize: 16,
            ),
          ),
          SizedBox(height: 52),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("초대 링크"),
                Container(
                  padding: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom:
                          BorderSide(color: Color.fromRGBO(221, 221, 221, 1)),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        "${familyService.getFamily.inviteKey}",
                        style: TextStyle(fontSize: 16),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            _loadingCopied = true;
                          });
                          Clipboard.setData(ClipboardData(
                                  text: familyService.getFamily.inviteKey))
                              .then((result) {
                            setState(() {
                              _loadingCopied = false;
                              _isCopiedLink = true;
                            });
                          });
                        },
                        child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                              border: Border.all(
                                  color: Color.fromRGBO(221, 221, 221, 1)),
                            ),
                            child: _loadingCopied
                                ? SizedBox(
                                    width: 12,
                                    height: 12,
                                    child: CircularProgressIndicator())
                                : _isCopiedLink ? Icon(Icons.check, color: Color(0xFFFF6D00),) : Text(" 복사",
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFFFF6D00)))),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          RaisedButton(
            padding: const EdgeInsets.symmetric(vertical: 18),
            color: Color(0xFFFF6D00),
            elevation: 0.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
            },
            child: Text("다음 단계", style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }
}
