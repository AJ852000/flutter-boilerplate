import 'package:dio/dio.dart';
import 'dioInterceptor.dart';

class ApiClient {
  final Dio _dio;

  ApiClient([Dio? dio]) : _dio = dio ?? Dio() {
    AppInterceptors.addInterceptors(_dio);
  }

  Future<Response> get(String url,
      {Map<String, dynamic>? queryParameters, Options? options}) async {
    return await _dio.get(url,
        queryParameters: queryParameters, options: options);
  }

  Future<Response> post(String url,
      {dynamic data,
      Map<String, dynamic>? queryParameters,
      Options? options}) async {
    return await _dio.post(url,
        data: data, queryParameters: queryParameters, options: options);
  }

  Future<Response> put(String url,
      {dynamic data,
      Map<String, dynamic>? queryParameters,
      Options? options}) async {
    return await _dio.put(url,
        data: data, queryParameters: queryParameters, options: options);
  }
}
