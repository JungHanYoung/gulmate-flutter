import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gulmate/bloc/calendar/calendar.dart';
import 'package:gulmate/const/color.dart';
import 'package:gulmate/model/calendar.dart';
import 'package:gulmate/screens/home/calendar/calendar_add_edit_bottom_sheet.dart';
import 'package:gulmate/screens/home/calendar/table_calendar.dart';
import 'package:gulmate/screens/home/calendar/widgets/event_item_widget.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  CalendarController _calendarController;
  Map<DateTime, List> _events;
  List _selectedEvents;

  @override
  // ignore: must_call_super
  void initState() {
    _calendarController = CalendarController();
    final _selectedDay = DateTime.now();
    _events = {
      _selectedDay.subtract(Duration(days: 30)): [
        'Event A0',
        'Event B0',
        'Event C0'
      ],
      _selectedDay.subtract(Duration(days: 27)): ['Event A1'],
      _selectedDay.subtract(Duration(days: 20)): [
        'Event A2',
        'Event B2',
        'Event C2',
        'Event D2'
      ],
      _selectedDay.subtract(Duration(days: 16)): ['Event A3', 'Event B3'],
      _selectedDay.subtract(Duration(days: 10)): [
        'Event A4',
        'Event B4',
        'Event C4'
      ],
      _selectedDay.subtract(Duration(days: 4)): [
        'Event A5',
        'Event B5',
        'Event C5'
      ],
      _selectedDay.subtract(Duration(days: 2)): ['Event A6', 'Event B6'],
      _selectedDay: ['Event A7', 'Event B7', 'Event C7', 'Event D7'],
      _selectedDay.add(Duration(days: 1)): [
        'Event A8',
        'Event B8',
        'Event C8',
        'Event D8'
      ],
      _selectedDay.add(Duration(days: 3)):
          Set.from(['Event A9', 'Event A9', 'Event B9']).toList(),
      _selectedDay.add(Duration(days: 7)): [
        'Event A10',
        'Event B10',
        'Event C10'
      ],
      _selectedDay.add(Duration(days: 11)): ['Event A11', 'Event B11'],
      _selectedDay.add(Duration(days: 17)): [
        'Event A12',
        'Event B12',
        'Event C12',
        'Event D12'
      ],
      _selectedDay.add(Duration(days: 22)): ['Event A13', 'Event B13'],
      _selectedDay.add(Duration(days: 26)): [
        'Event A14',
        'Event B14',
        'Event C14'
      ],
    };

    _selectedEvents = _events[_selectedDay] ?? [];
  }

  void _onDaySelected(DateTime date, List events) {
    setState(() {
      _selectedEvents = events;
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
        }
        // CalendarLoaded
        else {
          final calendarLoaded = (state as CalendarLoaded);
          return Stack(
            fit: StackFit.expand,
            children: [
              Column(
                children: <Widget>[
                  SizedBox(
                    height: 94,
                  ),
                  TableCalendar(
                    onVisibleDaysChanged: (prev, next, format) {
                      print("prev: ${prev.month}");
                      print("next: ${next.month}");
                      print("format: ${format.toString()}");
                    },
                    calendarController: _calendarController,
                    events: _events,
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
                            Center(child: Text("${date.day}")),
                        markersBuilder: (context, date, events, holidays) {
                          final children = <Widget>[];

                          if (events.isNotEmpty) {
                            children.add(
                              Positioned(
                                child: CustomPaint(
                                  painter: EventNoti(),
                                ),
                                bottom: 8,
                                right: size.width / 7 / 2 + 4,
                              ),
                            );
                          }
                          return children;
                        },
                    ),
                    onDaySelected: (date, events) {
                      _onDaySelected(date, events);
                    },
                  ),
                  _buildEventList(calendarLoaded.calendarList),
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
