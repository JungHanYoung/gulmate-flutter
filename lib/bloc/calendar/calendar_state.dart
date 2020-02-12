import 'package:equatable/equatable.dart';
import 'package:gulmate/model/calendar.dart';

abstract class CalendarState extends Equatable {

  const CalendarState();

  @override
  List<Object> get props => [];
}

class CalendarLoading extends CalendarState {}

class CalendarLoaded extends CalendarState {
  final int year;
  final int month;
  final List<Calendar> calendarList;

  const CalendarLoaded(this.year, this.month, this.calendarList);

  @override
  List<Object> get props => [year, month, calendarList];

  @override
  String toString() {
    return 'CalendarLoaded{year: $year, month: $month, calendarList: $calendarList}';
  }

}

class CalendarError extends CalendarState {
  final String errorMessage;

  const CalendarError(this.errorMessage);

  @override
  List<Object> get props => [];

  @override
  String toString() {
    return 'CalendarError{errorMessage: $errorMessage}';
  }

}

