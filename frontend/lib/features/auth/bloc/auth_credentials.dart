sealed class AuthCredentials {}

class EmailAuthCredentials extends AuthCredentials {
  final String email;
  final String password;

  EmailAuthCredentials({required this.email, required this.password});
}

class OAuthCredentials extends AuthCredentials {
  final String provider;
  final String idToken;

  OAuthCredentials({required this.provider, required this.idToken});
}
