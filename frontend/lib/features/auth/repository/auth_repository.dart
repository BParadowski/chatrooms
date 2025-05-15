import 'package:dio/dio.dart';
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

  Future<AuthLoginResult> logIn(AuthCredentials credentials) async {
    try {
      final res = await api.post("/session", data: credentials.toMap());
      await secureStorage.write(
        key: "auth_token",
        value: res.data["token"] as String,
      );
      return AuthLoginResult.successful;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.receiveTimeout) {
        return AuthLoginResult.serverError;
      } else if (error.response == null) {
        return AuthLoginResult.networkError;
      } else {
        return switch (error.response!.statusCode) {
          null => AuthLoginResult.serverError,
          422 => AuthLoginResult.invalidCredentials,
          >= 500 && <= 600 => AuthLoginResult.serverError,
          _ => AuthLoginResult.networkError,
        };
      }
    }
  }

  Future<void> logOut() async {
    await _eraseToken();
  }

  Future<void> _eraseToken() async {
    _token = null;
    await secureStorage.delete(key: "auth_token");
  }
}
