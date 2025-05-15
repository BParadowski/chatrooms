import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/api_client/api_client.dart';
import 'package:frontend/features/auth/bloc/auth_bloc.dart';
import 'package:frontend/features/auth/bloc/auth_event.dart';
import 'package:frontend/features/auth/presentation/login_screen.dart';
import 'package:frontend/features/auth/repository/auth_repository.dart';

void main() {
  final authRepository = AuthRepository();
  final authBloc = AuthBloc(authRepository);

  ApiClient.instance.connectToAuth(
    getToken: authRepository.getToken,
    onUnauthenticatedError: () {
      authBloc.add(AuthLogoutInitiated());
    },
  );

  runApp(
    RepositoryProvider(
      create: (context) => authRepository,
      child: BlocProvider<AuthBloc>(
        create: (context) => authBloc,
        child: const MaterialApp(title: 'Auth testing', home: LoginPage()),
      ),
    ),
  );
}
