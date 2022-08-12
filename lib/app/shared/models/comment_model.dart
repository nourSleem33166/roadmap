import 'dart:convert';
import 'dart:io';

import 'package:mobx/mobx.dart';
import 'package:roadmap/app/shared/models/user.dart';

import 'comment_interaction.dart';
import 'interaction.dart';

List<Comment> commentsFromJson(String str) =>
    List<Comment>.from(json.decode(str).map((x) => Comment.fromJson(x)));

class Comment {
  Comment(
      {required this.id,
      required this.text,
      this.attachment,
      required this.interactions,
      this.createdAt,
      this.updatedAt,
      required this.learnerId,
      required this.roadmapId,
      required this.parentId,
      required this.learner,
      required this.interactionValue,
      this.file});

  late String id;
  late String text;
  String? attachment;
  late List<CommentInteraction> interactions;
  late String? createdAt;
  late String? updatedAt;
  late String learnerId;
  late String? roadmapId;
  String? parentId;
  late final Learner learner;
  late Observable<Interaction?> interactionValue;
  File? file;

  factory Comment.copyWith(Comment comment) {
    return Comment(
        id: comment.id,
        text: comment.text,
        interactions: comment.interactions,
        learnerId: comment.learnerId,
        roadmapId: comment.roadmapId,
        parentId: comment.parentId,
        learner: comment.learner,
        interactionValue: comment.interactionValue);
  }

  Comment.fromJson(Map<String, dynamic> json, [User? user]) {
    id = json['_id'];
    text = json['text'];
    attachment = json['attachment'];
    interactions = List.castFrom<dynamic, CommentInteraction>(json['interactions']);
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    learnerId = json['learnerId'];
    roadmapId = json['roadmapId'];
    parentId = json['parentId'];
    learner = json["learner"] == null
        ? Learner(
            id: user!.id,
            firstName: user.firstName,
            lastName: user.lastName,
            personalImage: user.personalImage ?? "")
        : Learner.fromJson(json['learner']);
    interactionValue = json['interactionValue'] == null
        ? Observable(null)
        : Observable(Interaction.fromJson(json['interactionValue']));
  }
}

class Learner {
  Learner({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.personalImage,
  });

  late String id;
  late String firstName;
  late String lastName;
  late String personalImage;

  Learner.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    personalImage = json['personalImage'];
  }
}
