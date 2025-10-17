import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_boilerplate/data/repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repo; // Repository is injected for testability

  AuthBloc({required this.repo}) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading()); // Show loading state
      try {
        final msg = await repo.login(event.username, event.password);
        emit(AuthSuccess(msg)); // Emit success if login works
      } catch (_) {
        emit(AuthFailure("Login failed")); // Handle errors
      }
    });
  }
}
