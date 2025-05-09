import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/auth/bloc/auth_bloc.dart';
import 'package:frontend/features/auth/presentation/login_screen.dart';
import 'package:frontend/features/auth/repository/auth_repository.dart';

void main() {
  runApp(
    RepositoryProvider(
      create: (context) => AuthRepository(),
      child: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(context.read<AuthRepository>()),
        child: const MaterialApp(title: 'Auth testing', home: LoginPage()),
      ),
    ),
  );
}
