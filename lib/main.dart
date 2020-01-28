import 'package:flutter/material.dart';
import 'package:gulmate/const/color.dart';
import 'package:gulmate/screens/splash_screen.dart';
import 'package:gulmate/services/auth_service.dart';
import 'package:gulmate/services/family_service.dart';
import 'package:provider/provider.dart';

import 'app_config.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var appConfig = AppConfig.of(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>.value(value: AuthService(apiBaseUrl: appConfig.apiBaseUrl)),
        ChangeNotifierProvider<FamilyService>.value(value: FamilyService()),
      ],
      child: MaterialApp(
        title: '귤메이트',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Color(0xFFFF6D00),
          fontFamily: "Spoqa",
          textSelectionColor: DEFAULT_BACKGROUND_COLOR,
        ),
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
