import 'package:dio/dio.dart';

import '../../shared/exceptions/app_exception_handler.dart';

class FollowProcessRepo {
  Dio _dio;

  FollowProcessRepo(this._dio);

  Future<bool> followCompany(String id) async {
    try {
      await _dio
          .post("explore/companies/$id/follow", queryParameters: {'compId': id}, data: {});
      return true;
    } catch (e) {
      throw AppExceptionHandler.instance.handleError(e);
    }
  }

  Future<bool> unFollowCompany(String id) async {
    try {
      await _dio
          .delete("explore/companies/$id/unfollow", queryParameters: {'compId': id}, data: {});
      return true;
    } catch (e) {
      throw AppExceptionHandler.instance.handleError(e);
    }
  }

  Future<bool> addCompanyToFavs(String id) async {
    try {
      await _dio.post("/explore/companies/$id/addToFavs",
          queryParameters: {'compId': id}, data: {});
      return true;
    } catch (e) {
      throw AppExceptionHandler.instance.handleError(e);
    }
  }

  Future<bool> removeCompanyFromFavs(String id) async {
    try {
      await _dio.patch("/explore/companies/$id/removeFromFavs",
          queryParameters: {'compId': id}, data: {});
      return true;
    } catch (e) {
      throw AppExceptionHandler.instance.handleError(e);
    }
  }

  Future<bool> followDept(String companyId, String deptId) async {
    try {
      await _dio.patch("/explore/companies/$companyId/depts/$deptId/follow",
          queryParameters: {'compId': companyId, 'deptId': deptId}, data: {});
      return true;
    } catch (e) {
      throw AppExceptionHandler.instance.handleError(e);
    }
  }

  Future<bool> unFollowDept(String companyId, String deptId) async {
    try {
      await _dio.delete("/explore/companies/$companyId/depts/$deptId/unfollow",
          queryParameters: {'compId': companyId, 'deptId': deptId}, data: {});
      return true;
    } catch (e) {
      throw AppExceptionHandler.instance.handleError(e);
    }
  }
}
