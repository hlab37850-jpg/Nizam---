import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final plugin = FlutterLocalNotificationsPlugin();
  static Future<void> init() async {
    const settings = AndroidInitializationSettings('@mipmap/ic_launcher');
    await plugin.initialize(const InitializationSettings(android: settings));
  }
  static Future<void> show(String title, String body) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails('nizam_tasks','Nizam OS',
        channelDescription:'Nizam OS local notifications', importance: Importance.high, priority: Priority.high),
    );
    await plugin.show(DateTime.now().millisecondsSinceEpoch ~/ 1000, title, body, details);
  }
}
