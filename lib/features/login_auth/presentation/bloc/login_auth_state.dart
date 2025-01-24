abstract class LoginAuthState {}

class LoginPageIdleState extends LoginAuthState {}

class LoginPageLoadingState extends LoginAuthState {}

class LoginSuccessState extends LoginAuthState {}

class LoginErrorState extends LoginAuthState {
  final String error;
  LoginErrorState({required this.error});
}
