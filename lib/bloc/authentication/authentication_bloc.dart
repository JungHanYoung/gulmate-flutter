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
  // TODO: implement initialState
  AuthenticationState get initialState => AuthenticationUninitialized();

  @override
  Stream<AuthenticationState> mapEventToState(AuthenticationEvent event) async* {
    // TODO: implement mapEventToState
    if(event is AppStarted) {
      final String token = await _userRepository.getToken();
      if(token != null) {
        Account account = await _userRepository.verifyToken();
        yield AuthenticationAuthenticatedWithoutFamily(account: account);
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
      yield AuthenticationAuthenticatedWithFamily(account: (state as AuthenticationAuthenticatedWithoutFamily).currentAccount, family: event.family);
    }
  }

  Stream<AuthenticationState> _mapLoggedInToState(LoggedIn event) async* {
    yield AuthenticationLoading();
    try {
      Account account = await _userRepository.verifyToken();
      await _userRepository.persistToken(event.token);
      yield AuthenticationAuthenticatedWithoutFamily(account: account);
    } catch(e) {
      yield AuthenticationUnauthenticated();
    }
  }

}