import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gulmate/app_config.dart';
import 'package:gulmate/const/color.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:gulmate/utils/format_datetime_utils.dart';

class AddShoppingScreen extends StatefulWidget {
  @override
  _AddShoppingScreenState createState() => _AddShoppingScreenState();
}

class _AddShoppingScreenState extends State<AddShoppingScreen> {
  bool _isCheckedDeadline = false;
  DateTime _deadlineTime;
  TextEditingController _shoppingTitleController;
  TextEditingController _placeController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _deadlineTime = DateTime.now();
    _shoppingTitleController = TextEditingController();
    _placeController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _shoppingTitleController.dispose();
    _placeController.dispose();
    super.dispose();
  }

  void _onChangedCheckState(bool checked) {
    setState(() {
      _isCheckedDeadline = !_isCheckedDeadline;
    });
  }

  Future<bool> _onSubmitShopping() async {
    final apiBaseUrl = AppConfig.of(context).apiBaseUrl;

    await Dio().post("$apiBaseUrl/shopping?family=${1}", data: {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Color.fromRGBO(245, 245, 245, 1),
        elevation: 0.0,
        brightness: Brightness.light,
        title: Text(
          "장보기 등록하기",
          style: TextStyle(color: Colors.black),
        ),
      ),
      backgroundColor: Color.fromRGBO(245, 245, 245, 1),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "구매 품목",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        hintText: "예) 쌀 한 가마니",
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: DEFAULT_BACKGROUND_COLOR))),
                    controller: _shoppingTitleController,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("장소",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(
                        "지도 검색",
                        style: TextStyle(
                          color: Color.fromRGBO(153, 153, 153, 1),
                          decoration: TextDecoration.underline,
                        ),
                      )
                    ],
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                        hintText: "지도 검색 후 주소 자동입력",
                        hintStyle: TextStyle(
                            color: Color.fromRGBO(153, 153, 153, 1),
                            fontSize: 16.0),
                        focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: DEFAULT_BACKGROUND_COLOR))),
                    controller: _placeController,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "마감 날짜 선택",
                        style: TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      CupertinoSwitch(
                        value: _isCheckedDeadline,
                        onChanged: _onChangedCheckState,
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
                                _deadlineTime = datetime;
                              });
                            }, locale: LocaleType.ko);
                          },
                          child: Text(
                            formatFromDateTimeToDateTime(_deadlineTime),
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
            Expanded(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                RaisedButton(
                  onPressed: () {
                    // TODO: 장보기 등록 API 구현 후 진행
//                    _onSubmitShopping().then((isSuccess) {
//                      if (isSuccess) {
//                        Navigator.of(context).pop();
//                      } else {
//                        Scaffold.of(context).showSnackBar(
//                            SnackBar(content: Text("장보기 등록에 실패하였습니다. (서버에러)")));
//                      }
//                    });
                    print(_placeController.text);
                    print(_shoppingTitleController.text);
                    print(_isCheckedDeadline);
                  },
                  child: Text(
                    "등록 완료",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  color: DEFAULT_BACKGROUND_COLOR,
                  elevation: 0.0,
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}