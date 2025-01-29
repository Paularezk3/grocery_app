// lib\features\sign_up_auth\data\repositories\mock_sign_up_repository.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
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
      // Step 1: Create the user
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: params.email,
        password: params.password,
      );

      // Step 2: Update the display name
      await userCredential.user
          ?.updateDisplayName("${params.firstName} ${params.lastName}");

      // Step 3: Get the Firebase Messaging token
      String? fcmToken = await FirebaseMessaging.instance.getToken();

      // Step 4: Save user data in Firestore
      final userDocRef =
          _firestore.collection('users').doc(userCredential.user?.uid);
      await userDocRef.set({
        'firstName': params.firstName,
        'lastName': params.lastName,
        'email': params.email,
        'createdAt': FieldValue.serverTimestamp(),
        'fcmToken': fcmToken,
      });

      // Step 5: Add two notifications (one read and one unread)
      final notificationsCollection = userDocRef.collection('notifications');

      // Notification 1: Read
      await notificationsCollection.add({
        'title': 'Welcome to the App!',
        'body': 'Thank you for signing up. We hope you enjoy using our app.',
        'type': 'welcome',
        'isRead': true,
        'time': FieldValue.serverTimestamp(),
      });

      // Notification 2: Unread
      await notificationsCollection.add({
        'title': 'Get Started',
        'body': 'Complete your profile to get the most out of the app.',
        'type': 'tip',
        'isRead': false,
        'time': FieldValue.serverTimestamp(),
      });

      // Step 6: Log user out to prevent auto-login after sign-up
      await _firebaseAuth.signOut();

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
