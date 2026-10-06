/// Auth Provider - Riverpod State Management
///
/// Sprint 1: SCRUM-867 (Firebase Auth & Session Management)
/// Manages authentication state using Riverpod.

import 'package:flutter_riverpod/flutter_riverpod';
import 'package:warranty_shield/domain/entities/user_entity.dart';
import 'package:warranty_shield/domain/repositories/auth_repository.dart';
import 'package:warranty_shield/data/api_client.dart';
import 'package:warranty_shield/data/auth_repository_impl.dart';

/// Auth state for the application
enum AuthState {
  loading,
  authenticated,
  unauthenticated,
}

/// Auth state class holding user data and loading/error state
class AuthStateData {
  final AuthState state;
  final UserEntity? user;
  final String? error;

  const AuthStateData({
    required this.state,
    this.user,
    this.error,
  });

  factory AuthStateData.loading() =>
      const AuthStateData(state: AuthState.loading);

  factory AuthStateData.authenticated(UserEntity user) =>
      AuthStateData(state: AuthState.authenticated, user: user);

  factory AuthStateData.unauthenticated() =>
      const AuthStateData(state: AuthState.unauthenticated);

  factory AuthStateData.error(String error) =>
      AuthStateData(state: AuthState.unauthenticated, error: error);

  /// Helper methods for when() pattern
  R when<R>({
    required R Function() loading,
    required R Function(UserEntity user) authenticated,
    required R Function() unauthenticated,
    required R Function(String error, Object? stackTrace) error,
  }) {
    switch (state) {
      case AuthState.loading:
        return loading();
      case AuthState.authenticated:
        return authenticated(user!);
      case AuthState.unauthenticated:
        if (error != null) {
          return error(error, StackTrace.current);
        }
        return unauthenticated();
    }
  }
}

/// Auth Provider - Root provider for authentication state
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: 'http://localhost:8080/api');
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRepositoryImpl(apiClient);
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthStateData>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthNotifier(repository);
});

/// Auth StateNotifier - Manages authentication state
class AuthNotifier extends StateNotifier<AuthStateData> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AuthStateData(state: AuthState.loading)) {
    _initialize();
  }

  /// Initialize auth state on app start
  Future<void> _initialize() async {
    state = AuthStateData.loading();
    try {
      final user = await _repository.getCurrentUser();
      if (user != null) {
        state = AuthStateData.authenticated(user);
      } else {
        state = AuthStateData.unauthenticated();
      }
    } catch (e) {
      state = AuthStateData.unauthenticated();
    }
  }

  /// Authenticate with email and password
  Future<void> login({
    required String email,
    required String password,
  }) async {
    state = AuthStateData.loading();
    try {
      final user = await _repository.authenticate(
        email: email,
        password: password,
      );
      state = AuthStateData.authenticated(user);
    } catch (e) {
      state = AuthStateData.error(e.toString());
    }
  }

  /// Sign in with Google
  Future<void> signInWithGoogle() async {
    state = AuthStateData.loading();
    try {
      final user = await _repository.signInWithGoogle();
      state = AuthStateData.authenticated(user);
    } catch (e) {
      state = AuthStateData.error(e.toString());
    }
  }

  /// Sign out current user
  Future<void> logout() async {
    await _repository.signOut();
    state = AuthStateData.unauthenticated();
  }
}