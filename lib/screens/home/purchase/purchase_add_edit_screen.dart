import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:gulmate/const/color.dart';
import 'package:gulmate/model/purchase.dart';
import 'package:gulmate/utils/format_datetime_utils.dart';

typedef OnSaveCallback = Function(
    String title, String place, DateTime deadline);

class PurchaseAddEditScreen extends StatefulWidget {
  final bool isEditing;
  final OnSaveCallback onSave;
  final Purchase purchase;
  final BuildContext prevContext;

  PurchaseAddEditScreen(
      {@required this.isEditing, @required this.onSave, this.purchase, this.prevContext});

  @override
  _PurchaseAddEditScreenState createState() => _PurchaseAddEditScreenState();
}

class _PurchaseAddEditScreenState extends State<PurchaseAddEditScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String _title;
  String _place;
  bool _isCheckedDeadline = false;
  DateTime _deadline;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _deadline = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        iconTheme: IconThemeData(color: Colors.black),
//        backgroundColor: Color.fromRGBO(245, 245, 245, 1),
//        elevation: 0.0,
//        title: Text(
//          "장보기 등록하기",
//          style: TextStyle(color: Colors.black),
//        ),
//      ),
      body: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          boxShadow: [
            BoxShadow(
                color: Color.fromRGBO(249, 249, 249, 1),
                blurRadius: 10,
                spreadRadius: 10,
                offset: Offset(1, 1)),
          ],
          color: Colors.white,
        ),
        margin: const EdgeInsets.only(top: 64),
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: IconButton(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(0),
                  icon: Icon(Icons.chevron_left, size: 32,),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[

                    Text(
                      "장 볼 것 등록하기",
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w300,
                          color: Color.fromRGBO(34, 34, 34, 1)),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "구매 품목명",
                              style: TextStyle(fontSize: 14),
                            ),
                            TextFormField(
                              validator: (text) {
                                if (text.isEmpty) {
                                  return "No title is empty";
                                }
                                return null;
                              },
                              onSaved: (value) => _title = value,
                              decoration: InputDecoration(
                                  hintText: "예) 귤 한 박스",
                                  hintStyle: TextStyle(fontSize: 16, color: Color.fromRGBO(204, 204, 204, 1)),
                                  contentPadding:
                                      const EdgeInsets.symmetric(vertical: 13.5),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: PRIMARY_COLOR))),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text("장소",
                                style: TextStyle(fontSize: 14)),
                            TextFormField(
                              validator: (text) {
                                if (text.isEmpty) {
                                  return "No place is empty";
                                }
                                return null;
                              },
                              onSaved: (value) => _place = value,
                              decoration: InputDecoration(
                                  hintText: "지도 검색 후 주소 자동입력",
                                  hintStyle: TextStyle(fontSize: 16, color: Color.fromRGBO(204, 204, 204, 1)),
                                  suffix: InkWell(
                                    onTap: () {},
                                    child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 4, horizontal: 12),
                                        decoration: BoxDecoration(
                                      color: Colors.white,
                                          border: Border.all(color: Color.fromRGBO(221, 221, 221, 1)),
                                          borderRadius: BorderRadius.circular(8.0),
                                        ),
                                        child: Text(
                                          "지도 검색",
                                          style: TextStyle(
                                              color: PRIMARY_COLOR,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold),
                                        )),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: DEFAULT_BACKGROUND_COLOR))),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "마감 날짜 선택",
                                  style: TextStyle(fontSize: 14.0),
                                ),
                                CupertinoSwitch(
                                  value: _isCheckedDeadline,
                                  onChanged: (value) => setState(() {
                                    _isCheckedDeadline = value;
                                  }),
                                  activeColor: Color(0xFFFF6d00),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            AnimatedContainer(
                              height: _isCheckedDeadline ? 20.0 : 0.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      print('touched date!!');
                                      DatePicker.showDateTimePicker(context,
                                          onConfirm: (datetime) {
                                        print(formatFromDateTime(datetime));
                                        setState(() {
                                          _deadline = datetime;
                                        });
                                      }, locale: LocaleType.ko);
                                    },
                                    child: Text(
                                      formatFromDateTimeToDateTime(_deadline),
                                      style: TextStyle(
                                          color: Color.fromRGBO(153, 153, 153, 1),
                                          decoration: TextDecoration.underline),
                                    ),
                                  ),
                                ],
                              ),
                              duration: const Duration(milliseconds: 300),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: RaisedButton(
                            onPressed: () {
                              if(_formKey.currentState.validate()) {
                                _formKey.currentState.save();
                                Navigator.of(context).pop(Purchase(title: _title, place: _place, deadline: _isCheckedDeadline ? _deadline : null));
                              }
                            },
                            child: Text(
                              "등록 완료",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            color: PRIMARY_COLOR,
                            elevation: 0.0,
                          ),
                        ),
                      ],
                    )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
