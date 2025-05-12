import 'package:frontend/core/api_client/dio_client.dart';
import 'package:frontend/core/secure_storage.dart';
import 'package:frontend/features/auth/repository/auth_credentials.dart';

import 'auth_login_result.dart';

class AuthRepository {
  AuthRepository();

  Future<String?> getToken() async {
    final token = await secureStorage.read(key: "token");
    return token;
  }

  Future<AuthLoginResult> logIn(AuthCredentials credentials) async {
    final res = await dio.post("/session", data: credentials.toMap());

    await secureStorage.write(key: "token", value: res.data["token"] as String);
    return AuthLoginResult.successful;
  }
}
