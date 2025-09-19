part of 'flowTestBloc.dart';

@immutable
sealed class FlowTestState {}

final class FlowTestInitial extends FlowTestState {}

final class FlowTestLoading extends FlowTestState {}

final class FlowTestLoaded extends FlowTestState {
  final FlowTestModel model;
  FlowTestLoaded(this.model);
}

final class FlowTestError extends FlowTestState {
  final String message;
  final String message2;
  FlowTestError(this.message, this.message2);
}
