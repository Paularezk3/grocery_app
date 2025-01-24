abstract class LoginAuthEvent {}

class LoginClicked extends LoginAuthEvent {
  final String email;
  final String password;
  LoginClicked({required this.email, required this.password});
}
