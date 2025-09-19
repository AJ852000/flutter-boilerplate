import 'package:dio/dio.dart';

abstract class AuthRepository {
  Future<String> login({required String email, required String password});
}

class AuthRepositoryImpl implements AuthRepository {
  final Dio dioClient;
  AuthRepositoryImpl({Dio? dio}) : dioClient = dio ?? Dio();

  @override
  Future<String> login(
      {required String email, required String password}) async {
    try {
      final response = await dioClient.post('/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200 && response.data['token'] != null) {
        return response.data['token'];
      } else {
        throw Exception(response.data['message'] ?? 'Login failed');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data['message'] ?? 'Server Error');
      } else {
        throw Exception('Network Error: ${e.message}');
      }
    }
  }
}
