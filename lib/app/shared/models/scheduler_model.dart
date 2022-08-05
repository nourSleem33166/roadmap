// To parse this JSON data, do
//
//     final interaction = interactionFromJson(jsonString);

import 'dart:convert';

LearnWeek learnWeekFromJson(String str) => LearnWeek.fromJson(json.decode(str));

String learnWeekToJson(LearnWeek data) => json.encode(data.toJson());

class LearnWeek {
  LearnWeek({
    required this.sat,
    required this.sun,
    required this.mon,
    required this.tue,
    required this.wed,
    required this.thu,
    required this.fri,
  });

  WeekDay sat;
  WeekDay sun;
  WeekDay mon;
  WeekDay tue;
  WeekDay wed;
  WeekDay thu;
  WeekDay fri;

  factory LearnWeek.fromJson(Map<String, dynamic> json) => LearnWeek(
        sat: WeekDay.fromJson(json["Sat"]),
        sun: WeekDay.fromJson(json["Sun"]),
        mon: WeekDay.fromJson(json["Mon"]),
        tue: WeekDay.fromJson(json["Tue"]),
        wed: WeekDay.fromJson(json["Wed"]),
        thu: WeekDay.fromJson(json["Thu"]),
        fri: WeekDay.fromJson(json["Fri"]),
      );

  Map<String, dynamic> toJson() => {
        "Sat": sat.toJson(),
        "Sun": sun.toJson(),
        "Mon": mon.toJson(),
        "Tue": tue.toJson(),
        "Wed": wed.toJson(),
        "Thu": thu.toJson(),
        "Fri": fri.toJson(),
      };
}

class WeekDay {
  WeekDay({
    required this.isHoliday,
    required this.dates,
  });

  bool isHoliday;
  List<SchedulerDate> dates;

  factory WeekDay.fromJson(Map<String, dynamic> json) => WeekDay(
        isHoliday: json["isHoliday"],
        dates: List<SchedulerDate>.from(json["dates"].map((x) => SchedulerDate.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "isHoliday": isHoliday,
        "dates": List<SchedulerDate>.from(dates.map((x) => x)),
      };
}

class SchedulerDate {
  String? startAt;
  String? endAt;
  String? referenceId;

  SchedulerDate({required this.startAt, required this.endAt, required this.referenceId});

  factory SchedulerDate.fromJson(Map<String, dynamic> json) => SchedulerDate(
      endAt: json['endAt'], startAt: json['startAt'], referenceId: json['referenceId']);

  Map<String, dynamic> toJson() =>
      {'endAt': endAt, 'startAt': startAt, 'referenceId': referenceId};
}
