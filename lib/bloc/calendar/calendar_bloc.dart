import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:gulmate/bloc/calendar/calendar_event.dart';
import 'package:gulmate/bloc/calendar/calendar_state.dart';
import 'package:gulmate/bloc/tab/app_tab.dart';
import 'package:gulmate/model/calendar.dart';
import 'package:gulmate/repository/calendar_repository.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarRepository _calendarRepository;
  final AppTabBloc appTabBloc;
  StreamSubscription _appTabSubscription;

  CalendarBloc(CalendarRepository calendarRepository, {
    @required this.appTabBloc,
}) {
    _appTabSubscription = appTabBloc.listen((state) {
      if(state == AppTab.calendar) {
        final now = DateTime.now();
        add(FetchCalendar(now.year, now.month));
      }
    });
    _calendarRepository = calendarRepository;

  }

  @override
  CalendarState get initialState => CalendarLoading();

  @override
  Stream<CalendarState> mapEventToState(CalendarEvent event) async* {
    // TODO: implement mapEventToState
    if(event is FetchCalendar) {
      yield* _mapFetchCalendarToState(event);
    } else if(event is AddCalendar) {
      yield* _mapAddCalendarToState(event);
    }
  }

  Stream<CalendarState> _mapFetchCalendarToState(FetchCalendar event) async* {
    try {
      yield CalendarLoading();
      final List<Calendar> calendarList = await _calendarRepository.getCalendarList(event.year, event.month);
      yield CalendarLoaded(event.year, event.month, calendarList);
    } catch(e) {
      
    }
  }

  Stream<CalendarState> _mapAddCalendarToState(AddCalendar event) async* {
    if(state is CalendarLoaded) {
      try {
        final updatedCalendarList = (state as CalendarLoaded).calendarList;
        final currentYear = (state as CalendarLoaded).year;
        final currentMonth = (state as CalendarLoaded).month;
        yield CalendarLoading();
        final savedCalendar = await _calendarRepository.createCalendar(event.title, event.place, event.dateTime, event.accountIds);
        if(savedCalendar.dateTime.year == currentYear && savedCalendar.dateTime.month == currentMonth) {
          updatedCalendarList.add(savedCalendar);
          yield CalendarLoaded(currentYear, currentMonth, updatedCalendarList);
        }
      } catch(e) {
        print(e);
      }

    }
  }

  @override
  Future<void> close() {
    _appTabSubscription.cancel();
    return super.close();
  }



}