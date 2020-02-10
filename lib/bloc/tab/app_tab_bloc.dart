import 'package:bloc/bloc.dart';
import 'package:gulmate/bloc/tab/app_tab_event.dart';
import 'package:gulmate/bloc/tab/app_tab_state.dart';

class AppTabBloc extends Bloc<AppTabEvent, AppTab> {
  @override
  // TODO: implement initialState
  AppTab get initialState => AppTab.home;

  @override
  Stream<AppTab> mapEventToState(AppTabEvent event) async* {
    if(event is UpdateTab) {
      yield event.tab;
    }
  }

}