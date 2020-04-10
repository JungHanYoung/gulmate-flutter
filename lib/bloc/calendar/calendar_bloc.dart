import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:gulmate/bloc/calendar/calendar_event.dart';
import 'package:gulmate/bloc/calendar/calendar_state.dart';
import 'package:gulmate/model/calendar.dart';
import 'package:gulmate/repository/calendar_repository.dart';

import '../blocs.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarRepository _calendarRepository;
  final AppTabBloc appTabBloc;
  final AuthenticationBloc authBloc;
  StreamSubscription _appTabSubscription;

  CalendarBloc({
    @required this.appTabBloc,
    @required this.authBloc,
  }) {
    _appTabSubscription = appTabBloc.listen((state) {
      if(state == AppTab.calendar) {
        final now = DateTime.now();
        add(FetchCalendar(now.year));
      }
      if(state == AppTab.home) {
        add(FetchRecentCalendar());
      }
    });
    _calendarRepository = GetIt.instance.get<CalendarRepository>();

  }

  @override
  CalendarState get initialState => CalendarLoading();

  @override
  Stream<CalendarState> mapEventToState(CalendarEvent event) async* {
    if(event is FetchCalendar) {
      yield* _mapFetchCalendarToState(event);
    } else if(event is AddCalendar) {
      yield* _mapAddCalendarToState(event);
    } else if(event is UpdateCalendar) {
      yield* _mapUpdateCalendarToState(event);
    } else if(event is DeleteCalendar) {
      yield* _mapDeleteCalendarToState(event);
    } else if(event is FetchRecentCalendar) {
      yield* _mapFetchRecentCalendar(event);
    }
  }

  Stream<CalendarState> _mapFetchCalendarToState(FetchCalendar event) async* {
    try {
      yield CalendarLoading();
      final List<Calendar> calendarList = await _calendarRepository.getCalendarList(event.year);
      yield CalendarLoaded(event.year, calendarList);
    } catch(e) {
      yield CalendarError(e.toString());
    }
  }

  Stream<CalendarState> _mapAddCalendarToState(AddCalendar event) async* {
    if(state is CalendarLoaded) {
      try {
        final updatedCalendarList = (state as CalendarLoaded).calendarList;
        final currentYear = (state as CalendarLoaded).year;
        yield CalendarLoading();
        final savedCalendar = await _calendarRepository.createCalendar(event.title, event.place, event.dateTime, event.accountIds);
        if(savedCalendar.dateTime.year == currentYear) {
          updatedCalendarList.add(savedCalendar);
        }
        yield CalendarLoaded(currentYear, updatedCalendarList);
      } catch(e) {
        print(e);
        yield CalendarError(e.toString());
      }

    }
  }

  @override
  Future<void> close() {
    _appTabSubscription.cancel();
    return super.close();
  }

  Stream<CalendarState> _mapDeleteCalendarToState(DeleteCalendar event) async* {
    if(state is CalendarLoaded) {
      final updatedCalendarList = (state as CalendarLoaded).calendarList;
      final currentYear = (state as CalendarLoaded).year;
      try {
        yield CalendarLoading();
        final int deletedCalendarId = await _calendarRepository.deleteCalendar(event.calendar);
        updatedCalendarList.removeWhere((calendar) => calendar.id == deletedCalendarId);
        yield CalendarLoaded(currentYear, updatedCalendarList);
      } catch(e) {
        yield CalendarLoaded(currentYear, updatedCalendarList);
      }
    }
  }

  Stream<CalendarState> _mapUpdateCalendarToState(UpdateCalendar event) async* {
    if(state is CalendarLoaded) {
      final calendarList = (state as CalendarLoaded).calendarList;
      final currentYear = (state as CalendarLoaded).year;
      try {
        yield CalendarLoading();
        final updatedCalendar = await _calendarRepository.updateCalendar(calendarList.firstWhere((calendar) => calendar.id == event.calendar.id)
            .copyWith(
          title: event.title,
          place: event.place,
          dateTime: event.dateTime,
        ), event.accountIds);
        final updatedCalendarList = calendarList.map((calendar) => calendar.id == updatedCalendar.id ? updatedCalendar : calendar).toList();
        yield CalendarLoaded(currentYear, updatedCalendarList);
      } catch(e) {
        yield CalendarLoaded(currentYear, calendarList);
      }
    }
  }

  Stream<CalendarState> _mapFetchRecentCalendar(FetchRecentCalendar event) async* {

    try {
      await _calendarRepository.getRecentCalendarList(size: 3);
    } catch(e) {
    }

  }

}