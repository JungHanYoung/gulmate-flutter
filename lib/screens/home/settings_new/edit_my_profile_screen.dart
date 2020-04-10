import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gulmate/bloc/authentication/authentication.dart';
import 'package:gulmate/bloc/blocs.dart';
import 'package:gulmate/const/color.dart';
import 'package:image_picker/image_picker.dart';

class EditMyProfileScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  String _nickname = "";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, auth) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios,
                color: PRIMARY_COLOR,
              ),
              onPressed: () => Navigator.of(context).pop()),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 30),
                  child: Text(
                    "내 정보 수정하기",
                    style: TextStyle(
                        fontSize: 24, color: Color.fromRGBO(34, 34, 34, 1)),
                  ),
                ),
                _buildAvatar(
                    context,
                    (auth as AuthenticationAuthenticatedWithFamily)
                        .currentAccount
                        .photoUrl),
                SizedBox(
                  height: 30,
                ),
                ..._buildTextFieldWithLabel("이메일",
                    disable: (auth as AuthenticationAuthenticatedWithFamily)
                        .currentAccount
                        .email, color: Colors.grey),
                SizedBox(
                  height: 24.5,
                ),
                ..._buildTextFieldWithLabel("이름",
                    disable: (auth as AuthenticationAuthenticatedWithFamily)
                        .currentAccount
                        .name, color: Colors.grey),
                SizedBox(
                  height: 24.5,
                ),
                Text(
                  "별명",
                  style: TextStyle(
                      fontSize: 14, color: Color.fromRGBO(34, 34, 34, 1)),
                ),
                TextFormField(
                  validator: (text) {
                    if (text.isEmpty) {
                      return "No title is empty";
                    }
                    return null;
                  },
                  initialValue: (auth as AuthenticationAuthenticatedWithFamily)
                          .currentAccount
                          .nickname ??
                      "",
                  onSaved: (text) {
                    _nickname = text;
                  },
                  decoration: InputDecoration(
                      suffix: InkWell(
                        onTap: () {
                          if (_formKey.currentState.validate()) {
                            _formKey.currentState.save();
                            BlocProvider.of<FamilyBloc>(context)
                                .add(UpdateMemberInfo(_nickname));
                            Navigator.of(context).pop();
                          }
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 4, horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  color: Color.fromRGBO(221, 221, 221, 1)),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              "변경",
                              style: TextStyle(
                                  color: PRIMARY_COLOR,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                      hintText: "귀염둥이 막내",
                      hintStyle: TextStyle(
                          fontSize: 16,
                          color: Color.fromRGBO(204, 204, 204, 1)),
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 13.5),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: PRIMARY_COLOR))),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "별명을 입력하시면 프로필에 별명이 노출됩니다.",
                    style: TextStyle(
                        color: Color.fromRGBO(153, 153, 153, 1), fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, String photoUrl) {
    return Stack(children: <Widget>[
      CircleAvatar(
        radius: 40,
        backgroundImage: NetworkImage(photoUrl),
      ),
      Positioned(
        bottom: 6,
        right: 0,
        child: SizedBox(
          width: 24,
          height: 24,
          child: RaisedButton(
            shape: CircleBorder(),
            padding: const EdgeInsets.all(6),
            color: PRIMARY_COLOR,
            elevation: 0.0,
            onPressed: () async {
              final image = await ImagePicker.pickImage(source: ImageSource.gallery);
              print(image);
            },
            child: Icon(
              Icons.edit,
              size: 11,
              color: Colors.white,
            ),
          ),
        ),
      )
    ]);
  }

  List<Widget> _buildTextFieldWithLabel(String label,
      {String hintText,
      String disable,
      String additionalButtonLabel,
      Function() onSuffixTap, Color color}) {
    return <Widget>[
      Text(
        label,
        style: TextStyle(fontSize: 14, color: Color.fromRGBO(34, 34, 34, 1)),
      ),
      TextFormField(
        readOnly: disable != null,
        validator: (text) {
          if (text.isEmpty) {
            return "No title is empty";
          }
          return null;
        },
        style: TextStyle(fontSize: 16, color: color ?? Colors.black),
        initialValue: disable ?? "",
        decoration: InputDecoration(
            suffix: additionalButtonLabel != null
                ? InkWell(
                    onTap: () {
                      onSuffixTap();
                    },
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(
                              color: Color.fromRGBO(221, 221, 221, 1)),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          additionalButtonLabel,
                          style: TextStyle(
                              color: PRIMARY_COLOR,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        )),
                  )
                : null,
            hintText: hintText,
            hintStyle: TextStyle(
                fontSize: 16, color: Color.fromRGBO(204, 204, 204, 1)),
            contentPadding: const EdgeInsets.symmetric(vertical: 13.5),
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: disable != null ? Colors.grey : PRIMARY_COLOR))),
      )
    ];
  }
}
