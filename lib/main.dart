import 'package:flutter/material.dart';
import 'package:new_boilerplate/core/utils/app_link.dart';
import 'package:new_boilerplate/deeplink.dart';
import 'package:new_boilerplate/features/auth/bloc/auth_bloc.dart';
import 'package:new_boilerplate/data/repositories/auth_repository.dart';
import 'package:new_boilerplate/features/auth/view/login_provider.dart';
import 'app/service_locator.dart';
import 'package:go_router/go_router.dart';

void main() {
  setupLocator();

  final goRouter = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (_, __) => const DeppLinkTest(),
        routes: [
          GoRoute(
            path: '/deppLink',
            builder: (_, __) => LoginProvider(
              authBloc: AuthBloc(repo: sl<AuthRepository>()),
            ),
          ),
        ],
      ),
    ],
  );

  initAppLinks(goRouter); // <-- Initialize AppLinks

  runApp(MaterialApp.router(routerConfig: goRouter));
}
