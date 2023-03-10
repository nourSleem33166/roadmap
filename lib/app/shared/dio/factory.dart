import 'package:dio/dio.dart';

import 'requests_interceptor.dart';

class DioFactory {
  /* add project's baseUrl & apiUrl */
  static const baseURL = 'https://roadmap-be.onrender.com';
  static const apiUrl = '$baseURL/';

  static Dio create() {
    final baseOptions = BaseOptions(baseUrl: apiUrl);
    final dio = Dio(baseOptions);
    dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true, request: true));
    dio.interceptors.add(RequestHeadersInterceptors(dio));
    return dio;
  }
}
