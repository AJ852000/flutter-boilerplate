import 'dart:developer';
import 'package:dio/dio.dart';

class AppInterceptors extends Interceptor {
  static void addInterceptors(Dio dio) {
    dio.interceptors.add(AppInterceptors());
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Add headers (e.g., auth token)
    options.headers['Content-Type'] = 'application/json';
    // Example: Add Bearer token if available
    // options.headers['Authorization'] = 'Bearer YOUR_TOKEN';

    log('📤 [REQUEST] ${options.method} => ${options.uri}');
    log('Headers: ${options.headers}');
    log('Body: ${options.data}');

    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('✅ [RESPONSE] [${response.statusCode}] => ${response.requestOptions.uri}');
    log('Response Data: ${response.data}');

    // Example: Handle common response formats
    if (response.data is Map && response.data['status'] == 'error') {
      return handler.reject(
        DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
          error: response.data['message'] ?? 'Unknown API error',
        ),
      );
    }

    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log('❌ [ERROR] [${err.response?.statusCode}] => ${err.requestOptions.uri}');
    log('Message: ${err.message}');

    String errorMessage = 'Something went wrong';

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
        errorMessage = "Connection timeout. Please try again.";
        break;
      case DioExceptionType.sendTimeout:
        errorMessage = "Send timeout. Please try again.";
        break;
      case DioExceptionType.receiveTimeout:
        errorMessage = "Receive timeout. Please try again.";
        break;
      case DioExceptionType.badResponse:
        errorMessage = _handleStatusCode(err.response?.statusCode);
        break;
      case DioExceptionType.cancel:
        errorMessage = "Request cancelled.";
        break;
      case DioExceptionType.unknown:
      default:
        errorMessage = "Unexpected error. Check your connection.";
        break;
    }

    // You can propagate custom error object for UI handling
    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: errorMessage,
      ),
    );
  }

  String _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return "Bad request. Please check your input.";
      case 401:
        return "Unauthorized. Please login again.";
      case 403:
        return "Forbidden. You don’t have permission.";
      case 404:
        return "Not found. The resource doesn’t exist.";
      case 500:
        return "Server error. Please try later.";
      default:
        return "Unexpected error [Code: $statusCode]";
    }
  }
}
