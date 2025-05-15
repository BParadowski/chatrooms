import 'package:bloc/bloc.dart';
import 'package:frontend/features/auth/bloc/auth_event.dart';
import 'package:frontend/features/auth/bloc/auth_state.dart';
import 'package:frontend/features/auth/repository/auth_login_result.dart';
import 'package:frontend/features/auth/repository/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<AuthLoginInitiated>(_onLoginInitiated);
    on<AuthLogoutInitiated>(_onLogoutInitiated);
    on<AuthCheckRequested>(_onAuthCheckRequested);

    // Check the presence of token on app startup and log in if it is present.
    add(AuthCheckRequested());
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final token = await authRepository.getToken();
    if (token == null) {
      emit(Unauthenticated());
    } else {
      emit(Authenticated());
    }
  }

  Future<void> _onLoginInitiated(
    AuthLoginInitiated event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final credentials = event.credentials;
    final AuthLoginResult result = await authRepository.logIn(credentials);

    switch (result) {
      case AuthLoginResult.successful:
        emit(Authenticated());
      case AuthLoginResult.invalidCredentials:
        emit(AuthError("Invalid credentials provided."));
      case AuthLoginResult.serverError:
        emit(
          AuthError("The server returned an error, please try again later."),
        );
      case AuthLoginResult.networkError:
        emit(
          AuthError(
            "Cannot initiate log in process. Please check your internet connection.",
          ),
        );
    }
  }

  Future<void> _onLogoutInitiated(
    AuthLogoutInitiated event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    await authRepository.logOut();

    emit(Unauthenticated());
  }
}
