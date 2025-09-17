import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/flowTestBloc.dart';
import 'flowTest.dart';

class FlowTestProvider extends StatelessWidget {
  const FlowTestProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FlowTestBloc(),
      child: const FlowTestScreen(),
    );
  }
}
