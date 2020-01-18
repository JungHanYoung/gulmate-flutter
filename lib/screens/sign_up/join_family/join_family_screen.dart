import 'package:flutter/material.dart';
import 'package:gulmate/screens/sign_up/layout/join_family_layout.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';

class JoinFamilyScreen extends StatefulWidget {
  @override
  _JoinFamilyScreenState createState() => _JoinFamilyScreenState();
}

class _JoinFamilyScreenState extends State<JoinFamilyScreen>
    with SingleTickerProviderStateMixin {
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return JoinFamilyLayout(
        child: Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      //CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: Text(
            "가족구성원의\n키를 입력해주세요",
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.w300, letterSpacing: -0.5),
          ),
        ),
        SizedBox(
          height: 20.0,
        ),
        Text(
          "이메일 또는 메신저로 받은\n키를 입력해 주세요.",
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w300,
              color: Color(0xFF999999)),
        ),
        SizedBox(height: 70.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            PinEntryTextField(
              fields: 6,
              onSubmit: (pin) {
                setState(() {
                  _isSubmitting = true;
                });
                print('clear pin number.');
                Future.delayed(Duration(seconds: 3)).then((value) {
                  print('submit hear');
                  setState(() {
                    _isSubmitting = false;
                  });
                });
              },
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isSubmitting = true;
                });
                print('clear pin number.');
                Future.delayed(Duration(seconds: 3)).then((value) {
                  print('submit hear');
                  setState(() {
                    _isSubmitting = false;
                  });
                });
              },
              child: Icon(Icons.cancel, color: Color(0xFFCCCCCC)),
            )
          ],
        ),
        SizedBox(height: size.height * 0.3),
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: RaisedButton(
            elevation: 0.0,
            padding: const EdgeInsets.symmetric(vertical: 18),
            color: Color(0xFFFF6D00),
            child: _isSubmitting
                ? SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                        backgroundColor: Colors.white),
                  )
                : Text(
                    "입력 완료",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
            onPressed: () {},
          ),
        )
      ],
    ));
  }
}
