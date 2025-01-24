// lib\features\sign_up_auth\presentation\bloc\sign_up_auth_bloc.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grocery_app/features/sign_up_auth/domain/entities/successful_sign_up_entity.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/sign_up_user.dart';
import 'sign_up_auth_event.dart';
import 'sign_up_auth_state.dart';

class SignUpAuthBloc extends Bloc<SignUpAuthEvent, SignUpAuthState> {
  final SignUpUser signUpUser;

  SignUpAuthBloc({required this.signUpUser}) : super(SignUpIdleState()) {
    on<SignUpButtonClickedEvent>(_onSignUpButtonClickedEvent);
  }

  Future<void> _onSignUpButtonClickedEvent(
      SignUpButtonClickedEvent event, Emitter<SignUpAuthState> emitter) async {
    emitter(SignUpPageLoadingState());

    final punctuatedFirstName = _capitalizeWords(event.firstName);
    final punctuatedLastName = _capitalizeWords(event.lastName);

    final result = await signUpUser(SignUpParams(
      firstName: punctuatedFirstName,
      lastName: punctuatedLastName,
      email: event.email,
      password: event.password,
    ));

    result.fold(
      (failure) {
        if (failure is ValidationFailure) {
          emitter(SignUpErrorState('Validation Error: ${failure.message}'));
        } else if (failure is NetworkFailure) {
          emitter(SignUpErrorState('Network Error: ${failure.message}'));
        } else if (failure is DatabaseFailure) {
          emitter(SignUpErrorState('Database Error: ${failure.message}'));
        } else {
          emitter(SignUpErrorState('Unexpected Error: ${failure.message}'));
        }
      },
      (message) {
        emitter(SignUpSuccessState(SuccessfulSignUpEntity(
          firstName: punctuatedFirstName,
          lastName: punctuatedLastName,
          message: message,
        )));
      },
    );
  }

  String _capitalizeWords(String input) {
    return input
        .split(' ')
        .map((word) => word.isNotEmpty
            ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
            : word)
        .join(' ');
  }
}
