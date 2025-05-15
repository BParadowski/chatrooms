import 'package:flutter/material.dart';
import 'package:google_sign_in_web/google_sign_in_web.dart';
import 'package:google_sign_in_web/web_only.dart' as web;

import 'stub.dart';

/// Renders a button for the web which handles the login process via google sign in JavaScript sdk.
Widget buildSignInButton({HandleSignInFn? onPressed}) {
  return web.renderButton(
    configuration: web.GSIButtonConfiguration(
      type: GSIButtonType.icon,
      size: GSIButtonSize.large,
    ),
  );
}
