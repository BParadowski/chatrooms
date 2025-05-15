import 'package:frontend/core/api_client/api_client.dart';
import 'package:frontend/core/secure_storage.dart';
import 'package:frontend/features/auth/repository/auth_credentials.dart';

import 'auth_login_result.dart';

class AuthRepository {
  AuthRepository();
  String? _token;

  Future<String?> getToken() async {
    if (_token != null) return _token;

    final storageToken = await secureStorage.read(key: "auth_token");
    _token = storageToken;
    return _token;
  }

  Future<void> eraseToken() async {
    _token = null;
    await secureStorage.delete(key: "auth_token");
  }

  Future<AuthLoginResult> logIn(AuthCredentials credentials) async {
    final res = await api.post("/session", data: credentials.toMap());

    await secureStorage.write(
      key: "auth_token",
      value: res.data["token"] as String,
    );
    return AuthLoginResult.successful;
  }

  Future<void> logOut() async {
    await eraseToken();
  }
}
