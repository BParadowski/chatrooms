import 'package:dio/dio.dart';
import 'package:frontend/core/constants.dart';

class DioClient {
  DioClient._internal();
  static final DioClient _instance = DioClient._internal();
  static get instance => _instance;
  static String? token;

  static final dio = Dio(
    BaseOptions(baseUrl: backendUrl, connectTimeout: Duration(seconds: 5)),
  );

  static setToken(String newToken) {
    token = newToken;
    dio.options.headers;
  }
}
