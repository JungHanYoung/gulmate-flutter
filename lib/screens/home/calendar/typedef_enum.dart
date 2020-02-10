part of 'calendar_screen.dart';

// 지금 선택한 날짜를 주는 콜백
typedef void OnDaySelected(DateTime day, List events);

//
typedef void OnVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format);

typedef void HeaderGestureCallback(DateTime focusedDay);

typedef String TextBuilder(DateTime date, dynamic locale);

typedef bool EnabledDayPredicate(DateTime day);

enum CalendarFormat { month, twoWeeks, week }

enum FormatAnimation { slide, scale }

enum StartingDayOfWeek { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

int getWeekdayNumber(StartingDayOfWeek weekday) => StartingDayOfWeek.values.indexOf(weekday) + 1;

enum AvailableGestures {none, verticalSwipe, horizontalSwipe, all}