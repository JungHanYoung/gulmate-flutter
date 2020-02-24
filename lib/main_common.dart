import 'package:flutter/cupertino.dart';
import 'package:gulmate/app.dart';
import 'package:gulmate/auth_wrapper.dart';

import 'config_reader.dart';

Future<void> mainCommon(String env) async {
  WidgetsFlutterBinding.ensureInitialized();

  await ConfigReader.initialize();

  runApp(
    AuthWrapper(child: App())
  );
}