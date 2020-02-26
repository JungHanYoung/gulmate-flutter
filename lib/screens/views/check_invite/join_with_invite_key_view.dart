import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gulmate/bloc/blocs.dart';
import 'package:gulmate/screens/sign_up/layout/join_family_layout.dart';
import 'package:gulmate/widgets/pin_text_field.dart';

class JoinWithInviteKeyView extends StatefulWidget {
  @override
  _JoinWithInviteKeyViewState createState() => _JoinWithInviteKeyViewState();
}

class _JoinWithInviteKeyViewState extends State<JoinWithInviteKeyView> {

  bool _isSubmitting = false;

  void submitInviteKey(String inviteKey) {
    BlocProvider.of<FamilyBloc>(context).add(JoinFamily(inviteKey));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return JoinFamilyLayout(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          //CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
                child: ListView(
                  children: <Widget>[
                    Text(
                      "가족구성원의\n키를 입력해주세요",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w300,
                          letterSpacing: -0.5),
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
                    PinTextField(
                      fields: 6,
                      onSubmit: (pin) {

                        setState(() {
                          _isSubmitting = true;
                        });
                        submitInviteKey(pin);
                        Future.delayed(Duration(seconds: 1)).then((value) {
                          setState(() {
                            _isSubmitting = false;
                          });
                        });
                      },
                    ),
                    SizedBox(height: size.height * 0.3,),
                  ],
                ),
            ),
          ],
        )
    );
  }
}
