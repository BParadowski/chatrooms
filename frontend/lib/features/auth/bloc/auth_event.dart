import 'package:frontend/features/auth/repository/auth_credentials.dart';

sealed class AuthEvent {}

class AuthCheckRequested extends AuthEvent {}

class AuthLoginInitiated extends AuthEvent {
  final AuthCredentials credentials;

  AuthLoginInitiated(this.credentials);
}

class AuthLogoutInitiated extends AuthEvent {}
