import 'package:flutter_local_notifications/flutter_local_notifications.dart';

abstract class NotificationDetail {
  static var androidSpecificDetail = AndroidNotificationDetails("android 1", "helloworld", "hell");
  static var iosSpecificDetail = IOSNotificationDetails();

  static var notificationDetail = NotificationDetails(androidSpecificDetail, iosSpecificDetail);
}