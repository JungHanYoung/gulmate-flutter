import 'package:flutter/material.dart';
import 'package:gulmate/const/color.dart';
import 'package:gulmate/model/calendar.dart';
import 'package:gulmate/screens/home/calendar/calendar_detail_bottom_sheet.dart';
import 'package:gulmate/utils/format_datetime_utils.dart';

class EventItemWidget extends StatelessWidget {
  final Calendar calendar;

  const EventItemWidget(this.calendar);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          // TODO: 특정 날짜의 이벤트 터치시 해당 날짜 이벤트 상세페이지 팝업
          Scaffold.of(context)
              .showBottomSheet((context) => CalendarDetailBottomSheet(calendar));
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Color.fromRGBO(249, 249, 249, 0.5),
                  blurRadius: 10,
                  spreadRadius: 10),
            ],
          ),
          child: Row(
            children: <Widget>[
              Expanded(child: Text("${calendar.title}")),
              Text("${formatFromDateTimeToTime(calendar.dateTime)}"),
              Icon(
                Icons.chevron_right,
                color: PRIMARY_COLOR,
              ),
            ],
          ),
        ));
  }
}
