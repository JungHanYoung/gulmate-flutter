import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:gulmate/bloc/blocs.dart';
import 'package:gulmate/bloc/calendar/calendar.dart';
import 'package:gulmate/const/color.dart';
import 'package:gulmate/model/calendar.dart';
import 'package:gulmate/screens/home/calendar/widgets/family_member_widget.dart';
import 'package:gulmate/utils/format_datetime_utils.dart';

class CalendarAddEditBottomSheet extends StatefulWidget {
  final bool isEditing;
  final Calendar calendar;


  CalendarAddEditBottomSheet({
    this.isEditing = false,
    this.calendar
  }) : assert(isEditing ? calendar != null : true);

  @override
  _CalendarAddEditBottomSheetState createState() =>
      _CalendarAddEditBottomSheetState();
}

class _CalendarAddEditBottomSheetState
    extends State<CalendarAddEditBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  String _title;
  DateTime _dateTime;
  String _place;
  List<int> accountIds;
  TextEditingController _dateTimeController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _dateTime = widget.isEditing ? widget.calendar.dateTime : DateTime.now();
    accountIds = widget.isEditing ? widget.calendar.accountList.map((account) => account.id).toList() : <int>[];
    _dateTimeController = TextEditingController();
    if(widget.isEditing) {
      _dateTimeController.text = formatFromDateTimeToUntilWeek(widget.calendar.dateTime);
    }
  }

//  List<Account> accountList;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CalendarBloc, CalendarState>(
      listener: (context, state) {
        if (state is CalendarLoaded) {
          Navigator.of(context).pop();
        }
      },
      child: BlocBuilder<FamilyBloc, FamilyState>(
        builder: (context, familyState) => DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          maxChildSize: 0.8,
          minChildSize: 0.5,
          builder: (context, scrollController) => Container(
            decoration: const BoxDecoration(
//              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
//              boxShadow: [
//                BoxShadow(
//                    color: Color.fromRGBO(249, 249, 249, 1),
//                    blurRadius: 10,
//                    spreadRadius: 10,
//                    offset: Offset(1, 1)),
//              ],
              color: Colors.white,
            ),
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: <Widget>[
                        Text(
                          widget.isEditing ? "일정 수정하기" : "일정 등록하기",
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w300,
                              color: Color.fromRGBO(34, 34, 34, 1)),
                        ),
                        SizedBox(height: 30.0),
                        Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "일정 제목",
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
                                initialValue: widget.isEditing ? widget.calendar.title : "",
                                decoration: InputDecoration(
                                    hintText: "예) 가족 외식",
                                    hintStyle: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 16,
                                        color: Color.fromRGBO(204, 204, 204, 1)),
                                    contentPadding:
                                    const EdgeInsets.symmetric(vertical: 13.5),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                        BorderSide(color: PRIMARY_COLOR))),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "날짜",
                                style: TextStyle(
                                  fontSize: 14.0,
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
                                        color: Color.fromRGBO(204, 204, 204, 1)),
                                    focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: DEFAULT_BACKGROUND_COLOR))),
                                onTap: () {
                                  DatePicker.showDateTimePicker(
                                    context,
                                    minTime: DateTime.now(),
                                    onConfirm: (dateTime) {
                                      setState(() {
                                        _dateTime = dateTime;
                                      });
                                      _dateTimeController.text =
                                          formatFromDateTimeToUntilWeek(dateTime);
                                    },
                                    locale: LocaleType.ko,
                                  );
                                },
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text("장소", style: TextStyle(fontSize: 14)),
                              TextFormField(
                                validator: (text) {
                                  if (text.isEmpty) {
                                    return "No place is empty";
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
                                        color: Color.fromRGBO(204, 204, 204, 1)),
                                    suffix: InkWell(
                                      onTap: () {},
                                      child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 12),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(
                                                color:
                                                Color.fromRGBO(221, 221, 221, 1)),
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
                                        borderSide: BorderSide(
                                            color: DEFAULT_BACKGROUND_COLOR))),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Text("함께하는 사람", style: TextStyle(fontSize: 14)),
                              SizedBox(
                                height: 20,
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: (familyState as FamilyLoaded)
                                      .family
                                      .accountList
                                      .map((account) => FamilyMemberWidget(
                                      checked: accountIds.contains(account.id),
                                      account: account,
                                      onTap: () {
                                        setState(() {
                                          accountIds.contains(account.id)
                                              ? accountIds.remove(account.id)
                                              : accountIds.add(account.id);
                                        });
                                      }))
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ),

                RaisedButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  onPressed: () {
                    if(_formKey.currentState.validate() && _dateTimeController.text.isNotEmpty) {
                      _formKey.currentState.save();
                      BlocProvider.of<CalendarBloc>(context)
                          .add(widget.isEditing ? UpdateCalendar(_title, _place, _dateTime, accountIds, widget.calendar) : AddCalendar(_title, _place, _dateTime, accountIds));
                    }
                  },
                  child: BlocProvider.of<CalendarBloc>(context).state is CalendarLoading
                  ? SizedBox(
                    width: 16,
                    height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2.0, backgroundColor: Colors.white, ))
                  : Text(
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
              ],
            ),
          ),
        ),
        ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _dateTimeController.dispose();
    super.dispose();
  }
}
