/// Use Case: Authenticate User
///
/// Sprint 1: SCRUM-867 (Firebase Auth & Session Management)

import 'package:warranty_shield/domain/entities/user_entity.dart';
import 'package:warranty_shield/domain/repositories/auth_repository.dart';

class AuthenticateUseCase {
  final AuthRepository repository;

  AuthenticateUseCase(this.repository);

  Future<UserEntity> call({
    required String email,
    required String password,
  }) {
    return repository.authenticate(email: email, password: password);
  }
}