// lib\features\login_auth\data\repositories\firebase_login_repository.dart

import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/config/setup_dependencies.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/utils/analytics_service.dart';
import '../../domain/entities/login_params.dart';
import '../../domain/repositories/login_repository.dart';

class MockFirebaseLoginRepository implements LoginRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<Either<Failure, void>> loginUser(LoginParams params) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: params.email,
        password: params.password,
      );

      getIt<AnalyticsService>()
          .logUserSignIn(userId: _firebaseAuth.currentUser!.uid);
      return const Right(null);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return Left(ValidationFailure(message: 'User not found.'));
      } else if (e.code == 'wrong-password') {
        return Left(ValidationFailure(message: 'Incorrect password.'));
      } else {
        return Left(NetworkFailure(message: e.message ?? 'Login failed.'));
      }
    } catch (e) {
      return Left(UnknownFailure(message: 'An unknown error occurred.'));
    }
  }
}
