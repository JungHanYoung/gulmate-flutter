import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:gulmate/app.dart';
import 'package:gulmate/auth_wrapper.dart';
import 'package:gulmate/bloc/simple_bloc_delegate.dart';
import 'package:gulmate/environment.dart';
import 'package:gulmate/repository/chat_repository.dart';

import 'repository/repository.dart';


void main() {

  BlocSupervisor.delegate = SimpleBlocDelegate();
  Dio baseDio = Dio(BaseOptions(baseUrl: "http://localhost:8080"));
  baseDio.interceptors.add(InterceptorsWrapper(
    onRequest: (RequestOptions options) {
      final userRepository = GetIt.instance.get<UserRepository>();
      if(userRepository.token != null) {
        options.headers['Authorization'] = 'Bearer ${userRepository.token}';
      }
      return options;
    },
  ));
  GetIt.instance.registerSingleton(UserRepository(baseDio));
  GetIt.instance.registerSingleton(FamilyRepository(baseDio));
  GetIt.instance.registerSingleton(PurchaseRepository(baseDio));
  GetIt.instance.registerSingleton(CalendarRepository(baseDio));
  GetIt.instance.registerSingleton(ChatRepository(baseDio));
  runApp(AuthWrapper(child: App()));
}

//Future<void> main() async {
//  await mainCommon(Environment.dev);
//}