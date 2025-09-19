import 'dart:developer';

import 'package:dio/dio.dart';

class NetworkInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log('--> ${options.method} ${options.uri}');
    log('Headers: ${options.headers}');
    log('Body: ${options.data}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('<-- ${response.statusCode} ${response.requestOptions.uri}');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log('<-- Error ${err.response?.statusCode} ${err.message}');
    super.onError(err, handler);
  }
}

final dio = Dio()
  ..options.baseUrl = 'https://example.com/api'
  ..interceptors.add(NetworkInterceptor());
