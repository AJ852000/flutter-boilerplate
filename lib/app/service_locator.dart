import 'package:get_it/get_it.dart';
import 'package:new_boilerplate/data/repositories/auth_repository.dart';

final sl = GetIt.instance;

// Setup method for production or test environment
void setupLocator({bool isTest = false}) {
  sl.registerLazySingleton<AuthRepository>(() => AuthRepository());
}
