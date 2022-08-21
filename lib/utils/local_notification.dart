import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:ssl_monitor/database/model/service/service.dart';
import 'package:ssl_monitor/utils/functions.dart';
import 'package:ssl_monitor/utils/utils.dart';
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
      styleInformation: BigTextStyleInformation(''),
      color: purple,
    ),
  );

  static Future<void> initialize() async {
    tz.initializeTimeZones();

    InitializationSettings initializationSettings =
        const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    _notificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: selectNotification,
    );
    //_notificationsPlugin.cancelAll();
  }

  static Future<void> schedule({required Service service}) async {
    try {
      Map<dynamic, dynamic> serviceInfo = service.serviceInfo['ssl_properties'];
      DateTime strToDateTime = DateFormat('yyyy-MM-dd HH:mm').parse(
        serviceInfo['cert_valid_until'],
      );

      final dateList = getDaysInBetween(certValidUntil: strToDateTime);

      for (DateTime date in dateList) {
        tz.TZDateTime notificationTime = tz.TZDateTime.from(
          date,
          tz.local,
        );

        await _notificationsPlugin.zonedSchedule(
          service.key,
          service.name,
          'Your certificate will expire in ${date.difference(DateTime.now()).inDays} days (Tap here to stop notifications for ${service.name})',
          notificationTime,
          _notificationDetails,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidAllowWhileIdle: true,
          payload: service.uuid.toString(),
        );
      }

      /*tz.TZDateTime time = tz.TZDateTime.from(
        DateTime.now().add(
          const Duration(seconds: 5),
        ),
        tz.local,
      );

      await _notificationsPlugin.zonedSchedule(
        service.key,
        service.name,
        'Your certificate will expire in ${strToDateTime.difference(DateTime.now()).inDays} days (Tap here to stop notifications for ${service.name})',
        time,
        _notificationDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
        payload: service.uuid.toString(),
      );*/

    } catch (e) {
      print({'Err': e});
    }
  }

  static Future<void> cancelNotification({required int id}) async {
    await _notificationsPlugin.cancel(id);
  }

  static Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }
}
