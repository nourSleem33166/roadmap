import 'dart:convert';

List<CommentInteraction> interactionsFromJson(String str) => List<CommentInteraction>.from(
    json.decode(str).map((x) => CommentInteraction.fromJson(x)));

class CommentInteraction {
  CommentInteraction({required this.type, required this.count});

  int count;
  String type;

  factory CommentInteraction.fromJson(Map<String, dynamic> json) =>
      CommentInteraction(type: json["type"], count: json["count"]);
}
