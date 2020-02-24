import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:gulmate/app.dart';
import 'package:gulmate/auth_wrapper.dart';
import 'package:gulmate/environment.dart';
import 'package:gulmate/repository/repository.dart';

import 'bloc/simple_bloc_delegate.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  Dio baseDio = Dio(BaseOptions(
    baseUrl: "https://gulmate.site",
  ));
  baseDio.interceptors.add(InterceptorsWrapper(
    onError: (error) async {
      print(error.response.statusCode);
      return error;
    },
    onResponse: (options) async {
      print(options.statusCode);
      return options;
    },
    onRequest: (options) async {
      print(options.headers);
      return options;
    }
  ));
  GetIt.instance.registerSingleton(UserRepository(baseDio));
  GetIt.instance.registerSingleton(FamilyRepository(baseDio));
  GetIt.instance.registerSingleton(PurchaseRepository(baseDio));
  GetIt.instance.registerSingleton(CalendarRepository(baseDio));

  runApp(
    AuthWrapper(
      child: App(),
    ));
}

//Future<void> main() async {
//  await mainCommon(Environment.prod);
//}