import 'package:get_it/get_it.dart';
import 'globalKeyValues.dart';
import 'package:new_boilerplate/modules/flow_test/repository/flowTestRepository.dart';
import 'package:new_boilerplate/modules/flow_test/bloc/flowTestBloc.dart';

final GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  serviceLocator
      .registerLazySingleton<GlobalKeyValues>(() => GlobalKeyValues());
  serviceLocator
      .registerLazySingleton<FlowTestRepository>(() => FlowTestRepository());
  serviceLocator.registerFactory<FlowTestBloc>(() => FlowTestBloc());
}
