import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:roadmap/app/shared/exceptions/app_exception.dart';
import 'package:roadmap/app/shared/models/exam.dart';
import 'package:roadmap/app/shared/models/roadmap.dart';
import 'package:roadmap/app/shared/models/roadmap_node.dart';

import '../../shared/exceptions/app_exception_handler.dart';

class RoadmapRepo {
  Dio _dio;

  RoadmapRepo(this._dio);

  Future<RoadmapModel?> getRoadmapById(String id) async {
    try {
      final result = await _dio.get("explore/roadmaps/$id", queryParameters: {'id': id});
      return RoadmapModel.fromJson(result.data);
    } catch (e) {
      throw AppExceptionHandler.instance.handleError(e);
    }
  }

  Future<bool?> startLearnRoadmap(String id) async {
    try {
      final result =
          await _dio.post("/learn/$id", queryParameters: {'roadmapId': id}, data: {});
      return true;
    } catch (e) {
      throw AppExceptionHandler.instance.handleError(e);
    }
  }

  Future<List<RoadmapNode>> getRoadmapNodes(String id) async {
    try {
      final result =
          await _dio.get("explore/roadmaps/$id/nodes", queryParameters: {'id': id});
      return roadmapNodeFromJson(jsonEncode(result.data));
    } catch (e) {
      throw AppExceptionHandler.instance.handleError(e);
    }
  }

  Future<List<RoadmapNode>> getLearningNodes(String id) async {
    try {
      final result = await _dio.get("/learn/$id", queryParameters: {'roadmapId': id});
      return roadmapNodeFromJson(jsonEncode(result.data));
    } catch (e) {
      throw AppExceptionHandler.instance.handleError(e);
    }
  }

  Future<Exam> startExam(
      String roadmapId, String nodeId, List<String> optionalNodesIds) async {
    final result = await _dio.post("/learn/$roadmapId/exam/$nodeId",
        data: {'optionalNodesIds': optionalNodesIds.map((e) => e).toList()});
    if (result.statusCode == 201) return examFromJson(jsonEncode(result.data));
    throw AppException.unknown();
  }

  Future<Map<String, dynamic>> submitExamLevel(
      String roadmapId, String examId, String levelId, List<Question> questions) async {
    final result = await _dio.patch("/learn/$roadmapId/exams/$examId/levels/$levelId",
        data: List<dynamic>.from(questions.map((x) => x.toJson())));
    if (result.statusCode == 200) return result.data;
    throw AppException.unknown();
  }

  Future<ExamClass?> getActiveExam() async {
    final result = await _dio.get("/learn/activeExam");
    if (result.statusCode == 200) {
      if (result.data != null) return ExamClass.fromJson(result.data);
    }
  }

  Future<String?> getCertificate(String roadmapId) async {
    final result = await _dio.get("/learn/$roadmapId/cert");
    if (result.statusCode == 200) {
      if (result.data != null) return result.data['certificateUrl'] ?? null;
    }
  }
}
