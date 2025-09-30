import 'package:flutter/material.dart';
import 'package:new_boilerplate/deeplink.dart';
import 'package:new_boilerplate/features/auth/bloc/auth_bloc.dart';
import 'package:new_boilerplate/features/auth/repositories/auth_repository.dart';
import 'package:new_boilerplate/features/auth/view/login_provider.dart';
import 'core/serviceLocator.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(MaterialApp.router(routerConfig: router));
  setupLocator();
}

/// This handles '/' and '/details'.
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => LoginProvider(
        authBloc: AuthBloc(repo: sl<AuthRepository>()),
      ),
      routes: [
        GoRoute(path: 'details', builder: (_, __) => DeppLinkTest()),
      ],
    ),
  ],
);
