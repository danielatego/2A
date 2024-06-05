import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
// ignore: depend_on_referenced_packages
import 'package:timezone/timezone.dart' as tz;

int id = 23;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final StreamController<String?> SelectNotificationStream =
    StreamController<String?>.broadcast();

const MethodChannel platform = MethodChannel('Mahanaim.developers');

class ReceivedNotification {
  final int id;
  final String? title;
  final String? body;
  final String? payload;

  ReceivedNotification(
      {required this.id,
      required this.title,
      required this.body,
      required this.payload});
}

String? selectedNotificationPayload;

Future<void> configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}

Future<void> showNotification() async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails('your channel id', 'your channel name',
          channelDescription: 'your channel description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');
  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin.show(
      4, 'plain title', 'plain body', notificationDetails,
      payload: 'item x');
}

Future<void> cancelNotification(int id) async {
  await flutterLocalNotificationsPlugin.cancel(id);
}

Future<void> setupnotification(int taskid, DateTime date, String title,
    String? description, String frequency) async {
  await flutterLocalNotificationsPlugin.zonedSchedule(
      taskid,
      title,
      description ?? title,
      tz.TZDateTime(
          tz.local, date.year, date.month, date.day, date.hour, date.minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'home todo notification channel id',
          'home todo notification channel name',
          channelDescription: 'home todo notification description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
          sound: RawResourceAndroidNotificationSound('slow_spring_board'),
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: frequency == 'once' || frequency == 'Once'
          ? DateTimeComponents.dateAndTime
          : frequency == 'daily'
              ? DateTimeComponents.time
              : frequency == 'weekly'
                  ? DateTimeComponents.dayOfWeekAndTime
                  : DateTimeComponents.dayOfMonthAndTime,
      payload: taskid.toString());
}

class PaddedElevatedButton extends StatelessWidget {
  const PaddedElevatedButton({
    required this.buttonText,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final String buttonText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(buttonText),
        ),
      );
}
