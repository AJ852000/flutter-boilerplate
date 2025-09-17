import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../model/flowTestModel.dart';
import '../repository/flowTestRepository.dart';

part 'flowTestEvent.dart';
part 'flowTestState.dart';

class FlowTestBloc extends Bloc<FlowTestEvent, FlowTestState> {
  final FlowTestRepository _repository = FlowTestRepository();

  FlowTestBloc() : super(FlowTestInitial()) {
    on<GetFlowTestDataEvent>(_onGetFlowTestData);
  }

  Future<void> _onGetFlowTestData(
      GetFlowTestDataEvent event, Emitter<FlowTestState> emit) async {
    emit(FlowTestLoading());
    try {
      final response = await _repository.getflowTestData();
      if (response != null && response.data != null) {
        final model = FlowTestModel.fromJson(response.data);
        emit(FlowTestLoaded(model));
      } else {
        emit(FlowTestError('No data received'));
      }
    } catch (e) {
      emit(FlowTestError(e.toString()));
    }
  }
}
