import 'dart:convert';

import 'package:dio/dio.dart';

import '../../shared/exceptions/app_exception_handler.dart';
import '../../shared/models/company.dart';
import '../../shared/models/department.dart';

class ProfileRepo {
  Dio _dio;

  ProfileRepo(this._dio);

  Future<List<CompanyModel>> getFollowedCompanies() async {
    try {
      final result = await _dio.get("learner/profile/followedCompanies");
      return companiesModelFromJson(jsonEncode(result.data));
    } catch (e) {
      throw AppExceptionHandler.instance.handleError(e);
    }
  }

  Future<List<CompanyModel>> getFavoriteCompanies() async {
    try {
      final result = await _dio.get("learner/profile/favouriteCompanies");
      return companiesModelFromJson(jsonEncode(result.data));
    } catch (e) {
      throw AppExceptionHandler.instance.handleError(e);
    }
  }

  Future<List<Department>> getFollowedDepts(String companyId) async {
    try {
      final result = await _dio
          .get("/learner/profile/followedDepts", queryParameters: {'companyId': companyId});
      return deptsFromJson(jsonEncode(result.data));
    } catch (e) {
      throw AppExceptionHandler.instance.handleError(e);
    }
  }
}
