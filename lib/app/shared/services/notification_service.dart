import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:roadmap/app/shared/models/scheduler_model.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._internal();

  static final instance = NotificationService._internal();
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  List<Roadmap> userRoadmaps = [];

  Future<void> init() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final MacOSInitializationSettings initializationSettingsMacOS =
        MacOSInitializationSettings();
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, macOS: initializationSettingsMacOS);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );

    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
  }

  Future scheduleNotifications(LearnWeek learnWeek, List<Roadmap> userRoadmaps) async {
    await flutterLocalNotificationsPlugin.cancelAll();
    this.userRoadmaps = userRoadmaps;
    scheduleWeekday(DateTime.saturday, learnWeek.sat.dates);
    scheduleWeekday(DateTime.sunday, learnWeek.sun.dates);
    scheduleWeekday(DateTime.monday, learnWeek.mon.dates);
    scheduleWeekday(DateTime.tuesday, learnWeek.tue.dates);
    scheduleWeekday(DateTime.wednesday, learnWeek.wed.dates);
    scheduleWeekday(DateTime.thursday, learnWeek.thu.dates);
    scheduleWeekday(DateTime.friday, learnWeek.fri.dates);
  }

  void scheduleWeekday(int weekday, List<SchedulerDate> dates) {
    final nearestDate = DateTime.now().next(weekday);
    dates.forEach((date) {
      final roadmap = userRoadmaps.singleWhere((element) => element.id == date.referenceId);
      final startHour = int.parse(date.startAt!.split(':')[0]);
      final startMinutes = int.parse(date.startAt!.split(':')[1]);
      log("start hour is $startHour");
      log("start minute is $startMinutes");

      final dateToSchedule = tz.TZDateTime.local(
          nearestDate.year, nearestDate.month, nearestDate.day, startHour, startMinutes);
      final now = tz.TZDateTime.now(tz.local);

      flutterLocalNotificationsPlugin.zonedSchedule(
          now.microsecond,
          'Learning Reminder',
          'Don\'t forget to learn ${roadmap.name}',
          dateToSchedule,
          NotificationDetails(
              android: AndroidNotificationDetails('1', '2',

                  priority: Priority.high, importance: Importance.max, playSound: true)),
          androidAllowWhileIdle: true,
          matchDateTimeComponents: DateTimeComponents.time,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.wallClockTime);
    });
  }
}

extension DateTimeExtension on DateTime {
  DateTime next(int day) {
    return this.add(
      Duration(
        days: (day - this.weekday) % DateTime.daysPerWeek,
      ),
    );
  }
}
