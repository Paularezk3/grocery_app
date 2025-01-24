// lib\features\sign_up_auth\domain\repositories\sign_up_repository.dart

import '../entities/user_entity.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';

abstract class SignUpRepository {
  Future<Either<Failure, String>> signUpUser(SignUpParams params);
}
