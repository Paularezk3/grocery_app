// lib\features\login_auth\domain\repositories\login_repository.dart

import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/login_params.dart';

abstract class LoginRepository {
  Future<Either<Failure, void>> loginUser(LoginParams params);
}
