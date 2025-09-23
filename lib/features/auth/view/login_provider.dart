import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_boilerplate/features/auth/bloc/auth_bloc.dart';
import 'package:new_boilerplate/features/auth/view/login_page.dart';

class LoginProvider extends StatefulWidget {
  const LoginProvider({super.key});

  @override
  State<LoginProvider> createState() => _LoginProviderState();
}

class _LoginProviderState extends State<LoginProvider> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: const LoginPage(),
    );
  }
}
