class AuthRepository {
  // Simulates an API call for login
  Future<String> login(String username, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return "Welcome $username (real repo)";
  }
}
