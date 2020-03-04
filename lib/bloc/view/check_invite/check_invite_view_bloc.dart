import 'package:bloc/bloc.dart';

import 'check_invite_view_event.dart';

enum CheckInviteViewState {
  selectBetween,
  createFamily,
  joinWithInviteKey,
  welcome,
}

class CheckInviteViewBloc extends Bloc<CheckInviteViewEvent, CheckInviteViewState> {

  @override
  CheckInviteViewState get initialState => CheckInviteViewState.selectBetween;

  @override
  Stream<CheckInviteViewState> mapEventToState(event) async* {
    if(event is UpdateCheckInviteView) {
      yield event.state;
    }
  }
}