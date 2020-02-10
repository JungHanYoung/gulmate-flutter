import 'package:flutter/material.dart';


class PinTextField extends StatefulWidget {
  final String lastPin;
  final int fields;
  final void Function(String) onSubmit;
  final onChange;
  final double fieldWidth;
  final double fontSize;
  final bool isTextObscure;
  final bool showFieldAsBox;

  PinTextField(
      {this.lastPin,
      this.fields: 4,
      this.onSubmit,
      this.onChange,
      this.fieldWidth: 40.0,
      this.fontSize: 20.0,
      this.isTextObscure: false,
      this.showFieldAsBox: false})
      : assert(fields > 0);

  @override
  _PinTextFieldState createState() => _PinTextFieldState();
}

class _PinTextFieldState extends State<PinTextField> {
  List<TextEditingController> _textControllers;
  List<FocusNode> _focusNodes;
  List<String> _pins;

  Widget textfields = Container();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pins = List<String>(widget.fields);
    _focusNodes = List<FocusNode>(widget.fields);
    _textControllers = List<TextEditingController>(widget.fields);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        if (widget.lastPin != null) {
          for (var i = 0; i < widget.lastPin.length; i++) {
            _pins[i] = widget.lastPin[i];
          }
        }
        textfields = generateTextFields(context);
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _textControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  Widget generateTextFields(BuildContext context) {
    List<Widget> textFields = List.generate(widget.fields, (int i) {
      return buildTextField(i, context);
    });

    if (_pins.first != null) {
      FocusScope.of(context).requestFocus(_focusNodes[0]);
    }

    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        verticalDirection: VerticalDirection.down,
        children: [
          ...textFields,
          GestureDetector(
            onTap: clearTextFields,
            child: Icon(Icons.cancel, color: Color(0xFFCCCCCC)),
          )
        ]);
  }

  void clearTextFields() {
    _textControllers.forEach(
        (TextEditingController tEditController) => tEditController.clear());
    _pins = _pins.map((pin) => "").toList();
    FocusScope.of(context).requestFocus(_focusNodes[0]);

//    _pins.clear();
  }

  Widget buildTextField(int i, BuildContext context) {
    if (_focusNodes[i] == null) {
      _focusNodes[i] = FocusNode();
    }
    if (_textControllers[i] == null) {
      _textControllers[i] = TextEditingController();
      if (widget.lastPin != null) {
        _textControllers[i].text = widget.lastPin[i];
      }
    }

    _focusNodes[i].addListener(() {
      if (_focusNodes[i].hasFocus) {}
    });

    final String lastDigit = _textControllers[i].text;

    return Container(
      width: widget.fieldWidth,
      margin: EdgeInsets.only(right: 10.0),
      child: TextField(
        controller: _textControllers[i],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: widget.fontSize),
        focusNode: _focusNodes[i],
        obscureText: widget.isTextObscure,
        decoration: InputDecoration(
          counterText: "",
          border: widget.showFieldAsBox
              ? OutlineInputBorder(borderSide: BorderSide(width: 2.0))
              : null,
        ),
        onChanged: (String str) {
          setState(() {
            _pins[i] = str;
          });
          // 마지막 핀 입력이 아닐 경우
          if (i + 1 != widget.fields) {
            // 입력된 핀 unfocus
            _focusNodes[i].unfocus();
            // 방금 입력으로 바뀐 핀 필드가 빈칸일 경우
            if (lastDigit != null && _pins[i] == '') {
              FocusScope.of(context).requestFocus(_focusNodes[i - 1]);
            }
            // 방금 입력으로 바뀐 핀 필드에 입력값이 있는 경우
            else {
              FocusScope.of(context).requestFocus(_focusNodes[i + 1]);
            }
          }
          // 마지막 핀 입력일 경우
          else {
            _focusNodes[i].unfocus();
            // 빈칸일 경우 이전 입력 필드로 포커싱
            if (lastDigit != null && _pins[i] == '') {
              FocusScope.of(context).requestFocus(_focusNodes[i - 1]);
            }
          }
          // 모든 핀 필드에 빈칸이 아닌 경우
          if (_pins.every((String digit) => digit != null && digit != '')) {
            // 입력된 핀의 값을 모두 이어서 onSubmit
            widget.onSubmit(_pins.join());
          }
        },
        onSubmitted: (String str) {
          if (_pins.every((String digit) => digit != null && digit != '')) {
            widget.onSubmit(_pins.join());
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return textfields;
  }
}
