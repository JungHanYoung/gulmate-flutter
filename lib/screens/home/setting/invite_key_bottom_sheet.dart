import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';

class InviteKeyBottomSheet extends StatefulWidget {
  final String inviteKey;

  InviteKeyBottomSheet({@required this.inviteKey});

  @override
  _InviteKeyBottomSheetState createState() => _InviteKeyBottomSheetState();
}

class _InviteKeyBottomSheetState extends State<InviteKeyBottomSheet> {
  bool _isCopied = false;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.7,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              "귤메이트 키 공유하기",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "당신의 특정한 귤메이트 키입니다. 당신의 귤메이트에 초대하고 싶은 사람에게 해당 키를 공유해주세요.",
              style: TextStyle(color: Color.fromRGBO(153, 153, 153, 1)),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: widget.inviteKey))
                            .then((_) {
                          setState(() {
                            _isCopied = true;
                          });
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Color.fromRGBO(221, 221, 221, 1),
                        ),
                        child: Column(
                          children: <Widget>[
                            Text(
                              widget.inviteKey,
                              style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 12),
                            ),
                            Text(
                              _isCopied ? "복사되었습니다." : "탭하여 클립보드에 복사하기",
                              style: TextStyle(
                                  fontSize: 12,
                                  color: _isCopied
                                      ? Colors.green
                                      : Color.fromRGBO(153, 153, 153, 1)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      Share.share(widget.inviteKey, subject: "Gulmate 키 공유");
                    },
                    elevation: 0.0,
                    color: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      "공유",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

extension HexColor on Color {

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';

}
