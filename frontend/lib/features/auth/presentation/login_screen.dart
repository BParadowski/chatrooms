import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/auth/bloc/auth_bloc.dart';
import 'package:frontend/features/auth/presentation/sign_in_with_google/sign_in.dart';
import 'package:frontend/features/auth/repository/auth_credentials.dart';
import 'package:frontend/features/auth/bloc/auth_event.dart';
import 'package:frontend/features/auth/bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void _onLoginPressed() {
    final email = emailController.text;
    final password = passwordController.text;

    context.read<AuthBloc>().add(
      AuthLoginInitiated(
        EmailAuthCredentials(email: email, password: password),
      ),
    );
  }

  void _onLogoutPressed() {
    context.read<AuthBloc>().add(AuthLogoutInitiated());
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Logged in!')));
          } else if (state is AuthError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is Authenticated) {
            return Center(
              child: Column(
                children: [
                  Text("Congrats, you're in! "),
                  ElevatedButton(
                    onPressed: _onLogoutPressed,
                    child: Text("Log out"),
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Password'),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _onLoginPressed,
                  child: Text('Login'),
                ),
                SizedBox(height: 16),
                if (state is AuthError)
                  Text(
                    state.message,
                    style: TextStyle(color: Colors.redAccent),
                  ),
                SignInWithGoogleButton(),
              ],
            ),
          );
        },
      ),
    );
  }
}
