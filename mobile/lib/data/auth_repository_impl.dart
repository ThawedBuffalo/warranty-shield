/// Auth Repository Implementation
///
/// Sprint 1: SCRUM-867 (Firebase Auth & Session Management)
/// Concrete implementation using Firebase Auth + backend JWT.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:warranty_shield/domain/entities/user_entity.dart';
import 'package:warranty_shield/domain/repositories/auth_repository.dart';
import 'package:warranty_shield/data/api_client.dart';
import 'package:device_info_plus/device_info_plus.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiClient apiClient;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  DeviceInfoPlugin? _deviceInfo;

  AuthRepositoryImpl(this.apiClient);

  DeviceInfoPlugin get _deviceInfoPlugin =>
      _deviceInfo ??= DeviceInfoPlugin();

  @override
  Future<UserEntity> authenticate({
    required String email,
    required String password,
  }) async {
    // Sign in with Firebase (email/password)
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = userCredential.user;
    if (user == null) {
      throw Exception('Authentication failed');
    }

    // Get device token for push notifications
    final deviceToken = await _getDeviceToken();

    // Exchange Firebase credentials for backend JWT
    final backendData = await apiClient.authenticate(
      firebaseUid: user.uid,
      email: user.email ?? '',
      deviceToken: deviceToken,
    );

    return UserEntity(
      id: backendData['userId'] as String? ?? user.uid,
      email: backendData['email'] as String,
      firebaseUid: user.uid,
      deviceToken: deviceToken,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<UserEntity> signInWithGoogle() async {
    // Trigger Google sign-in flow
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception('Google sign-in cancelled');
    }

    // Obtain auth details from Google
    final googleAuth = await googleUser.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;

    if (accessToken == null || idToken == null) {
      throw Exception('Google auth failed');
    }

    // Sign in to Firebase with Google credentials
    final credential = GoogleAuthProvider.credential(
      accessToken: accessToken,
      idToken: idToken,
    );

    final userCredential = await _firebaseAuth.signInWithCredential(credential);
    final user = userCredential.user;
    if (user == null) {
      throw Exception('Google sign-in failed');
    }

    // Get device token for push notifications
    final deviceToken = await _getDeviceToken();

    // Exchange Firebase credentials for backend JWT
    final backendData = await apiClient.authenticate(
      firebaseUid: user.uid,
      email: user.email ?? '',
      deviceToken: deviceToken,
    );

    return UserEntity(
      id: backendData['userId'] as String? ?? user.uid,
      email: backendData['email'] as String,
      firebaseUid: user.uid,
      deviceToken: deviceToken,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<UserEntity> signInWithApple() async {
    // Apple Sign-In (iOS only)
    // TODO: Implement with apple_sign_in package
    throw UnimplementedError('Apple Sign-In not yet implemented');
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    await _googleSignIn.signOut();
    apiClient.clearToken();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) return null;

    return UserEntity(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      firebaseUid: firebaseUser.uid,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  /// Get the device push notification token
  Future<String?> _getDeviceToken() async {
    // TODO: Implement with Firebase Messaging for push notifications
    // This is a placeholder for Sprint 1 MVP
    return null;
  }
}