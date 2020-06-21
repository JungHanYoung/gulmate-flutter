import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];


}

class GoogleLoginButtonPressed extends LoginEvent {}

class FacebookLoginButtonPressed extends LoginEvent {}
