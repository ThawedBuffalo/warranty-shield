/// User Entity - Core domain model for authentication

import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String firebaseUid;
  final String? deviceToken;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.email,
    required this.firebaseUid,
    this.deviceToken,
    required this.createdAt,
  });

  bool get isLoggedIn => firebaseUid.isNotEmpty;

  @override
  List<Object?> get props => [id, email, firebaseUid, deviceToken, createdAt];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'firebaseUid': firebaseUid,
      'deviceToken': deviceToken,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'] as String? ?? '',
      email: json['email'] as String,
      firebaseUid: json['firebaseUid'] as String,
      deviceToken: json['deviceToken'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  UserEntity copyWith({
    String? email,
    String? deviceToken,
  }) {
    return UserEntity(
      id: id,
      email: email ?? this.email,
      firebaseUid: firebaseUid,
      deviceToken: deviceToken ?? this.deviceToken,
      createdAt: createdAt,
    );
  }

  @override
  String toString() => 'UserEntity(id: $id, email: $email)';
}