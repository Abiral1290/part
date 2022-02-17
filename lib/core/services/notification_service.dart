import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static NotificationDetails _platform;

  static FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  static FlutterLocalNotificationsPlugin _init() {
    _flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();
    var androidSettings = AndroidInitializationSettings("@mipmap/ic_launcher");
    var iOSSettings = IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );
    var initSetttings =
        InitializationSettings(android: androidSettings, iOS: iOSSettings);
    _flutterLocalNotificationsPlugin.initialize(initSetttings,
        onSelectNotification: _onClick);
    var androidDetails = AndroidNotificationDetails(
      '1',
      'Vehicle Alert',
      'Show notification when user reqest a vehicle',
      icon: '@mipmap/ic_launcher',
      importance: Importance.max,
      fullScreenIntent: true,
      priority: Priority.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound('alert'),
      largeIcon: DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
    );
    var iOSDetails = IOSNotificationDetails();
    _platform = NotificationDetails(android: androidDetails, iOS: iOSDetails);
    return _flutterLocalNotificationsPlugin;
  }

  static Future<dynamic> _onClick(String a) async {}

  static void showNotif({int id, String title, String body}) {
    if (_flutterLocalNotificationsPlugin == null) _init();

    _flutterLocalNotificationsPlugin.show(id, title, body, _platform);
  }
}
