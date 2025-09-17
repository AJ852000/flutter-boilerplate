import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_boilerplate/modules/flow_test/bloc/flowTestBloc.dart';
import '../model/flowTestModel.dart';

class FlowTestScreen extends StatelessWidget {
  const FlowTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flow Test')),
      body: BlocBuilder<FlowTestBloc, FlowTestState>(
        builder: (context, state) {
          if (state is FlowTestLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is FlowTestLoaded) {
            final FlowTestModel model = state.model;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Status: ${model.status ?? "-"}'),
                  Text('Message: ${model.message ?? "-"}'),
                  if (model.data?.user != null) ...[
                    Text('User ID: ${model.data!.user!.id ?? "-"}'),
                    Text('Name: ${model.data!.user!.name ?? "-"}'),
                    Text('Email: ${model.data!.user!.email ?? "-"}'),
                  ],
                  Text('Token: ${model.data?.token ?? "-"}'),
                ],
              ),
            );
          } else if (state is FlowTestError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return Center(
            child: ElevatedButton(
              onPressed: () {
                context.read<FlowTestBloc>().add(GetFlowTestDataEvent());
              },
              child: const Text('Get Flow Test Data'),
            ),
          );
        },
      ),
    );
  }
}
