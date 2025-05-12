import 'package:bloc/bloc.dart';
import 'package:frontend/features/auth/repository/auth_credentials.dart';
import 'package:frontend/features/auth/bloc/auth_event.dart';
import 'package:frontend/features/auth/bloc/auth_state.dart';
import 'package:frontend/features/auth/repository/auth_login_result.dart';
import 'package:frontend/features/auth/repository/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<AuthLoginInitiated>((event, emit) async {
      emit(AuthLoading());
      final credentials = event.credentials;

      final AuthLoginResult result = await authRepository.logIn(credentials);

      if (result == AuthLoginResult.successful) {
        // getToken and set headers in dio.
        final token = await authRepository.getToken();
        print(token);
        emit(Authenticated());
      }
    });
  }
}
