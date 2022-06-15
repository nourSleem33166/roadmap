import 'dart:convert';

class PaginationModel<T> {
  int totalItems;
  int currentPage;
  int totalPages;
  List<T> items;

  PaginationModel(
      {required this.currentPage,
      required this.items,
      required this.totalItems,
      required this.totalPages});

  factory PaginationModel.fromJson(
      Map<String, dynamic> json, List<T> itemsResolver(String str)) {
    return PaginationModel(
      items: itemsResolver(jsonEncode(json["items"])) ,
      currentPage: json["currentPage"] == null ? null : json["currentPage"],
      totalPages: json["totalPages"] == null
          ? null
          : json["totalPages"] == 0
              ? 1
              : json["totalPages"],
      totalItems: json["totalItems"] == null ? null : json["totalItems"],
    );
  }
}
