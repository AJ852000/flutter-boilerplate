import 'package:flutter/material.dart';
import 'package:new_boilerplate/features/auth/view/login_provider.dart';
import 'core/serviceLocator.dart';

void main() {
  setupLocator(isTest: false); // Production repo
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Auth App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginProvider(),
    );
  }
}
