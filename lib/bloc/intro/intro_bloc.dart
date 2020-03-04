import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:gulmate/bloc/intro/intro_event.dart';
import 'package:gulmate/repository/repository.dart';

import '../blocs.dart';

enum IntroState {
  splash,
  introduction,
  signIn,
}

class IntroBloc extends Bloc<IntroEvent, IntroState> {
  final AuthenticationBloc authenticationBloc;
  UserRepository _userRepository;


  IntroBloc(this.authenticationBloc) {
    assert(authenticationBloc != null);
    _userRepository = GetIt.instance.get<UserRepository>();
  }

  @override
  IntroState get initialState => IntroState.splash;

  @override
  Stream<IntroState> mapEventToState(IntroEvent event) async* {
    if(event is IntroUpdateEvent) {
      if(_userRepository.token != null) {
        authenticationBloc.add(LoggedIn(token: _userRepository.token));
      } else {
        yield event.intro;
      }
    }
  }
}