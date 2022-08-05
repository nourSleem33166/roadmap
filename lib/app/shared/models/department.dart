import 'dart:convert';

import 'package:mobx/mobx.dart';

List<Department> deptsFromJson(String str) =>
    List<Department>.from(json.decode(str).map((x) => Department.fromJson(x)));

class Department {
  Department(
      {required this.id,
      required this.name,
      required this.description,
      required this.isFollowed});

  String id;
  String name;
  String description;
  Observable<bool>? isFollowed;

  factory Department.fromJson(Map<String, dynamic> json) => Department(
      id: json["_id"],
      name: json["name"],
      description: json["description"],
      isFollowed: json['isFollowed'] == null ? null : Observable(json['isFollowed']));

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "description": description,
      };
}
