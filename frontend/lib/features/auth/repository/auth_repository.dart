import 'package:frontend/core/secure_storage.dart';

import 'auth_login_result.dart';

class AuthRepository {
  AuthRepository();

  Future<String?> getToken() async {
    final token = await secureStorage.read(key: "token");
    return token;
  }

  Future<AuthLoginResult> logInWithEmail(String email, String password) async {
    // Make a request to the server
  }
}
