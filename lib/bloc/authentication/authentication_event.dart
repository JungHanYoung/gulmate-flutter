import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:gulmate/model/family.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];

}

class AppStarted extends AuthenticationEvent {}

class LoggedIn extends AuthenticationEvent {
  final String token;

  const LoggedIn({
    @required this.token,
  });

  @override
  List<Object> get props => [token];

  @override
  String toString() {
    return 'LoggedIn{token: $token}';
  }
}

class LoggedOut extends AuthenticationEvent {}

class ReadySignIn extends AuthenticationEvent {}

class WithFamily extends AuthenticationEvent {
  final Family family;

  const WithFamily(this.family);

  @override
  List<Object> get props => [family];

  @override
  String toString() {
    return 'withFamily{family: $family}';
  }
}

class WithoutFamily extends AuthenticationEvent {

  const WithoutFamily();

  @override
  String toString() {
    return 'WithoutFamily{}';
  }


}
