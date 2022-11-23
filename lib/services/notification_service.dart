import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  Future<void> init() {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('app_icon');

    IOSInitializationSettings initializationSettingsIOS =
        const IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      //onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: null);
    return _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Future onSelectNotification(context) async {
  //   if (context != null) {
  //     debugPrint('notification payload: $context');
  //   }
  //   await Navigator.push(
  //     context,
  //     MaterialPageRoute<void>(builder: (context) => const BadEquipmentPage()),
  //   );
  // }

  // Future onDidReceiveLocalNotification(
  //     int id, String? title, String? body, String? payload) async {
  //   // Implement your own logic
  // }

  Future<void> notification() async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channelId',
      'channelName',
      importance: Importance.max,
      priority: Priority.high,
      icon: 'app_icon',
    );
    const IOSNotificationDetails iOSPlatformChannelSpecifics =
        IOSNotificationDetails();
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await _flutterLocalNotificationsPlugin.periodicallyShow(
        0,
        'Inventory',
        'More than one equipment is bad',
        RepeatInterval.daily,
        platformChannelSpecifics,
        payload: 'Notification Payload');
  }

  Future<void> cancelNotification() async {
    await _flutterLocalNotificationsPlugin.cancel(0);
  }
}
