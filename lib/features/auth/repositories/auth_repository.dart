class AuthRepository {
  Future<String> login(String username, String password) async {
    // Simulated API call
    await Future.delayed(const Duration(seconds: 1));
    return "Welcome $username (real repo)";
  }
}
