
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationHelper {
  static final notification = FlutterLocalNotificationsPlugin();

  static init() {
    notification.initialize(const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    ));

    tz.initializeTimeZones();
  }

 
 

  static showNotification(String title, String body) async {
    print('*************$title');
    print('************$body');

    var androidDetails = const AndroidNotificationDetails(
        'channel id 2', 'normal notification',
        channelDescription: 'normal notification',
        playSound: true,
        importance: Importance.max,
        priority: Priority.high);
    var notificationDetatils = NotificationDetails(android: androidDetails);

    await notification.show(0, title, body, notificationDetatils);
  }


  static scheduledNotification(String title, String body) async {
    var androidDetails = const AndroidNotificationDetails(
        'important_notifications', 'My Channel',
        importance: Importance.max, priority: Priority.high);
    var notificationDetatils = NotificationDetails(android: androidDetails);

    await notification.zonedSchedule(
        0,
        title,
        body,
        tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10)),
        notificationDetatils,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle);
  }
}
