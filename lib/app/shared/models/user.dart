import 'dart:convert';

import 'package:roadmap/app/shared/models/scheduler_model.dart';
import 'package:roadmap/app/shared/models/work_domain.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

String userToJson(User data) => json.encode(data.toJson());

class User {
  User(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.password,
      required this.workDomain,
      required this.contacts,
      required this.bio,
      required this.functionalName,
      required this.v,
      required this.refreshToken,
      required this.accessToken,
      required this.personalImage,
      required this.learnWeek});

  String id;
  String firstName;
  String lastName;
  String email;
  String password;
  WorkDomain workDomain;
  List<dynamic> contacts;
  String bio;
  String functionalName;
  int? v;
  String refreshToken;
  String accessToken;
  String? personalImage;
  LearnWeek learnWeek;

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json["_id"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      email: json["email"],
      password: json["password"],
      workDomain: WorkDomain.fromJson(json["workDomain"]),
      contacts: List<dynamic>.from(json["contacts"].map((x) => x)),
      bio: json["bio"],
      functionalName: json["functionalName"],
      v: json["__v"],
      refreshToken: json["refreshToken"],
      accessToken: json["accessToken"],
      personalImage: json['personalImage'],
      learnWeek: learnWeekFromJson(json['learnWeek']));

  Map<String, dynamic> toJson() => {
        "_id": id,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "password": password,
        "workDomain": workDomain.toJson(),
        "contacts": List<dynamic>.from(contacts.map((x) => x)),
        "bio": bio,
        "functionalName": functionalName,
        "__v": v,
        "refreshToken": refreshToken,
        "accessToken": accessToken,
        "personalImage": personalImage,
        "learnWeek": learnWeek.toJson()
      };

  @override
  String toString() {
    return 'User{id: $id, firstName: $firstName, lastName: $lastName, email: $email, password: $password, workDomain: $workDomain, contacts: $contacts, bio: $bio, functionalName: $functionalName, v: $v, refreshToken: $refreshToken, accessToken: $accessToken}';
  }
}
