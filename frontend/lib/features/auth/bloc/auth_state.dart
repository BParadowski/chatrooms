sealed class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  AuthError(this.message);
}


// Auth needs verification + Auth locked out (too many attempts) needed for prod apps.