import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/data/firestore_serialization.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    super.displayName,
    super.photoUrl,
    super.phone,
    super.role,
    super.isActive,
    super.createdAt,
    super.updatedAt,
  });

  factory UserModel.fromEntity(UserEntity entity) => UserModel(
        id: entity.id,
        email: entity.email,
        displayName: entity.displayName,
        photoUrl: entity.photoUrl,
        phone: entity.phone,
        role: entity.role,
        isActive: entity.isActive,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
      );

  factory UserModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return UserModel(
      id: doc.id,
      email: data['email'] as String? ?? '',
      displayName: data['displayName'] as String?,
      photoUrl: data['photoUrl'] as String?,
      phone: data['phone'] as String?,
      role: FirestoreSerialization.enumFromString(
        UserRole.values,
        data['role'] as String?,
        UserRole.customer,
      ),
      isActive: data['isActive'] as bool? ?? true,
      createdAt: FirestoreSerialization.parseDate(data['createdAt']),
      updatedAt: FirestoreSerialization.parseDate(data['updatedAt']),
    );
  }

  Map<String, dynamic> toMap({bool isCreate = false}) {
    final map = <String, dynamic>{
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'phone': phone,
      'role': FirestoreSerialization.enumToString(role),
      'isActive': isActive,
    };
    if (!isCreate && createdAt != null) {
      map['createdAt'] = Timestamp.fromDate(createdAt!);
    }
    return map;
  }
}
