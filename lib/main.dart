import 'package:flutter/material.dart';
import 'package:new_boilerplate/features/auth/bloc/auth_bloc.dart';
import 'package:new_boilerplate/features/auth/repositories/auth_repository.dart';
import 'package:new_boilerplate/features/auth/view/login_provider.dart';
import 'core/serviceLocator.dart';

void main({bool useMock = false}) {
  setupLocator(isTest: useMock);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter boilerplate',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginProvider(authBloc: AuthBloc(repo: sl<AuthRepository>())),
    );
  }
}
