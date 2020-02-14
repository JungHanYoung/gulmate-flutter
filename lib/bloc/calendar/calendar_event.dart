import 'package:equatable/equatable.dart';
import 'package:gulmate/model/calendar.dart';

abstract class CalendarEvent extends Equatable {

  const CalendarEvent();

  @override
  List<Object> get props => [];
}

class FetchCalendar extends CalendarEvent {
  final int year;
  final int month;

  const FetchCalendar(this.year, this.month);

  @override
  List<Object> get props => [year, month];

  @override
  String toString() {
    return 'FetchCalendar{year: $year, month: $month}';
  }
}

class AddCalendar extends CalendarEvent {
  final String title;
  final String place;
  final DateTime dateTime;
  final List<int> accountIds;

  const AddCalendar(this.title, this.place, this.dateTime, this.accountIds);

  @override
  List<Object> get props => [title, place, dateTime, accountIds];

  @override
  String toString() {
    return 'AddCalendar{title: $title, place: $place, dateTime: $dateTime}';
  }
}

class UpdateCalendar extends CalendarEvent {
  final String title;
  final String place;
  final DateTime dateTime;
  final List<int> accountIds;
  final Calendar calendar;

  const UpdateCalendar(this.title, this.place, this.dateTime, this.accountIds,
      this.calendar);

  @override
  List<Object> get props => [title, place, dateTime, accountIds, calendar];

  @override
  String toString() {
    return 'UpdateCalendar{title: $title, place: $place, dateTime: $dateTime, accountIds: $accountIds, calendar: $calendar}';
  }
}

class DeleteCalendar extends CalendarEvent {
  final Calendar calendar;

  const DeleteCalendar(this.calendar);

  @override
  List<Object> get props => [calendar];

  @override
  String toString() {
    return 'DeleteCalendar{calendar: $calendar}';
  }
}