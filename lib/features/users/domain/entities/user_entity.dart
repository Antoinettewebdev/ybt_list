import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  const UserEntity({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.phone,
    this.role = UserRole.customer,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String? phone;
  final UserRole role;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  @override
  List<Object?> get props =>
      [id, email, displayName, photoUrl, phone, role, isActive, createdAt, updatedAt];
}

enum UserRole { customer, seller, admin }
