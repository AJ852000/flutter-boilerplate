import 'auth_repository.dart';

class MockAuthRepository extends AuthRepository {
  @override
  Future<String> login(String username, String password) async {
    return "Welcome $username (mock repo)";
  }
}
