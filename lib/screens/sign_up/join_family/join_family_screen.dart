import 'package:flutter/material.dart';
import 'package:pin_entry_text_field/pin_entry_text_field.dart';

class JoinFamilyScreen extends StatefulWidget {
  @override
  _JoinFamilyScreenState createState() => _JoinFamilyScreenState();
}

class _JoinFamilyScreenState extends State<JoinFamilyScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Color(0xFF515151)),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.info_outline),
          ),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Text("가족구성원의\n키를 입력해주세요", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,letterSpacing: -0.5),),
              ),
              Text("키 6자리 입력", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
              PinEntryTextField(
                fields: 6,
                onSubmit: (pin) {
                  print(pin);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
