import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:roadmap/app/shared/models/user.dart';
import 'package:roadmap/app/shared/models/work_domain.dart';
import 'package:roadmap/app/shared/services/storage_service.dart';

import '../../shared/exceptions/app_exception_handler.dart';

class AuthRepo {
  Dio _dio;

  AuthRepo(this._dio);

  Future<List<WorkDomain>> getDomains() async {
    try {
      final result = await _dio.get("work-domains");
      return workDomainFromJson(json.encode(result.data));
    } catch (e) {
      print("e is $e");
      throw AppExceptionHandler.instance.handleError(e);
    }
  }

  Future<bool> signup(Map<String, dynamic> data) async {
    try {
      final map = {...data};
      map['workDomain'] = map['workDomain'].toJson();
      final result = await _dio.post("auth/learner/local/signup", data: map);
      final user = userFromJson(json.encode(result.data));
      await SharedPreferencesHelper.setUser(user);
      return true;
    } catch (e) {
      print("e is $e");
      throw AppExceptionHandler.instance.handleError(e);
    }
  }

  Future<bool> login(Map<String, dynamic> data) async {

      final result = await _dio.post("auth/learner/local/signin", data: data);
      final user = userFromJson(json.encode(result.data));
      await SharedPreferencesHelper.setUser(user);
      return true;

  }
}
