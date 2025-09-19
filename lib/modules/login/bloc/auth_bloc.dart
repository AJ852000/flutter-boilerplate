import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_boilerplate/modules/login/repository/auth_repository.dart';
import 'package:new_boilerplate/utils/core/serviceLocator.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc({AuthRepository? repository})
      : repository = repository ?? getIt<AuthRepository>(),
        super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final token = await this.repository.login(
              email: event.email,
              password: event.password,
            );
        emit(AuthSuccess(token));
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });
  }
}
