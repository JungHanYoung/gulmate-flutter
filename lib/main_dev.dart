import 'package:flutter/material.dart';
import 'package:gulmate/main.dart';

import 'app_config.dart';

void main() {
  var configuredApp = AppConfig(
    flavorName: "development",
    appName: "Gulmate",
    apiBaseUrl: "http://localhost:3000",
    child: MyApp(),
  );

  runApp(configuredApp);
}
