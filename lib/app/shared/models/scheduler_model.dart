// To parse this JSON data, do
//
//     final interaction = interactionFromJson(jsonString);

import 'dart:convert';
import 'dart:developer';

import 'package:calendar_view/calendar_view.dart';
import 'package:easy_localization/easy_localization.dart';



SchedulerModel schedulerModelFromJson(String str) =>
    SchedulerModel.fromJson(json.decode(str));

String schedulerModelToJson(SchedulerModel data) => json.encode(data.toJson());

class SchedulerModel {
  SchedulerModel({
    required this.learnWeek,
    required this.roadmaps,
  });

  LearnWeek learnWeek;
  List<Roadmap>? roadmaps;

  factory SchedulerModel.fromJson(Map<String, dynamic> json) => SchedulerModel(
        learnWeek: LearnWeek.fromJson(json["learnWeek"]),
        roadmaps: json["roadmaps"] == null
            ? []
            : List<Roadmap>.from(json["roadmaps"].map((x) => Roadmap.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "learnWeek": learnWeek.toJson(),
        "roadmaps":
            roadmaps == null ? null : List<dynamic>.from(roadmaps!.map((x) => x.toJson())),
      };
}

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

  @override
  String toString() {
    return 'LearnWeek{sat: $sat, sun: $sun, mon: $mon, tue: $tue, wed: $wed, thu: $thu, fri: $fri}';
  }
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

  @override
  String toString() {
    return 'WeekDay{isHoliday: $isHoliday, dates: $dates}';
  }
}

class SchedulerDate {
  String? startAt;
  String? endAt;
  String? referenceId;

  SchedulerDate({required this.startAt, required this.endAt, required this.referenceId});

  factory SchedulerDate.fromScheduler(CalendarEventData data) {
    return SchedulerDate(
        startAt: DateFormat('HH:mm').format(data.startTime!),
        endAt: DateFormat('HH:mm').format(data.endTime!),
        referenceId: data.event?.toString() ?? "");
  }

  factory SchedulerDate.fromJson(Map<String, dynamic> json) {
   return SchedulerDate(
       endAt: json['endAt'], startAt: json['startAt'], referenceId: json['referenceId']);
  }

  Map<String, dynamic> toJson() =>
      {'endAt': endAt, 'startAt': startAt, 'referenceId': referenceId};

  @override
  String toString() {
    return 'SchedulerDate{startAt: $startAt, endAt: $endAt, referenceId: $referenceId}';
  }
}

class Roadmap {
  Roadmap({
    required this.id,
    required this.name,
  });

  String id;
  String name;

  factory Roadmap.fromJson(Map<String, dynamic> json) => Roadmap(
        id: json["_id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
      };
}
