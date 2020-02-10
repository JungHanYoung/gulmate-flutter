import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:gulmate/bloc/authentication/authentication.dart';
import 'package:gulmate/bloc/login/login_event.dart';
import 'package:gulmate/bloc/login/login_state.dart';
import 'package:gulmate/repository/user_repository.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  UserRepository _userRepository;
  final AuthenticationBloc authenticationBloc;

  LoginBloc({
    @required this.authenticationBloc,
  })  : assert(authenticationBloc != null) {
    _userRepository = GetIt.instance.get<UserRepository>();
  }

  @override
  LoginState get initialState => LoginInitial();

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is GoogleLoginButtonPressed) {
      yield* _mapGoogleLoginButtonPressedToState();
    } else if (event is FacebookLoginButtonPressed) {
      yield* _mapFacebookLoginButtonPressedToState();
    }
  }

  Stream<LoginState> _mapGoogleLoginButtonPressedToState() async* {
    yield LoginLoading();
    try {
      final String token = await _userRepository.onGoogleSignIn();
      authenticationBloc.add(LoggedIn(token: token));
      yield LoginInitial();
    } catch (error) {
      yield LoginFailure(error: error.toString());
    }
  }

  Stream<LoginState> _mapFacebookLoginButtonPressedToState() async* {
    yield LoginLoading();
    try {
      final String token = await _userRepository.onFacebookSignIn();
      authenticationBloc.add(LoggedIn(token: token));
      yield LoginInitial();
    } catch (error) {
      yield LoginFailure(error: error.toString());
    }
  }
}
