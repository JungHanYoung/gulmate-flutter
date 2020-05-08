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

abstract class AuthenticationAuthenticated extends AuthenticationState {
  final Account currentAccount;

  AuthenticationAuthenticated(this.currentAccount);

}

class AuthenticationAuthenticatedWithoutFamily extends AuthenticationAuthenticated {

  AuthenticationAuthenticatedWithoutFamily(Account currentAccount) : super(currentAccount);
}

class AuthenticationAuthenticatedWithFamily extends AuthenticationAuthenticated {
  final Family _currentFamily;

  Family get currentFamily => _currentFamily;

  AuthenticationAuthenticatedWithFamily({
    @required Account account,
    @required Family family,
  }) : assert(account != null),
        _currentFamily = family, super(account);

  @override
  List<Object> get props => [super.currentAccount, _currentFamily];
}

class AuthenticationLoading extends AuthenticationState {}