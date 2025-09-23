import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_boilerplate/features/auth/repositories/auth_repository.dart';
import 'package:new_boilerplate/core/serviceLocator.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repo = sl<AuthRepository>();

  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final msg = await repo.login(event.username, event.password);
        emit(AuthSuccess(msg));
      } catch (e) {
        emit(AuthFailure("Login failed"));
      }
    });
  }
}
