import 'package:dio/dio.dart';

class RequestHeadersInterceptors extends Interceptor {

  @override
  Future onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    /* inject your options in header (token ,.. etc) */
    super.onRequest(options, handler);
  }

  @override
  Future onError(DioError dioError, ErrorInterceptorHandler handler) async {
    /* handle already known errors (401, 403, ...etc) */
    super.onError(dioError, handler);
  }

  @override
  Future onResponse(Response response, ResponseInterceptorHandler handler) async {
    super.onResponse(response, handler);
  }
}