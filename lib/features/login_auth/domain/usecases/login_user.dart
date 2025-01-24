// lib\features\login_auth\domain\usecases\login_user.dart

import 'package:dartz/dartz.dart';
import '../entities/login_params.dart';
import '../repositories/login_repository.dart';
import '../../../../core/errors/failures.dart';

class LoginUser {
  final LoginRepository repository;

  LoginUser(this.repository);

  Future<Either<Failure, void>> call(LoginParams params) {
    return repository.loginUser(params);
  }
}
