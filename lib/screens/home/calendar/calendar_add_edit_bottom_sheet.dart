import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gulmate/bloc/calendar/calendar.dart';
import 'package:gulmate/const/color.dart';

class CalendarAddEditBottomSheet extends StatefulWidget {
  @override
  _CalendarAddEditBottomSheetState createState() => _CalendarAddEditBottomSheetState();
}

class _CalendarAddEditBottomSheetState extends State<CalendarAddEditBottomSheet> {
  final _formKey = GlobalKey<FormState>();

  String _title;
  DateTime _dateTime;
  String _place;
//  List<Account> accountList;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CalendarBloc, CalendarState>(
      listener: (context, state) {
        if(state is CalendarLoaded) {
          Navigator.of(context).pop();
        }
      },
      child: FractionallySizedBox(
        heightFactor: 0.9,
        child: Container(
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
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "일정 등록하기",
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
                        decoration: InputDecoration(
                            hintText: "예) 가족 외식",
                            hintStyle: TextStyle(fontSize: 16, color: Color.fromRGBO(204, 204, 204, 1)),
                            contentPadding:
                            const EdgeInsets.symmetric(vertical: 13.5),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: PRIMARY_COLOR))),
                      ),
                      SizedBox(height: 20,),
                      Text(
                        "날짜",
                        style: TextStyle(fontSize: 14.0),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          suffixIcon: Icon(Icons.arrow_drop_down),
                        ),
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
                      SizedBox(height: 25,),
                      Text("함께하는 사람",
                          style: TextStyle(fontSize: 14)),
                      SizedBox(height: 20,),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: <Widget>[
                            _buildFamilyMember(),
                            _buildFamilyMember(),
                            _buildFamilyMember(),
                            _buildFamilyMember(),
                            _buildFamilyMember(),
                            _buildFamilyMember(),
                          ],
                        ),
                      ),
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
                            BlocProvider.of<CalendarBloc>(context).add(AddCalendar(_title, _place, _dateTime, []));
//                          Navigator.of(context).pop();
//                          if(_formKey.currentState.validate()) {
//                            _formKey.currentState.save();
//                            BlocProvider.of<PurchaseBloc>(context).add(AddPurchase(_title, _place, _isCheckedDeadline ? _deadline : null));
////                              Navigator.of(context).pop();
//////                            Navigator.of(context).pop(Purchase(title: _title, place: _place, deadline: _isCheckedDeadline ? _deadline : null));
//                          }
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
    );
  }

  Padding _buildFamilyMember() {
    return Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                width: 60,
                                  height: 60,
                                  child: CircleAvatar()
                              ),
                              SizedBox(height: 10),
                              Text("길동"),
                            ],
                          ),
                        );
  }
}
