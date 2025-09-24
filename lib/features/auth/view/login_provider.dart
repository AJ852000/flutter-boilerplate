import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_boilerplate/features/auth/bloc/auth_bloc.dart';
import 'package:new_boilerplate/features/auth/view/login_page.dart';

class LoginProvider extends StatefulWidget {
  final AuthBloc authBloc;
  const LoginProvider({super.key, required this.authBloc});

  @override
  State<LoginProvider> createState() => _LoginProviderState();
}

class _LoginProviderState extends State<LoginProvider> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => widget.authBloc,
      child: const LoginPage(),
    );
  }
}
