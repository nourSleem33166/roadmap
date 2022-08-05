import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:roadmap/app/shared/services/storage_service.dart';

class RequestHeadersInterceptors extends Interceptor {
  Dio _dio;

  RequestHeadersInterceptors(this._dio);

  @override
  Future onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final user = await SharedPreferencesHelper.getUser();
    if (user != null) {
      log("access token is ${user.accessToken}");
      options.headers.addAll({
        "Access-Control-Allow-Origin": "*",
        "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE, HEAD",
        'Authorization': 'Bearer ${user.accessToken}'
      });
    }
    super.onRequest(options, handler);
  }

  @override
  Future onError(DioError dioError, ErrorInterceptorHandler handler) async {
    if (dioError.response?.statusCode == 401) {
      final tokenRefreshed = await refreshToken();
      if (!tokenRefreshed) return;
      final cloneRequest = await _dio.request(dioError.requestOptions.path,
          data: dioError.requestOptions.data,
          queryParameters: dioError.requestOptions.queryParameters);
      return handler.resolve(cloneRequest);
    }
    super.onError(dioError, handler);
  }

  @override
  Future onResponse(Response response, ResponseInterceptorHandler handler) async {
    super.onResponse(response, handler);
  }

  Future<bool> refreshToken() async {
    try {
      final storageUser = await SharedPreferencesHelper.getUser();
      if (storageUser != null) {
        final dio = Dio();
        dio.options = BaseOptions(headers: {
          "Access-Control-Allow-Origin": "*",
          "Access-Control-Allow-Methods": "POST, GET, OPTIONS, PUT, DELETE, HEAD",
          'Authorization': 'Bearer ${storageUser.refreshToken}'
        });

        final res =
            await dio.post('https://roadmap-be.herokuapp.com/auth/learner/refresh', data: {});
        if (res.statusCode == 200) {
          storageUser.refreshToken = res.data['refreshToken'];
          storageUser.accessToken = res.data['accessToken'];
          await SharedPreferencesHelper.setUser(storageUser);
          return true;
        } else {
          Modular.to.pushReplacementNamed('/auth/');
          return false;
        }
      }
      return false;
    } catch (e) {
      Modular.to.pushReplacementNamed('/auth/');
      await SharedPreferencesHelper.deleteUser();
      return false;
    }
  }
}
