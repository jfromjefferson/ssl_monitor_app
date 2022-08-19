import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ssl_monitor/database/model/service/service.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const NotificationDetails _notificationDetails = NotificationDetails(
    android: AndroidNotificationDetails(
      'service_notification',
      'service_notification_channel',
      channelDescription: 'Service notification',
      importance: Importance.max,
      priority: Priority.high,
    ),
  );

  static Future<void> initialize() async {
    tz.initializeTimeZones();

    InitializationSettings initializationSettings =
        const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    _notificationsPlugin.initialize(initializationSettings);
    //_notificationsPlugin.cancelAll();
  }

  static Future<void> schedule({required Service service}) async {
    try {
      tz.TZDateTime time = tz.TZDateTime.from(
          DateTime.now().add(
            const Duration(seconds: 20),
          ),
          tz.local);

      await _notificationsPlugin.zonedSchedule(
        service.key,
        service.name,
        service.url,
        time,
        _notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
      );
    } catch (e) {
      print({'Err': e});
    }
  }

  static Future<void> cancelNotification({required int id}) async {
    await _notificationsPlugin.cancel(id);
  }
}
