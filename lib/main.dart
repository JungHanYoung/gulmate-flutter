import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:gulmate/EnvironmentConfig.dart';
import 'package:gulmate/app_widget.dart';
import 'package:gulmate/wrapper/auth_wrapper.dart';

import 'bloc/simple_bloc_delegate.dart';
import 'repository/repository.dart';


enum Environment {
  DEV, PROD
}

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  String uri = "${EnvironmentConfig.IS_PROD ? "https" : "http"}://${EnvironmentConfig.API_DOMAIN}";
  String version = EnvironmentConfig.API_VERSION;
//  await NotificationHelper.initialize();
  uri += "/api/$version";

  // Bloc transition tracking
  if(!EnvironmentConfig.IS_PROD) {
    BlocSupervisor.delegate = SimpleBlocDelegate();
  }

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