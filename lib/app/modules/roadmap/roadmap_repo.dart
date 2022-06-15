import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:roadmap/app/shared/models/roadmap.dart';
import 'package:roadmap/app/shared/models/roadmap_node.dart';

import '../../shared/exceptions/app_exception_handler.dart';

class RoadmapRepo {
  Dio _dio;

  RoadmapRepo(this._dio);

  Future<RoadmapModel?> getRoadmapById(String id) async {
    try {
      final result =
          await _dio.get("explore/roadmaps/$id", queryParameters: {'id': id});
      return RoadmapModel.fromJson(result.data);
    } catch (e) {
      throw AppExceptionHandler.instance.handleError(e);
    }
  }

  Future<List<RoadmapNode>> getRoadmapNodes(String id) async {
    try {
      final result = await _dio
          .get("explore/roadmaps/$id/nodes", queryParameters: {'id': id});
      return roadmapNodeFromJson(jsonEncode(result.data));
    } catch (e) {
      throw AppExceptionHandler.instance.handleError(e);

    }
  }
}
