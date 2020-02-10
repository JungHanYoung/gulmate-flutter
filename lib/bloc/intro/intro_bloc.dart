import 'package:bloc/bloc.dart';
import 'package:gulmate/bloc/intro/intro_event.dart';

enum IntroState {
  splash,
  introduction,
  signIn,
}

class IntroBloc extends Bloc<IntroEvent, IntroState> {
  @override
  // TODO: implement initialState
  IntroState get initialState => IntroState.splash;

  @override
  Stream<IntroState> mapEventToState(IntroEvent event) async* {
    // TODO: implement mapEventToState
    if(event is IntroUpdateEvent) {
      yield event.intro;
    }
  }

}