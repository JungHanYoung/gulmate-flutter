import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:gulmate/app_widget.dart';
import 'package:gulmate/helper/notification_helper.dart';
import 'package:gulmate/wrapper/auth_wrapper.dart';
import 'package:gulmate/helper/environment.dart';

import 'bloc/simple_bloc_delegate.dart';
import 'helper/config_reader.dart';
import 'repository/repository.dart';


Future<void> mainCommon(String env) async {
  WidgetsFlutterBinding.ensureInitialized();

  await ConfigReader.initialize();
//  await NotificationHelper.initialize();
  String uri = 'https://gulmate.site';
  if(env == Environment.dev) {
    uri = Platform.isIOS ? 'http://localhost:8080' : 'http://10.0.2.2:8080';
    BlocSupervisor.delegate = SimpleBlocDelegate();
  }
  uri += "/api/v1";

  Dio baseDio = Dio(BaseOptions(baseUrl: uri));
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