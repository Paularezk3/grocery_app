// lib\features\sign_up_auth\domain\entities\successful_sign_up_entity.dart

class SuccessfulSignUpEntity {
  final String message;
  final String firstName;
  final String lastName;

  SuccessfulSignUpEntity(
      {required this.firstName, required this.lastName, required this.message});
}
