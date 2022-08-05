import 'package:flutter/material.dart';
import 'package:flutter_week_view/flutter_week_view.dart';
import 'package:roadmap/app/shared/models/scheduler_model.dart';

class SchedulerPage extends StatefulWidget {
  final LearnWeek learnWeek = LearnWeek(
      sat: WeekDay(isHoliday: false, dates: [
        SchedulerDate(startAt: '12:30', endAt: '14:30', referenceId: 'someId'),
        SchedulerDate(startAt: '15:30', endAt: '16:30', referenceId: 'someId'),
      ]),
      sun: WeekDay(isHoliday: true, dates: []),
      mon: WeekDay(isHoliday: true, dates: []),
      tue: WeekDay(isHoliday: true, dates: []),
      wed: WeekDay(isHoliday: true, dates: []),
      thu: WeekDay(isHoliday: true, dates: []),
      fri: WeekDay(isHoliday: true, dates: []));

  @override
  _SchedulerPageState createState() => _SchedulerPageState();
}

class _SchedulerPageState extends State<SchedulerPage> {
  @override
  Widget build(BuildContext context) {
    final date=DateTime.now();
    return Scaffold(
      body: WeekView(
        dates: [date.subtract(Duration(days: 1)), date, date.add(Duration(days: 1))],
        events: [
          FlutterWeekViewEvent(
            title: 'An event 2',
            description: 'A description 2',
            start: date.add(Duration(hours: 19)),
            end: date.add(Duration(hours: 22)),
          ),
          FlutterWeekViewEvent(
            title: 'An event 3',
            description: 'A description 3',
            start: date.add(Duration(hours: 23, minutes: 30)),
            end: date.add(Duration(hours: 25, minutes: 30)),
          ),
          FlutterWeekViewEvent(
            title: 'An event 4',
            description: 'A description 4',
            start: date.add(Duration(hours: 20)),
            end: date.add(Duration(hours: 21)),
          ),
          FlutterWeekViewEvent(
            title: 'An event 5',
            description: 'A description 5',
            start: date.add(Duration(hours: 20)),
            end: date.add(Duration(hours: 21)),
          ),
        ],
      ),
    );
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



