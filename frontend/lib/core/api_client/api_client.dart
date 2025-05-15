import 'package:dio/dio.dart';
import 'package:frontend/core/constants.dart';

final api = ApiClient.instance.dio;

class ApiClient {
  ApiClient._internal();
  static final _instance = ApiClient._internal();
  static ApiClient get instance => _instance;

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: backendUrl,
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 3),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  void configure({
    required Future<String?> Function() getToken,
    required Future<void> Function() eraseToken,
    required void Function() onUnauthenticated,
  }) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final String? authToken = await getToken();
          if (authToken == null) {
            handler.next(options);
          } else {
            options.headers['Authorization'] = 'Bearer $authToken';
            handler.next(options);
          }
        },

        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            await eraseToken();
            // Redirect the user to the login screen
            onUnauthenticated();
          }
          handler.next(error);
        },
      ),
    );
  }
}
