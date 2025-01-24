// lib\features\sign_up_auth\data\models\sign_up_request.dart

class SignUpRequest {
  final String firstName;
  final String lastName;
  final String email;

  SignUpRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
    };
  }
}
