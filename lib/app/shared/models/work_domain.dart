// To parse this JSON data, do
//
//     final workDomain = workDomainFromJson(jsonString);

import 'dart:convert';

List<WorkDomain> workDomainFromJson(String str) =>
    List<WorkDomain>.from(json.decode(str).map((x) => WorkDomain.fromJson(x)));

String workDomainToJson(List<WorkDomain> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class WorkDomain {
  WorkDomain({
    required this.id,
    required this.text,
    required this.v,
  });

  String id;
  String text;
  int? v;

  factory WorkDomain.fromJson(Map<String, dynamic> json) => WorkDomain(
        id: json["_id"],
        text: json["text"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "text": text,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkDomain &&
          runtimeType == other.runtimeType &&
          this.id == other.id;

  @override
  int get hashCode => this.hashCode;
}
