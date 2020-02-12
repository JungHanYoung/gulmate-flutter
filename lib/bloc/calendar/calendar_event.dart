import 'package:equatable/equatable.dart';

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

  AddCalendar(this.title, this.place, this.dateTime, this.accountIds);

  @override
  List<Object> get props => [title, place, dateTime, accountIds];

  @override
  String toString() {
    return 'AddCalendar{title: $title, place: $place, dateTime: $dateTime}';
  }


}