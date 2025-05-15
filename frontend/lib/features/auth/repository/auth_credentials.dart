sealed class AuthCredentials {
  Map<String, String> toMap();
}

class EmailAuthCredentials extends AuthCredentials {
  final String email;
  final String password;

  @override
  toMap() {
    return {'email': email, 'password': password};
  }

  EmailAuthCredentials({required this.email, required this.password});
}

class OAuthCredentials extends AuthCredentials {
  final String provider;
  final String idToken;

  @override
  toMap() {
    return {'provider': provider, 'idToken': idToken};
  }

  OAuthCredentials({required this.provider, required this.idToken});
}
