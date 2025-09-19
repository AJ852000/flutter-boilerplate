import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_boilerplate/modules/login/bloc/auth_bloc.dart';
import 'package:new_boilerplate/modules/login/ui/login_page.dart';
import 'utils/core/serviceLocator.dart';

void main() {
  setupDI();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (_) => AuthBloc(),
        child: const LoginPage(),
      ),
    );
  }
}
