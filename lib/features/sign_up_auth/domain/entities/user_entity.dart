// lib\features\sign_up_auth\domain\entities\user_entity.dart

class SignUpParams {
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  SignUpParams({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });
}
