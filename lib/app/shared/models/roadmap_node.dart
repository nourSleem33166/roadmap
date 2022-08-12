// To parse this JSON data, do
//
//     final roadmapNode = roadmapNodeFromJson(jsonString);

import 'dart:convert';

List<RoadmapNode> roadmapNodeFromJson(String str) => List<RoadmapNode>.from(
    json.decode(str).map((x) => RoadmapNode.fromJson(x)));

class RoadmapNode {
  RoadmapNode({
    required this.id,
    required this.roadmapId,
    required this.label,
    required this.referenceId,
    required this.requiredHoursToStudy,
    required this.type,
    required this.accessType,
    required this.quantityOfRequiredQ,
    required this.quantityOfOptionalQ,
    required this.parents,
    required this.supplements,
    required this.v,
    this.deletedAt,
    this.isPassed
  });


  //  {
  //     "_id": "62eff883ae75aad5dc4b43f4",
  //     "roadmapId": "626857693d70ad9a9638695d",
  //     "label": "TypeScript",
  //     "referenceId": null,
  //     "requiredHoursToStudy": 10,
  //     "type": "section",
  //     "accessType": "required",
  //     "quantityOfRequiredQ": 3,
  //     "quantityOfOptionalQ": 1,
  //     "parents": [],
  //     "supplements": [],
  //     "__v": 0,
  //     "isPassed": false
  //   },

  String id;
  String roadmapId;
  String label;
  String? referenceId;
  int requiredHoursToStudy;
  String type;
  String accessType;
  int quantityOfRequiredQ;
  int quantityOfOptionalQ;
  List<String> parents;
  List<String> supplements;
  int v;
  DateTime? deletedAt;
  bool? isPassed;

  factory RoadmapNode.fromJson(Map<String, dynamic> json) => RoadmapNode(
        id: json["_id"],
        roadmapId: json["roadmapId"],
        label: json["label"],
        referenceId: json["referenceId"],
        requiredHoursToStudy: json["requiredHoursToStudy"],
        type: json["type"],
        accessType: json["accessType"],
        quantityOfRequiredQ: json["quantityOfRequiredQ"],
        quantityOfOptionalQ: json["quantityOfOptionalQ"],
        parents: List<String>.from(json["parents"].map((x) => x)),
        supplements: List<String>.from(json["supplements"].map((x) => x)),
        v: json["__v"],
        deletedAt: json["deletedAt"] == null
            ? null
            : DateTime.parse(json["deletedAt"]),
    isPassed: json['isPassed']
      );
}
