import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:gulmate/bloc/blocs.dart';
import 'package:gulmate/const/color.dart';
import 'package:gulmate/model/model.dart';
import 'package:gulmate/screens/home/calendar/widgets/family_member_widget.dart';
import 'package:gulmate/utils/format_datetime_utils.dart';

class CalendarAddEditScreen extends StatefulWidget {

  final bool isEditing;
  final Calendar calendar;
  static const Color BACKGROUND_COLOR = Color.fromRGBO(245, 245, 245, 1);


  CalendarAddEditScreen({
    this.isEditing = false,
    this.calendar,
  }) : assert(!isEditing ?? calendar != null);

  @override
  _CalendarAddEditScreenState createState() => _CalendarAddEditScreenState();
}

class _CalendarAddEditScreenState extends State<CalendarAddEditScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController _dateTimeController = TextEditingController();

  String _title;

  String _place;

  DateTime _dateTime;

  List<int> accountIds;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    accountIds = widget.isEditing ? widget.calendar.accountList.map((account) => account.id).toList() : <int>[];
    _dateTime = widget.isEditing ? widget.calendar.dateTime : DateTime.now();
    if(widget.isEditing) {
      _dateTimeController.text = formatFromDateTimeToUntilWeek(widget.calendar.dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      backgroundColor: CalendarAddEditScreen.BACKGROUND_COLOR,
      appBar: AppBar(
        backgroundColor: CalendarAddEditScreen.BACKGROUND_COLOR,
        iconTheme: IconThemeData(color: PRIMARY_COLOR),
        elevation: 0.0,
      ),
      body: BlocBuilder<FamilyBloc, FamilyState>(
        builder: (context, familyState) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Text(
                      widget.isEditing ? "일정 수정하기": "일정 등록하기",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w300,
                        color: Color.fromRGBO(34, 34, 34, 1),),
                    ),
                    SizedBox(height: 30,),
                    Form(
                      key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("일정 제목", style: TextStyle(fontSize: 14),),
                        TextFormField(
                          validator: (text) {
                            if(text.isEmpty) {
                              return "Title isn't empty";
                            }
                            return null;
                          },
                          onSaved: (value) => _title = value,
                          initialValue: widget.isEditing ? widget.calendar.title : "",
                          decoration: InputDecoration(
                            hintText: "예) 가족 외식",
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 16,
                              color: Color.fromRGBO(204, 204, 204, 1),
                            ),
                            contentPadding: const EdgeInsets.symmetric(vertical: 13.5),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: PRIMARY_COLOR),
                            ),
                          ),
                        ),
                        SizedBox(height: 20,),
                        Text(
                          "날짜",
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        TextField(
                          controller: _dateTimeController,
                          showCursor: false,
                          readOnly: true,
                          decoration: InputDecoration(
                            hintText: "탭하여 날짜를 선택하여 주세요",
                            hintStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: Color.fromRGBO(204, 204, 204, 1),),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: PRIMARY_COLOR,
                              )
                            )
                          ),
                          onTap: () {
                            DatePicker.showDateTimePicker(context, minTime: DateTime.now(), onConfirm: (dateTime) {
                              _dateTimeController.text = formatFromDateTimeToUntilWeek(dateTime);


                            }, locale: LocaleType.ko);
                          },
                        ),
                        SizedBox(height: 20,),
                        Text("장소", style: TextStyle(fontSize: 14),),
                        TextFormField(
                          validator: (text) {
                            if(text.isEmpty) {
                              return "장소를 입력해주세요.";
                            }
                            return null;
                          },
                          initialValue: widget.isEditing ? widget.calendar.place : "",
                          onSaved: (value) => _place = value,
                          decoration: InputDecoration(
                            hintText: "지도 검색 후 주소 자동입력",
                            hintStyle: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                              color: Color.fromRGBO(204, 204, 204, 1),
                            ),
                            suffix: InkWell(
                              onTap: () {},
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
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
                                    fontWeight: FontWeight.bold,
                                  ),),
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: PRIMARY_COLOR,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 25,),
                        Text("함께하는 사람", style: TextStyle(fontSize: 14),),
                        SizedBox(height: 20,),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: (familyState as FamilyLoaded).family.accountList.map((account) =>
                                FamilyMemberWidget(
                                  checked: accountIds.contains(account.id),
                                  account: account,
                                  onTap: () {
                                    setState(() {
                                      accountIds.contains(account.id)
                                          ? accountIds.remove(account.id)
                                          : accountIds.add(account.id);
                                    });
                                  },
                                )).toList(),
                          ),
                        )
                      ],
                    ))
                  ],
                ),
              ),
              RaisedButton(
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                color: PRIMARY_COLOR,
                child: Text("등록 완료", style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold
                ),),
                onPressed: () {
                  if(widget.isEditing) {

                  }
                  Navigator.of(context).pop({
                    'title': _title,
                    'place': _place,
                    'dateTime': _dateTime,
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
