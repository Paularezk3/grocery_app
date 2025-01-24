// lib\features\sign_up_auth\domain\usecases\sign_up_user.dart

import 'package:dartz/dartz.dart';
import '../repositories/sign_up_repository.dart';
import '../entities/user_entity.dart';
import '../../../../core/errors/failures.dart';

class SignUpUser {
  final SignUpRepository repository;

  SignUpUser(this.repository);

  Future<Either<Failure, String>> call(SignUpParams params) {
    return repository.signUpUser(params);
  }
}
