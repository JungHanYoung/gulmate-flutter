import 'package:flutter/material.dart';
import 'package:gulmate/model/family.dart';
import 'package:gulmate/screens/sign_up/create_family/show_invite_link_screen.dart';
import 'package:gulmate/services/family_service.dart';
import 'package:provider/provider.dart';

class CreateFamilyScreen extends StatefulWidget {
  @override
  _CreateFamilyScreenState createState() => _CreateFamilyScreenState();
}

enum FamilyType { ONLY, MORE_TWO }

class _CreateFamilyScreenState extends State<CreateFamilyScreen> {
  bool _isSubmitting = false;
  FamilyType _selectedFamilyType;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _familyNameController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _familyNameController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _familyNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        Container(
          color: Color.fromRGBO(245, 245, 245, 1),
          child: Stack(
            children: <Widget>[
              Positioned(
                left: 25,
                top: 148,
                child: Text("우리 같이 귤 까먹는 사이,\n귤메이트",
                    style: TextStyle(color: Color(0xFFFF6D00), fontSize: 16)),
              ),
              Positioned(
                left: 25,
                top: 216,
                child:
                    Image.asset("images/logo_symbol/logoTypeface_accent.png"),
              ),
              Positioned(
                right: -22,
                top: 105,
                child: Image.asset("images/logo_symbol/logoSymbolYy.png"),
              )
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      offset: Offset(1, 1),
                      blurRadius: 10,
                      spreadRadius: 10,
                      color: Color.fromRGBO(249, 249, 249, 1)),
                ],
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(32.0))),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
            width: size.width,
            height: size.height * 0.6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                Expanded(
                    child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "새로운 가족 구성을\n만들어 주세요",
                        style: TextStyle(
                            color: Color.fromRGBO(34, 34, 34, 1),
                            fontSize: 24,
                            fontWeight: FontWeight.w300),
                      ),
                      SizedBox(height: 24),
                      Text("가족 명", style: TextStyle(fontSize: 14)),
                      TextFormField(
                        controller: _familyNameController,
                        decoration:
                            _buildInputDeco(hintText: "가족 구성의 이름을 입력해 주세요"),
                        cursorColor: Color(0xFFFF6D00),
                      ),
                      SizedBox(height: 24),
                      Text("가족 구성원 수", style: TextStyle(fontSize: 14)),
                      DropdownButtonFormField<FamilyType>(
                        value: _selectedFamilyType,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          hoverColor: Colors.white,
                          focusColor: Colors.white,
                        ),
                        elevation: 2,
                        items: [
                          DropdownMenuItem(
                            child: Text("1"),
                            value: FamilyType.ONLY,
                          ),
                          DropdownMenuItem(
                              child: Text("2인 이상"), value: FamilyType.MORE_TWO),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedFamilyType = value;
                          });
                        },
                        hint: Text("선택해주세요"),
                      ),
                    ],
                  ),
                )),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        final familyName = _familyNameController.text;
                        print("가족명: $familyName, 가족 구성원: $_selectedFamilyType");
                        // Backend API - create Family..
                        setState(() {
                          _isSubmitting = true;
                        });
                        Future.delayed(Duration(seconds: 3)).then((value) {
                          FamilyService familyService = Provider.of<FamilyService>(context, listen: false);
                          familyService.setFamily(Family.fromJSON({
                            'invite_url': 'http://bit.ly/fm1234invite1001',
                            'name': familyName,
                          }));
                          _isSubmitting = false;
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (context) => ShowInviteLinkScreen()));
                        });
                      }
                    },
                    color: Color(0xFFFF6D00),
                    padding: EdgeInsets.symmetric(vertical: 18.0),
                    child: Text(
                      "다음 단계",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    ));
  }

  InputDecoration _buildInputDeco({@required String hintText}) =>
      InputDecoration(
        hintText: hintText,
        hintStyle:
            TextStyle(color: Color.fromRGBO(204, 204, 204, 1), fontSize: 16),
        border: UnderlineInputBorder(
            borderSide: BorderSide(color: Color.fromRGBO(249, 249, 249, 1))),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFFFF6D00),
          ),
        ),
        focusColor: Color(0xFFFF6D00),
      );
}
