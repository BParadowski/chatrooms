import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/auth/bloc/auth_bloc.dart';
import 'package:frontend/features/auth/bloc/auth_event.dart';
import 'package:frontend/features/auth/presentation/sign_in_with_google/sign_in_button/button.dart';
import 'package:frontend/features/auth/repository/auth_credentials.dart';
import 'package:google_sign_in/google_sign_in.dart';

const List<String> scopes = <String>['email'];

final GoogleSignIn _googleSignIn = GoogleSignIn(
  clientId:
      '991691263110-3nt4o45nokgkq5lh9d1rp5j0dbn63ov1.apps.googleusercontent.com',
  scopes: scopes,
);

class SignInWithGoogleButton extends StatefulWidget {
  const SignInWithGoogleButton({super.key});

  @override
  State<SignInWithGoogleButton> createState() => _SignInWithGoogleButtonState();
}

class _SignInWithGoogleButtonState extends State<SignInWithGoogleButton> {
  @override
  void initState() {
    super.initState();

    _googleSignIn.onCurrentUserChanged.listen((
      GoogleSignInAccount? account,
    ) async {
      if (account == null) return;

      // TODO: what is the deal with this authorization?

      // bool isAuthorized = true;
      // if (kIsWeb) {
      //   isAuthorized = await _googleSignIn.canAccessScopes(scopes);

      // }

      // if (!isAuthorized) return;

      final auth = await account.authentication;
      final idToken = auth.idToken;

      if (idToken == null || !mounted) return;

      context.read<AuthBloc>().add(
        AuthLoginInitiated(
          OAuthCredentials(provider: 'google', idToken: idToken),
        ),
      );
    });
  }

  /// Mobile only method for handling the sign in. On the web it is handled by the google sdk with logic in the button itself.
  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      debugPrint('Google sign-in error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildSignInButton(onPressed: _handleSignIn);
  }
}
