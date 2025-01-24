// lib\features\sign_up_auth\data\repositories\mock_sign_up_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/sign_up_repository.dart';

class MockSignUpRepository implements SignUpRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  Future<Either<Failure, String>> signUpUser(SignUpParams params) async {
    try {
      // Create the user with Firebase Authentication
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: params.email,
        password: params.password,
      );

      // Save user data in Firestore
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'firstName': params.firstName,
        'lastName': params.lastName,
        'email': params.email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return Right('Sign-up successful');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return Left(ValidationFailure(message: 'Email is already in use.'));
      } else if (e.code == 'invalid-email') {
        return Left(ValidationFailure(message: 'Invalid email address.'));
      } else if (e.code == 'weak-password') {
        return Left(ValidationFailure(message: 'Password is too weak.'));
      }
      return Left(NetworkFailure(message: e.message ?? 'Firebase Auth error.'));
    } on FirebaseException catch (e) {
      return Left(
          DatabaseFailure(message: 'Failed to save user data: ${e.message}'));
    } catch (e) {
      return Left(UnknownFailure(message: 'An unknown error occurred.'));
    }
  }
}
