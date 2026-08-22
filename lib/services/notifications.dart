import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await plugin.initialize(
      settings: settings,
    );
  }

  static Future<void> show(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'nizam_tasks',
      'Nizam OS',
      channelDescription: 'Nizam OS local notifications',
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    final int notificationId =
        DateTime.now().millisecondsSinceEpoch ~/ 1000;

    await plugin.show(
      id: notificationId,
      title: title,
      body: body,
      notificationDetails: details,
    );
  }
}
