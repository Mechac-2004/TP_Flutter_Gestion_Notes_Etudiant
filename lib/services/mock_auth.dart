class MockAuth {
  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    return email == "test@example.com" && password == "password";
  }

  Future<bool> register(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2));
    return true; // Simule une inscription réussie
  }
}