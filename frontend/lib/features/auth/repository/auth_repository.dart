import 'package:frontend/core/api_client/dio_client.dart';
import 'package:frontend/core/secure_storage.dart';

import 'auth_login_result.dart';

class AuthRepository {
  AuthRepository();

  Future<String?> getToken() async {
    final token = await secureStorage.read(key: "token");
    return token;
  }

  Future<AuthLoginResult> logInWithEmail(String email, String password) async {
    final res = await dio.post(
      "/session",
      data: {"email": email, "password": password},
    );
    print(res);

    await secureStorage.write(key: "token", value: res.data["token"] as String);
    return AuthLoginResult.successful;
  }
}
