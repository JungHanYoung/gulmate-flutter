import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper {

  static FlutterLocalNotificationsPlugin notification = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    var androidInitializationSettings = AndroidInitializationSettings("@mipmap-hdpi/ic_launcher.png");
    var iosInitializationSettings = IOSInitializationSettings();

    await notification.initialize(InitializationSettings(androidInitializationSettings, iosInitializationSettings));
  }

}