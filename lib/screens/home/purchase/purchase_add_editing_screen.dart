
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:gulmate/const/color.dart';
import 'package:gulmate/utils/format_datetime_utils.dart';

typedef OnSaveCallback = void Function(
    String title, String place, DateTime deadline);

class PurchaseAddEditingScreen extends StatelessWidget {

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  ValueNotifier<bool> _isCheckDeadlineNotifier = ValueNotifier<bool>(true);
  ValueNotifier<DateTime> _dateTimeNotifier = ValueNotifier<DateTime>(DateTime.now());
  String _title;
  String _place;


  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 245, 1),
      appBar: AppBar(
        iconTheme: IconThemeData(color: PRIMARY_COLOR),
        backgroundColor: Color.fromRGBO(245, 245, 245, 1),
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: ListView(
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
                                hintStyle: TextStyle(fontSize: 16,
                                    color: Color.fromRGBO(204, 204, 204, 1)),
                                contentPadding:
                                const EdgeInsets.symmetric(vertical: 13.5),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: PRIMARY_COLOR))),
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
                                hintStyle: TextStyle(fontSize: 16,
                                    color: Color.fromRGBO(204, 204, 204, 1)),
                                suffix: InkWell(
                                  onTap: () {},
                                  child: Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 4, horizontal: 12),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Color.fromRGBO(
                                                221, 221, 221, 1)),
                                        borderRadius: BorderRadius.circular(
                                            8.0),
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
                                    BorderSide(
                                        color: DEFAULT_BACKGROUND_COLOR))),
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
                              ValueListenableBuilder(
                                valueListenable: _isCheckDeadlineNotifier,
                                builder: (context, val, child) => CupertinoSwitch(
                                  value: val,
                                  onChanged: (value) {
                                    _isCheckDeadlineNotifier.value = value;
                                  },
                                  activeColor: Color(0xFFFF6d00),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ValueListenableBuilder(
                            valueListenable: _isCheckDeadlineNotifier,
                            builder: (context, val, child) => AnimatedContainer(
                              height: val ? 20.0 : 0.0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  InkWell(
                                    onTap: () {
                                      DatePicker.showDateTimePicker(context,
                                          onConfirm: (datetime) {
                                            _dateTimeNotifier.value = datetime;
                                          }, locale: LocaleType.ko);
                                    },
                                    child: ValueListenableBuilder(
                                      valueListenable: _dateTimeNotifier,
                                        builder: (context, datetime, child) => Text(
                                        formatFromDateTimeToDateTime(datetime),
                                        style: TextStyle(
                                            color: Color.fromRGBO(153, 153, 153, 1),
                                            decoration: TextDecoration.underline),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              duration: const Duration(milliseconds: 300),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                color: PRIMARY_COLOR,
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    Navigator.of(context).pop({
                      'title': _title,
                      'place': _place,
                      'dateTime': _isCheckDeadlineNotifier.value ? _dateTimeNotifier.value : null
                    });
//                    BlocProvider.of<PurchaseBloc>(context).add(AddPurchase(
//                        _title, _place, _isCheckDeadlineNotifier.value ? _dateTimeNotifier.value : null));
//                    widget.onSave(_title, _place, _isCheckedDeadline ? _deadline : null);
//                    Navigator.of(context).pop(Purchase(title: _title, place: _place, deadline: _isCheckedDeadline ? _deadline : null));
                  }
                },
                child: Text("등록 완료", style: TextStyle(color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
