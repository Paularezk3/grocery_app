// lib\features\login_auth\presentation\bloc\login_auth_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/login_params.dart';
import '../../domain/usecases/login_user.dart';
import 'login_auth_event.dart';
import 'login_auth_state.dart';

class LoginAuthBloc extends Bloc<LoginAuthEvent, LoginAuthState> {
  final LoginUser loginUser;

  LoginAuthBloc({required this.loginUser}) : super(LoginPageIdleState()) {
    on<LoginClicked>(_onLoginClicked);
  }

  Future<void> _onLoginClicked(
      LoginClicked event, Emitter<LoginAuthState> emit) async {
    emit(LoginPageLoadingState());

    final result = await loginUser(LoginParams(
      email: event.email,
      password: event.password,
    ));

    result.fold(
      (failure) {
        if (failure is ValidationFailure) {
          emit(LoginErrorState(error: 'Validation Error: ${failure.message}'));
        } else if (failure is NetworkFailure) {
          emit(LoginErrorState(error: 'Network Error: ${failure.message}'));
        } else {
          emit(LoginErrorState(error: 'Unexpected Error: ${failure.message}'));
        }
      },
      (_) {
        emit(LoginSuccessState());
      },
    );
  }
}
