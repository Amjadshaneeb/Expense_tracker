import 'package:expense_tracker_app/main.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> scheduleNotification(DateTime scheduledTime) async {
  tz.initializeTimeZones();
  final tz.TZDateTime scheduledDateTime =
      tz.TZDateTime.from(scheduledTime, tz.local);

  await flutterLocalNotificationsPlugin.show(
  0,
  "Test Notification",
  "This is a test message",
  const NotificationDetails(
    android: AndroidNotificationDetails(
      'reminder_channel',
      'Reminders',
      channelDescription: 'Channel for reminders',
      importance: Importance.high,
      priority: Priority.high,
    ),
  ),
);

}




