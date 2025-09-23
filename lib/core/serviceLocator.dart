import 'package:get_it/get_it.dart';
import 'package:new_boilerplate/features/auth/repositories/auth_repository.dart';
import 'package:new_boilerplate/features/auth/repositories/mock_auth_repository.dart';

final sl = GetIt.instance;

void setupLocator({bool isTest = false}) {
  // Clear previous registrations
  if (sl.isRegistered<AuthRepository>()) {
    sl.unregister<AuthRepository>();
  }

  if (isTest) {
    // Register fake repo for testing
    sl.registerSingleton<AuthRepository>(MockAuthRepository());
  } else {
    // Register real repo for production
    sl.registerSingleton<AuthRepository>(AuthRepository());
  }
}
