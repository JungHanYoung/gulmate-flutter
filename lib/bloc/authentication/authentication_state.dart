import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:gulmate/model/account.dart';
import 'package:gulmate/model/family.dart';

abstract class AuthenticationState extends Equatable {

  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationUninitialized extends AuthenticationState {}

class AuthenticationUnauthenticated extends AuthenticationState {}

class AuthenticationAuthenticatedWithoutFamily extends AuthenticationState {
  final Account _currentAccount;

  Account get currentAccount => _currentAccount;

  AuthenticationAuthenticatedWithoutFamily({
    @required Account account,
  }) : assert(account != null),
  _currentAccount = account;
}

class AuthenticationAuthenticatedWithFamily extends AuthenticationState {
  final Account _currentAccount;
  final Family _currentFamily;

  Account get currentAccount => _currentAccount;
  Family get currentFamily => _currentFamily;

  AuthenticationAuthenticatedWithFamily({
    @required Account account,
    @required Family family,
  }) : assert(account != null),
        _currentAccount = account,
        _currentFamily = family;
}

class AuthenticationLoading extends AuthenticationState {}