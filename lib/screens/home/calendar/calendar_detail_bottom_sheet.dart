import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gulmate/bloc/authentication/authentication.dart';
import 'package:gulmate/bloc/blocs.dart';
import 'package:gulmate/const/color.dart';
import 'package:gulmate/model/calendar.dart';
import 'package:gulmate/screens/home/calendar/calendar_add_edit_bottom_sheet.dart';
import 'package:gulmate/screens/home/calendar/widgets/family_member_widget.dart';
import 'package:gulmate/utils/format_datetime_utils.dart';

class CalendarDetailBottomSheet extends StatelessWidget {
  final Calendar calendar;

  CalendarDetailBottomSheet(this.calendar);

  static const _labelStyle = const TextStyle(
    color: Color.fromRGBO(153, 153, 153, 1),
    fontSize: 14,
  );
  static const _valueStyle = const TextStyle(
    color: Color.fromRGBO(34, 34, 34, 1),
    fontSize: 16,
  );

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return BlocListener<CalendarBloc, CalendarState>(
      listener: (context, state) {
        if (state is CalendarLoaded) {
          Navigator.of(context).pop();
        }
      },
      child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, auth) => DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          maxChildSize: 0.8,
          minChildSize: 0.5,
          builder: (context, scrollController) => Container(
            decoration: BoxDecoration(
//              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
//              boxShadow: [
//                BoxShadow(
//                    color: Color.fromRGBO(249, 249, 249, 0.5),
//                    blurRadius: 10,
//                    spreadRadius: 10,
//                    offset: Offset(1, 1)),
//              ],
              color: Colors.white,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Expanded(
                    child: ListView(
                      controller: scrollController,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: PRIMARY_COLOR, width: 2))),
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            calendar.title,
                            style: TextStyle(
                              fontSize: 24,
                            ),
                          ),
                        ),
                        _buildButton("편집", () {
//                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => CalendarDetailBottomSheet(calendar)));
                          Scaffold.of(context).showBottomSheet(
                              (context) => CalendarAddEditBottomSheet(
                                    isEditing: true,
                                    calendar: calendar,
                                  ));
//                      Navigator.of(context).pop();
                        }),
                      ],
                    ),
                    SizedBox(height: 30),
                    Text(
                      "시간",
                      style: _labelStyle,
                    ),
                    SizedBox(height: 10),
                    Text(
                      formatFromDateTimeToUntilWeek(calendar.dateTime),
                      style: _valueStyle,
                    ),
                    SizedBox(height: 30),
                    Text(
                      "장소",
                      style: _labelStyle,
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          calendar.place,
                          style: _valueStyle,
                        ),
                        _buildButton("지도 보기", () {})
                      ],
                    ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          "함께하는 사람",
                          style: _labelStyle,
                        ),
                        Text(
                          "총 ${calendar.accountList.length}명",
                          style:
                              TextStyle(color: PRIMARY_COLOR, fontSize: 14),
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    SingleChildScrollView(
                      child: Row(
                        children: calendar.accountList
                            .map(
                              (account) => Padding(
                                padding: const EdgeInsets.only(right: 16.0),
                                child: FamilyMemberWidget(
                                  account: account,
                                  isMe: account.id ==
                                      (auth as AuthenticationAuthenticatedWithFamily)
                                          .currentAccount
                                          .id,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                )),
                OutlineButton(
                  borderSide: BorderSide(color: DANGER_COLOR),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  onPressed: () async {
                    final result = await showCupertinoDialog<bool>(
                        context: context,
                        builder: (context) => CupertinoAlertDialog(
                              title: Text("일정 삭제"),
                              content: Text("일정을 삭제하시겠습니까?"),
                              actions: <Widget>[
                                FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                    child: Text(
                                      "삭제",
                                      style: TextStyle(color: DANGER_COLOR),
                                    )),
                                FlatButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                    child: Text("취소")),
                              ],
                            ));
                    if (result) {
                      BlocProvider.of<CalendarBloc>(context)
                          .add(DeleteCalendar(calendar));
                      Navigator.of(context).pop();
                    }
                  },
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  child: Text(
                    "일정 삭제하기",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: DANGER_COLOR),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String title, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Color.fromRGBO(221, 221, 221, 1)),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          title,
          style: TextStyle(
              color: PRIMARY_COLOR, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
