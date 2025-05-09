import 'package:frontend/features/auth/bloc/auth_credentials.dart';

sealed class AuthEvent {}

class AppStarted extends AuthEvent {}

class AuthLoginInitiated extends AuthEvent {
  final AuthCredentials credentials;

  AuthLoginInitiated(this.credentials);
}

class AuthLogoutInitiated extends AuthEvent {}
