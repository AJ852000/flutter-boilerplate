part of 'flowTestBloc.dart';

@immutable
sealed class FlowTestState {}

// this bloc uses for managing states related to flow test data fetching and handling.
final class FlowTestInitial extends FlowTestState {}

final class FlowTestLoading extends FlowTestState {}

final class FlowTestLoaded extends FlowTestState {
  final FlowTestModel model;
  FlowTestLoaded(this.model);
}

final class FlowTestError extends FlowTestState {
  final String message;
  FlowTestError(this.message);
}

// this bloc uses for managing states related to flow test data fetching and handling.
