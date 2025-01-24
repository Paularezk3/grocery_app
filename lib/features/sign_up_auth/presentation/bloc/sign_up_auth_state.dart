import 'package:grocery_app/features/sign_up_auth/domain/entities/successful_sign_up_entity.dart';

abstract class SignUpAuthState {}

class SignUpIdleState extends SignUpAuthState {}

class SignUpPageLoadingState extends SignUpAuthState {}

class SignUpSuccessState extends SignUpAuthState {
  final SuccessfulSignUpEntity message;
  SignUpSuccessState(this.message);
}

class SignUpErrorState extends SignUpAuthState {
  final String error;

  SignUpErrorState(this.error);
}
