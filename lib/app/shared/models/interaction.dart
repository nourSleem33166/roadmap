// To parse this JSON data, do
//
//     final interaction = interactionFromJson(jsonString);

import 'dart:convert';

import 'comment_model.dart';

List<Interaction> interactionsFromJson(String str) => List<Interaction>.from(
    json.decode(str).map((x) => Interaction.fromJson(x)));

class Interaction {
  Interaction({
    required this.id,
    required this.commentId,
    required this.learnerId,
    required this.type,
    required this.learner,
  });

  String id;
  String commentId;
  String learnerId;
  String? type;
  Learner? learner;

  factory Interaction.fromJson(Map<String, dynamic> json) => Interaction(
        id: json["_id"],
        commentId: json["commentId"],
        learnerId: json["learnerId"],
        type: json["type"],
        learner:
            json["learner"] == null ? null : Learner.fromJson(json["learner"]),
      );
}
