import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gulmate/bloc/calendar/calendar.dart';
import 'package:gulmate/const/color.dart';
import 'package:gulmate/model/calendar.dart';
import 'package:gulmate/screens/home/calendar/calendar_add_edit_bottom_sheet.dart';
import 'package:gulmate/screens/home/calendar/table_calendar.dart';
import 'package:gulmate/screens/home/calendar/widgets/event_item_widget.dart';
import 'package:gulmate/utils/datetime_utils.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarController _calendarController;
  DateTime _selectedDateTime;

  @override
  // ignore: must_call_super
  void initState() {
    _calendarController = CalendarController();
    _selectedDateTime = DateTime.now();
  }

  void _onDaySelected(DateTime date, List events) {
    setState(() {
      _selectedDateTime = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return BlocBuilder<CalendarBloc, CalendarState>(
      builder: (context, state) {
        if(state is CalendarLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if(state is CalendarError) {
          return Center(
            child: Text(state.errorMessage),
          );
        } else {
          final calendarLoaded = (state as CalendarLoaded);
          final events = calendarLoaded.calendarList.fold<Map<DateTime, List<Calendar>>>({}, (prev, calendar) {

              final addedList = prev.containsKey(calendar.dateTime)
                  ? prev[calendar.dateTime]
                  : <Calendar>[];
              addedList.add(calendar);
              prev[calendar.dateTime] = addedList;
              return prev;
          });
          final selectedEvents = calendarLoaded.calendarList
                .where((calendar) => isEqualToDateTimeYMD(calendar.dateTime, _selectedDateTime))
              .toList();
          return Stack(
            fit: StackFit.expand,
            children: [
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 94,
                  ),
                  TableCalendar(
                    startDay: DateTime.now().subtract(Duration(days: 120)),
                    calendarController: _calendarController,
                    events: events,
                    headerVisible: true,
                    initialCalendarFormat: CalendarFormat.month,
                    formatAnimation: FormatAnimation.slide,
                    availableCalendarFormats: const {
                      CalendarFormat.month: '',
                    },
                    availableGestures: AvailableGestures.horizontalSwipe,
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekendStyle: TextStyle(color: Color.fromRGBO(153, 153, 153, 1)),
                      weekdayStyle: TextStyle(color: Color.fromRGBO(153, 153, 153, 1)),
                    ),
                    calendarStyle: CalendarStyle(
                      selectedColor: Color.fromRGBO(255, 109, 0, 1),
                      weekendStyle: TextStyle(color: Color.fromRGBO(255, 163, 0, 1)),
                      outsideDaysVisible: false,
                    ),
                    builders: CalendarBuilders(
                        todayDayBuilder: (context, date, _) =>
                            Container(
                              margin: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                border: Border.all(color: PRIMARY_COLOR),
                                shape: BoxShape.circle,
                              ),
                                child: Center(child: Text("${date.day}"))
                            ),
                        markersBuilder: (context, date, events, holidays) {
                          final children = <Widget>[];

                          if (events.isNotEmpty) {
                            children.add(
                              Positioned(
                                child: CustomPaint(
                                  painter: EventNoti(),
                                ),
                                bottom: 6,
                                right: size.width / 7 / 2 + 4,
                              ),
                            );
                          }
                          return children;
                        },
                      selectedDayBuilder: (context, date, events) =>
                          Container(
                            margin: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: PRIMARY_COLOR,
                            ),
                            child: Center(
                              child: Text("${date.day}", style: TextStyle(color: Colors.white),),
                            ),
                          )
                    ),
                    onDaySelected: (date, events) {
                      _onDaySelected(date, events);
                    },
                  ),
                  _buildEventList(selectedEvents),
                ],
              ),
              Positioned(
                  bottom: 16,
                  right: 16,
                  child: InkWell(
                    onTap: () async {
                      Scaffold.of(context).showBottomSheet((context) => CalendarAddEditBottomSheet());
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: DEFAULT_BACKGROUND_COLOR,
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(249, 249, 249, 0.5),
                                blurRadius: 10,
                                spreadRadius: 10),
                          ]),
                      width: 60,
                      height: 60,
                      child: Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  )),
            ],
          );
        }
      },
    );
  }

  Widget _buildEventList(List<Calendar> calendarList) {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.only(top: 24),
        children: calendarList.map((calendar) {
          return EventItemWidget(calendar);
        }).toList(),
      ),
    );
  }
}

class EventNoti extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    final paint = Paint()
      ..strokeWidth = 1
      ..color = Color.fromRGBO(255, 109, 0, 1);

    canvas.drawLine(Offset(0, 0), Offset(10, 0), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}
