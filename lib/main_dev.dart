import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:gulmate/app.dart';
import 'package:gulmate/auth_wrapper.dart';
import 'package:gulmate/bloc/simple_bloc_delegate.dart';
import 'package:gulmate/repository/repository.dart';


void main() {

  BlocSupervisor.delegate = SimpleBlocDelegate();
  Dio baseDio = Dio(BaseOptions(baseUrl: "http://localhost:8080"));
  GetIt.instance.registerSingleton(UserRepository(baseDio));
  GetIt.instance.registerSingleton(FamilyRepository(baseDio));
  GetIt.instance.registerSingleton(PurchaseRepository(baseDio));
  GetIt.instance.registerSingleton(CalendarRepository(baseDio));
  runApp(AuthWrapper(child: App()));
}
