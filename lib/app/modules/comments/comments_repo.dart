import 'dart:io';

import 'package:dio/dio.dart';
import 'package:roadmap/app/shared/models/comment_model.dart';
import 'package:roadmap/app/shared/models/interaction.dart';
import 'package:roadmap/app/shared/models/pagination_model.dart';
import 'package:roadmap/app/shared/services/storage_service.dart';

import '../../shared/exceptions/app_exception.dart';

class CommentsRepo {
  String _route;
  Dio _dio;

  CommentsRepo(this._dio, this._route);

  Future<PaginationModel<Comment>> getComments(
      int page, int pageSize, String refId) async {
    final result = await _dio.get("$_route/$refId/comments",
        queryParameters: {'page': page, 'pageSize': pageSize, 'refId': refId});

    return PaginationModel.fromJson(result.data, commentsFromJson);
  }

  Future<PaginationModel<Comment>> getReplies(
      int page, int pageSize, String refId, String commentId) async {
    final result = await _dio.get("$_route/$refId/comments/$commentId/replies",
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
          'refId': refId,
          'commentId': commentId
        });

    return PaginationModel.fromJson(result.data, commentsFromJson);
  }

  Future<Comment> addComment(String text, String refId, {File? file}) async {
    final result = await _dio.post("$_route/$refId/comments",
        data: FormData.fromMap({
          'text': text,
          'attachment': await MultipartFile.fromFile(file!.path)
        }),
        queryParameters: {'refId': refId});
    final user = await SharedPreferencesHelper.getUser();
    if (result.statusCode == 200) return Comment.fromJson(result.data, user!);
    throw AppException.unknown();
  }

  Future<bool> addReply(String text, String refId, String commentId,
      {File? file}) async {
    final result =
        await _dio.post("$_route/$refId/comments/$commentId/replies", data: {
      'text': text,
      // if (file != null) 'attachment': await MultipartFile.fromFile(file.path)
    });
    if (result.statusCode == 201)
      return true;
    else
      return false;
  }

  Future<bool> updateComment(String text, String refId, String commentId,
      {File? file}) async {
    final result =
        await _dio.patch("$_route/$refId/comments/$commentId", data: {
      'text': text,
      if (file != null) 'attachment': await MultipartFile.fromFile(file.path)
    });
    if (result.statusCode == 200)
      return true;
    else
      return false;
  }

  Future<bool> deleteComment(String refId, String commentId) async {
    final result = await _dio.delete("$_route/$refId/comments/$commentId");
    if (result.statusCode == 200)
      return true;
    else
      return false;
  }

  Future<bool> makeInteraction(
      String refId, String commentId, String type) async {
    final result = await _dio.post(
        "$_route/$refId/comments/$commentId/interactions",data: {},
        queryParameters: {
          'commentId': commentId,
          'refId': refId,
          'type': type
        });
    if (result.statusCode == 201)
      return true;
    else
      return false;
  }

  Future<List<Interaction>> getInteractions(
    String refId,
    String commentId,
  ) async {
    final result = await _dio.get(
        "$_route/$refId/comments/$commentId/interactions",
        queryParameters: {'commentId': commentId});
    if (result.statusCode == 200)
      return interactionsFromJson(result.data);
    else
      return [];
  }
}
