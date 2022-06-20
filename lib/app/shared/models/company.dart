// To parse this JSON data, do
//
//     final companyModel = companyModelFromJson(jsonString);

import 'dart:convert';

import 'package:roadmap/app/shared/models/work_domain.dart';

List<CompanyModel> companiesModelFromJson(String str) =>
    List<CompanyModel>.from(
        json.decode(str).map((x) => CompanyModel.fromJson(x)));

class CompanyModel {
  CompanyModel(
      {required this.id,
      required this.name,
      this.email,
      this.workDomain,
      required this.website,
      required this.about,
      this.workHours,
      this.timeZone,
      this.numOfEmployees,
      this.v,
      this.coverImage,
      this.logo});

  String id;
  String name;
  String? email;
  WorkDomain? workDomain;
  String website;
  String about;
  String? workHours;
  String? timeZone;
  int? numOfEmployees;
  int? v;
  String? logo;
  String? coverImage;

  factory CompanyModel.fromJson(Map<String, dynamic> json) => CompanyModel(
      id: json["_id"],
      name: json["name"],
      email: json["email"],
      workDomain: json['workDomain'] == null
          ? null
          : WorkDomain.fromJson(json["workDomain"]),
      website: json["website"],
      about: json["about"],
      workHours: json["workHours"],
      timeZone: json["timeZone"],
      numOfEmployees: json["numOfEmployees"],
      v: json["__v"],
      coverImage: json["coverImage"],
      logo: json["logo"]);
}
