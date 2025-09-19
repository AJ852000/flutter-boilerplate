import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:new_boilerplate/modules/login/repository/auth_repository.dart';
import 'package:new_boilerplate/utils/core/dioInterceptor.dart';

final getIt = GetIt.instance;

void setupDI() {
  getIt.registerLazySingleton<Dio>(() => dio);
  getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(dio: getIt<Dio>()));
}
