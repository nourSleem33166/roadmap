// To parse this JSON data, do
//
//     final roadmapModel = roadmapModelFromJson(jsonString);

import 'dart:convert';

import 'package:roadmap/app/shared/models/company.dart';

import 'department.dart';

List<RoadmapModel> roadmapsModelFromJson(String str) =>
    List<RoadmapModel>.from(json.decode(str).map((x) => RoadmapModel.fromJson(x)));

class RoadmapModel {
  RoadmapModel(
      {required this.id,
      required this.departmentId,
      required this.companyId,
      required this.title,
      required this.description,
      required this.createdAt,
      required this.updatedAt,
      required this.v,
      required this.company,
      required this.department,
      required this.published,
      required this.learnStatus});

  String id;
  String departmentId;
  String companyId;
  String title;
  String description;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  CompanyModel? company;
  Department? department;
  bool published;
  LearnStatus? learnStatus;

  factory RoadmapModel.fromJson(Map<String, dynamic> json) => RoadmapModel(
      id: json["_id"],
      departmentId: json["departmentId"],
      companyId: json["companyId"],
      title: json["title"],
      description: json["description"],
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      learnStatus: json['learnStatus'] == "none"
          ? LearnStatus.None
          : json['learnStatus'] == 'learned'
              ? LearnStatus.Learned
              : LearnStatus.Learning,
      v: json["__v"],
      company: json["company"] == null ? null : CompanyModel.fromJson(json["company"]),
      department: json["department"] == null ? null : Department.fromJson(json["department"]),
      published: json["published"]);
}

enum LearnStatus { None, Learning, Learned }
