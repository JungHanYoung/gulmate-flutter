import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:gulmate/bloc/authentication/authentication.dart';
import 'package:gulmate/bloc/family/family_bloc.dart';
import 'package:gulmate/bloc/simple_bloc_delegate.dart';
import 'package:gulmate/bloc/tab/app_tab.dart';
import 'package:gulmate/bloc/view/check_invite/check_invite_view_bloc.dart';
import 'package:gulmate/main.dart';
import 'package:gulmate/repository/family_repository.dart';
import 'package:gulmate/repository/user_repository.dart';

import 'app_config.dart';
import 'bloc/intro/intro.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();
  Dio baseDio = Dio(BaseOptions(baseUrl: "http://localhost:8080"));
  GetIt.instance.registerSingleton(UserRepository(baseDio));
  GetIt.instance.registerSingleton(FamilyRepository(baseDio));
  var configuredApp = AppConfig(
    flavorName: "development",
    appName: "Gulmate",
    apiBaseUrl: "http://192.168.0.106:8080",
    child: MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationBloc>(
            create: (context) =>
                AuthenticationBloc()),
        BlocProvider<AppTabBloc>(
          create: (context) => AppTabBloc(),
        ),
        BlocProvider<CheckInviteViewBloc>(
          create: (context) => CheckInviteViewBloc(),
        ),
        BlocProvider<FamilyBloc>(
          create: (context) => FamilyBloc(
              authenticationBloc: BlocProvider.of<AuthenticationBloc>(context),
              checkInviteViewBloc: BlocProvider.of<CheckInviteViewBloc>(context),
          ),
        ),
        BlocProvider<IntroBloc>(
          create: (context) => IntroBloc(),
        ),
      ],
      child: MyApp(),
    ),
  );

  runApp(configuredApp);
}
