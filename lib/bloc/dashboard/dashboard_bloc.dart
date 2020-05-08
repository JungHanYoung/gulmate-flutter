
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:gulmate/bloc/blocs.dart';
import 'package:gulmate/bloc/dashboard/dashboard_event.dart';
import 'package:gulmate/bloc/dashboard/dashboard_state.dart';
import 'package:gulmate/repository/calendar_repository.dart';
import 'package:gulmate/repository/chat_repository.dart';
import 'package:gulmate/repository/purchase_repository.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {

  CalendarRepository _calendarRepository;
  PurchaseRepository _purchaseRepository;
  ChatRepository _chatRepository;

  final AppTabBloc appTabBloc;
  StreamSubscription _appTabSubscription;


  DashboardBloc(this.appTabBloc) {
    _calendarRepository = GetIt.instance.get<CalendarRepository>();
    _purchaseRepository = GetIt.instance.get<PurchaseRepository>();
    _chatRepository = GetIt.instance.get<ChatRepository>();
    _appTabSubscription = appTabBloc.listen((state) {
      if(state == AppTab.home) {
        add(FetchDashboard());
      }
    });
  }


  @override
  DashboardState get initialState => DashboardLoading();

  @override
  Stream<DashboardState> mapEventToState(DashboardEvent event) async* {
    if(event is FetchDashboard) {
      yield* _mapFetchDashboardToState(event);
    }
  }

  Stream<DashboardState> _mapFetchDashboardToState(FetchDashboard event) async* {
    yield DashboardLoading();
    try {

      final recentCalendarList = await _calendarRepository.getRecentCalendarList();
      final todayPurchaseList = await _purchaseRepository.getTodayPurchaseList();
      final int = await _chatRepository.getUnreadChatLength();
      yield DashboardLoaded(recentCalendarList, todayPurchaseList, int);
    } catch(e) {
      yield DashboardError(e.toString());
    }
  }

  @override
  Future<void> close() {
    _appTabSubscription.cancel();
    return super.close();
  }


}