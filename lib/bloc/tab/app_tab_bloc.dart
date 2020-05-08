import 'package:bloc/bloc.dart';
import 'package:gulmate/bloc/tab/app_tab_event.dart';

import '../blocs.dart';

enum AppTab {
  home,
  calendar,
  purchase,
  chatting,
  settings
}

class AppTabBloc extends Bloc<AppTabEvent, AppTab> {

  @override
  AppTab get initialState => AppTab.home;


  @override
  Stream<AppTab> mapEventToState(AppTabEvent event) async* {
    if(event is UpdateTab) {
      yield event.tab;
    }
  }

}