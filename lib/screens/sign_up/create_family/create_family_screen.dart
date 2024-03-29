import 'package:flutter/material.dart';
import 'package:gulmate/const/resources.dart';
import 'package:gulmate/model/family_type.dart';
import 'package:gulmate/screens/sign_up/create_family/show_invite_link_screen.dart';
import 'package:gulmate/services/family_service.dart';
import 'package:provider/provider.dart';

class CreateFamilyScreen extends StatefulWidget {
  @override
  _CreateFamilyScreenState createState() => _CreateFamilyScreenState();
}

class _CreateFamilyScreenState extends State<CreateFamilyScreen> {
  FamilyType _selectedFamilyType;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _familyNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _familyNameController = TextEditingController();
  }

  @override
  void dispose() {
    _familyNameController.dispose();
    super.dispose();
  }

  void handleCreateFamily() async {
    if (_formKey.currentState.validate()) {
      try {
        await Provider.of<FamilyService>(context, listen: false)
            .createFamily(_familyNameController.text, _selectedFamilyType);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => ShowInviteLinkScreen()));
      } catch (e) {
        showDialog(
            context: context,
            child: AlertDialog(
              title: Text("만드는 중 에러가 발생했습니다."),
            ));
      }
    }
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
                    Image.asset(GulmateResources.GULMATE_LOGO_TYPEFACE_ACCENT),
              ),
              Positioned(
                right: -22,
                top: 105,
                child: Image.asset(GulmateResources.GULMATE_LOGO_SYMBOL),
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
                        validator: (value) {
                          if (value.isEmpty) {
                            return "가족 이름을 입력해주세요.";
                          }
                          return null;
                        },
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
                        validator: (value) {
                          if (value == null) {
                            return "가족 타입을 선택해주세요.";
                          }
                          return null;
                        },
                        items: [
                          DropdownMenuItem(
                            child: Text("1"),
                            value: FamilyType.ONLY,
                          ),
                          DropdownMenuItem(
                              child: Text("2인 이상"), value: FamilyType.MORE_THAN_ONE),
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
                      handleCreateFamily();
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
