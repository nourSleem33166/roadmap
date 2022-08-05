// To parse this JSON data, do
//
//     final companyModel = companyModelFromJson(jsonString);

import 'dart:convert';

import 'package:mobx/mobx.dart';
import 'package:roadmap/app/shared/models/work_domain.dart';

List<CompanyModel> companiesModelFromJson(String str) =>
    List<CompanyModel>.from(json.decode(str).map((x) => CompanyModel.fromJson(x)));

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
      this.logo,
      required this.isFavorite,
      required this.isFollowed});

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
  Observable<bool>? isFollowed;
  Observable<bool>? isFavorite;

  factory CompanyModel.fromJson(Map<String, dynamic> json) => CompanyModel(
      id: json["_id"],
      name: json["name"],
      email: json["email"],
      workDomain: json['workDomain'] == null ? null : WorkDomain.fromJson(json["workDomain"]),
      website: json["website"],
      about: json["about"],
      workHours: json["workHours"],
      timeZone: json["timeZone"],
      numOfEmployees: json["numOfEmployees"],
      v: json["__v"],
      coverImage: json["coverImage"],
      isFavorite: json['isFavourite'] == null ? null : Observable(json['isFavourite']),
      isFollowed: json['isFollowed'] == null ? null : Observable(json['isFollowed']),
      logo: json["logo"]);
}
