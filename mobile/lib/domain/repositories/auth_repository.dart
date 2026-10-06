/// Auth Repository Interface - Domain Layer
///
/// Sprint 1: SCRUM-867 (User Authentication and Account Management)
/// Defines the contract for authentication operations.

import 'package:warranty_shield/domain/entities/user_entity.dart';

abstract class AuthRepository {
  /// Authenticate with Firebase (email/password or OAuth)
  Future<UserEntity> authenticate({
    required String email,
    required String password,
  });

  /// Sign in with Google OAuth
  Future<UserEntity> signInWithGoogle();

  /// Sign in with Apple OAuth (iOS only)
  Future<UserEntity> signInWithApple();

  /// Sign out current user
  Future<void> signOut();

  /// Get current authenticated user
  Future<UserEntity?> getCurrentUser();

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email);
}