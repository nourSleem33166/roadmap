// To parse this JSON data, do
//
//     final exam = examFromJson(jsonString);

import 'dart:convert';

import 'package:mobx/mobx.dart';

Exam examFromJson(String str) => Exam.fromJson(json.decode(str));

String examToJson(Exam data) => json.encode(data.toJson());

class Exam {
  Exam({
    required this.exceptions,
    required this.exam,
  });

  List<dynamic> exceptions;
  ExamClass exam;

  factory Exam.fromJson(Map<String, dynamic> json) => Exam(
        exceptions: List<dynamic>.from(json["exceptions"].map((x) => x)),
        exam: ExamClass.fromJson(json["exam"]),
      );

  Map<String, dynamic> toJson() => {
        "exceptions": List<dynamic>.from(exceptions.map((x) => x)),
        "exam": exam.toJson(),
      };
}

class ExamClass {
  ExamClass({
    required this.learnerId,
    required this.roadmapId,
    required this.startedAt,
    required this.expiredAt,
    required this.levels,
    required this.id,
    required this.v,
  });

  String learnerId;
  String roadmapId;
  DateTime startedAt;
  DateTime expiredAt;
  List<Level> levels;
  String id;
  int v;

  factory ExamClass.fromJson(Map<String, dynamic> json) => ExamClass(
        learnerId: json["learnerId"],
        roadmapId: json["roadmapId"],
        startedAt: DateTime.parse(json["startedAt"]),
        expiredAt: DateTime.parse(json["expiredAt"]),
        levels: List<Level>.from(json["levels"].map((x) => Level.fromJson(x))),
        id: json["_id"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "learnerId": learnerId,
        "roadmapId": roadmapId,
        "startedAt": startedAt.toIso8601String(),
        "expiredAt": expiredAt.toIso8601String(),
        "levels": List<dynamic>.from(levels.map((x) => x.toJson())),
        "_id": id,
        "__v": v,
      };
}

class Level {
  Level(
      {required this.id,
      required this.nodeId,
      required this.title,
      required this.questions,
      required this.isPassed});

  String id;
  String nodeId;
  String title;
  List<Question> questions;
  Observable<bool?> isPassed;

  factory Level.fromJson(Map<String, dynamic> json) => Level(
      id: json["_id"],
      nodeId: json["nodeId"],
      title: json["title"],
      questions: List<Question>.from(json["questions"].map((x) => Question.fromJson(x))),
      isPassed: Observable(json['isPassed']));

  Map<String, dynamic> toJson() => {
        "_id": id,
        "nodeId": nodeId,
        "title": title,
        "questions": List<dynamic>.from(questions.map((x) => x.toJson())),
      };
}

class Question {
  Question({
    required this.questionId,
    required this.type,
    required this.mark,
    required this.text,
    required this.options,
  });

  String questionId;
  String type;
  int mark;
  String text;
  List<Option> options;

  factory Question.fromJson(Map<String, dynamic> json) => Question(
        questionId: json["questionId"],
        type: json["type"],
        mark: json["mark"],
        text: json["text"],
        options: List<Option>.from(json["options"].map((x) => Option.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "questionId": questionId,
        "type": type,
        "mark": mark,
        "text": text,
        "options": List<dynamic>.from(options.map((x) => x.toJson())),
      };
}

class Option {
  Option({required this.text, required this.isCorrect});

  String text;
  Observable<bool> isCorrect;

  factory Option.fromJson(Map<String, dynamic> json) => Option(
      text: json["text"],
      isCorrect:
          json['isCorrect'] == null ? Observable(false) : Observable(json['isCorrect']));

  Map<String, dynamic> toJson() => {"text": text, 'isCorrect': isCorrect.value};


}
