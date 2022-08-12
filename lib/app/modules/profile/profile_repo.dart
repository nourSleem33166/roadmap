import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:roadmap/app/shared/models/pagination_model.dart';
import 'package:roadmap/app/shared/models/roadmap.dart';

import '../../shared/exceptions/app_exception_handler.dart';
import '../../shared/models/company.dart';

class ProfileRepo {
  Dio _dio;

  ProfileRepo(this._dio);

  Future<PaginationModel<RoadmapModel>> getRoadmaps(int page, int pageSize) async {
    final result = await _dio
        .get("explore/roadmaps", queryParameters: {'page': page, 'pageSize': pageSize});

    return PaginationModel.fromJson(result.data, roadmapsModelFromJson);
  }

  Future<PaginationModel<RoadmapModel>> searchRoamaps(
      String? text, int page, int pageSize) async {
    try {
      log("text is $text");
      final result = await _dio.get("learner/search/roadmaps",
          queryParameters: {'page': page, 'pageSize': pageSize, 'text': text});
      return PaginationModel.fromJson(result.data, roadmapsModelFromJson);
    } catch (e) {
      throw AppExceptionHandler.instance.handleError(e);
    }
  }

  Future<PaginationModel<CompanyModel>> getCompanies(int page, int pageSize) async {
    try {
      final result = await _dio
          .get("explore/companies", queryParameters: {'page': page, 'pageSize': pageSize});
      return PaginationModel.fromJson(result.data, companiesModelFromJson);
    } catch (e) {
      throw AppExceptionHandler.instance.handleError(e);
    }
  }

  Future<PaginationModel<CompanyModel>> searchCompaines(
      String? text, int page, int pageSize) async {
    try {
      final result = await _dio.get("learner/search/companies",
          queryParameters: {'page': page, 'pageSize': pageSize, 'text': text});
      return PaginationModel.fromJson(result.data, companiesModelFromJson);
    } catch (e) {
      print("error is ${e.toString()}");
      throw AppExceptionHandler.instance.handleError(e);
    }
  }
}
