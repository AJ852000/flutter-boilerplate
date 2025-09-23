import 'package:get_it/get_it.dart';
import 'package:new_boilerplate/features/auth/repositories/auth_repository.dart';
import 'package:new_boilerplate/features/auth/repositories/mock_auth_repository.dart';

final getIt = GetIt.instance;

void setupLocator({bool isTest = false}) {
  getIt.reset(); // clear previous registrations

  if (isTest) {
    // Register fake repo for testing
    getIt.registerLazySingleton<AuthRepository>(() => MockAuthRepository());
  } else {
    // Register real repo for production
    getIt.registerLazySingleton<AuthRepository>(() => AuthRepository());
  }
}
