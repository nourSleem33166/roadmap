import 'dart:convert';

List<Department> deptsFromJson(String str) =>
    List<Department>.from(json.decode(str).map((x) => Department.fromJson(x)));

class Department {
  Department({
    required this.id,
    required this.name,
    required this.description,
  });

  String id;
  String name;
  String description;

  factory Department.fromJson(Map<String, dynamic> json) => Department(
        id: json["_id"],
        name: json["name"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "description": description,
      };
}
