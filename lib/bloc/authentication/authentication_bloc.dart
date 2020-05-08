import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:gulmate/bloc/authentication/authentication_event.dart';
import 'package:gulmate/bloc/authentication/authentication_state.dart';
import 'package:gulmate/model/account.dart';
import 'package:gulmate/repository/user_repository.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  UserRepository _userRepository;

  AuthenticationBloc() {
    _userRepository = GetIt.instance.get<UserRepository>();
  }

  @override
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    if(event is AppStarted) {
      final String token = await _userRepository.getToken();
      if(token != null) {
        Account account = await _userRepository.verifyToken();
        yield AuthenticationAuthenticatedWithoutFamily(account);
      } else {
        yield AuthenticationUnauthenticated();
      }
    } else if(event is ReadySignIn) {
      if(_userRepository.token != null) {
        add(LoggedIn(token: _userRepository.token));
      } else {
        yield AuthenticationUnauthenticated();
      }
    }
    else if(event is LoggedIn) {
      yield* _mapLoggedInToState(event);
    } else if(event is LoggedOut) {
      yield AuthenticationLoading();
      await _userRepository.deleteToken();
      yield AuthenticationUnauthenticated();
    } else if(event is WithFamily) {
      yield AuthenticationAuthenticatedWithFamily(account: (state as AuthenticationAuthenticated).currentAccount, family: event.family);
    } else if(event is WithoutFamily) {
      yield AuthenticationAuthenticatedWithoutFamily((state as AuthenticationAuthenticated).currentAccount);
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState(LoggedIn event) async* {
    yield AuthenticationLoading();
    try {
      Account account = await _userRepository.verifyToken();
      await _userRepository.persistToken(event.token);
      yield AuthenticationAuthenticatedWithoutFamily(account);
    } catch(e) {
      yield AuthenticationUnauthenticated();
    }
  }

}
