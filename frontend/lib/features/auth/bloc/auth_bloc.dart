import 'package:bloc/bloc.dart';
import 'package:frontend/features/auth/bloc/auth_credentials.dart';
import 'package:frontend/features/auth/bloc/auth_events.dart';
import 'package:frontend/features/auth/bloc/auth_state.dart';
import 'package:frontend/features/auth/repository/auth_login_result.dart';
import 'package:frontend/features/auth/repository/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<AuthLoginInitiated>((event, emit) async {
      final credentials = event.credentials;
      switch (credentials) {
        case EmailAuthCredentials():
          final AuthLoginResult result = await authRepository.logInWithEmail(
            credentials.email,
            credentials.password,
          );
          if (result == AuthLoginResult.successful) {
            // getToken and set headers in dio.
            final token = authRepository.getToken();
            print(token);
            emit(Authenticated());
          }
          break;

        case OAuthCredentials():
          emit(AuthError("Oauth not implemented yet"));
      }
    });
  }
}
