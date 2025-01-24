// lib\features\login_auth\presentation\bloc\login_auth_event.dart

abstract class LoginAuthEvent {}

class LoginClicked extends LoginAuthEvent {
  final String email;
  final String password;

  LoginClicked({required this.email, required this.password});
}
