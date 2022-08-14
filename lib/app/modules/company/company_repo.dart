import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:roadmap/app/shared/models/company.dart';
import 'package:roadmap/app/shared/models/department.dart';
import 'package:roadmap/app/shared/models/roadmap.dart';

import '../../shared/exceptions/app_exception_handler.dart';

class CompanyRepo {
  Dio _dio;

  CompanyRepo(this._dio);

  Future<CompanyModel?> getCompanyById(String id) async {
    try {
      final result = await _dio.get("explore/companies/$id", queryParameters: {'id': id});
      return CompanyModel.fromJson(result.data);
    } catch (e) {
      throw AppExceptionHandler.instance.handleError(e);
    }
  }

  Future<List<Department>?> getCompanyDepts(String id) async {
    try {
      final result =
          await _dio.get("explore/companies/$id/depts", queryParameters: {'id': id});
      return deptsFromJson(json.encode(result.data));
    } catch (e) {
      throw AppExceptionHandler.instance.handleError(e);
    }
  }

  Future<Department?> getDeptById(String id, String comapnyId) async {
    try {
      final result = await _dio.get("explore/companies/$comapnyId/depts/$id",
          queryParameters: {'id': comapnyId, 'deptId': id});
      return Department.fromJson(result.data);
    } catch (e) {
      throw AppExceptionHandler.instance.handleError(e);
    }
  }

  Future<List<RoadmapModel>> getDeptRoadmaps(String id, String comapnyId) async {
    try {
      final result = await _dio.get("explore/companies/$comapnyId/depts/$id/roadmaps",
          queryParameters: {'deptId': id});
      return roadmapsModelFromJson(jsonEncode(result.data));
    } catch (e) {
      throw AppExceptionHandler.instance.handleError(e);
    }
  }

  Future<bool> reportCompany(String id, String message) async {
    try {
      final result = await _dio.post("/reports/company",
          data: {'message': message}, queryParameters: {'reportOn': id});
      if (result.statusCode == 201) return true;
      return false;
    } catch (e) {
      throw AppExceptionHandler.instance.handleError(e);
    }
  }
}
