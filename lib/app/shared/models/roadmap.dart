// To parse this JSON data, do
//
//     final roadmapModel = roadmapModelFromJson(jsonString);

import 'dart:convert';

import 'package:roadmap/app/shared/models/company.dart';

import 'department.dart';

List<RoadmapModel> roadmapsModelFromJson(String str) => List<RoadmapModel>.from(
    json.decode(str).map((x) => RoadmapModel.fromJson(x)));

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
      required this.published});

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

  factory RoadmapModel.fromJson(Map<String, dynamic> json) => RoadmapModel(
      id: json["_id"],
      departmentId: json["departmentId"],
      companyId: json["companyId"],
      title: json["title"],
      description: json["description"],
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      v: json["__v"],
      company:json["company"]==null?null: CompanyModel.fromJson(json["company"]),
      department: json["department"]==null?null:Department.fromJson(json["department"]),
      published: json["published"]);
}

//// To parse this JSON data, do
// //
// //     final roadmapModel = roadmapModelFromJson(jsonString);
//
// import 'dart:convert';
//
// List<RoadmapModel> roadmapModelFromJson(String str) => List<RoadmapModel>.from(json.decode(str).map((x) => RoadmapModel.fromJson(x)));
//
// String roadmapModelToJson(List<RoadmapModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
//
// class RoadmapModel {
//     RoadmapModel({
//         this.id,
//         this.departmentId,
//         this.companyId,
//         this.title,
//         this.description,
//         this.published,
//         this.createdAt,
//         this.updatedAt,
//         this.v,
//     });
//
//     String id;
//     String departmentId;
//     String companyId;
//     String title;
//     String description;
//     bool published;
//     DateTime createdAt;
//     DateTime updatedAt;
//     int v;
//
//     factory RoadmapModel.fromJson(Map<String, dynamic> json) => RoadmapModel(
//         id: json["_id"],
//         departmentId: json["departmentId"],
//         companyId: json["companyId"],
//         title: json["title"],
//         description: json["description"],
//         published: json["published"],
//         createdAt: DateTime.parse(json["createdAt"]),
//         updatedAt: DateTime.parse(json["updatedAt"]),
//         v: json["__v"],
//     );
//
//     Map<String, dynamic> toJson() => {
//         "_id": id,
//         "departmentId": departmentId,
//         "companyId": companyId,
//         "title": title,
//         "description": description,
//         "published": published,
//         "createdAt": createdAt.toIso8601String(),
//         "updatedAt": updatedAt.toIso8601String(),
//         "__v": v,
//     };
// }
