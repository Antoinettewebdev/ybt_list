import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/data/firestore_serialization.dart';
import '../../domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.slug,
    super.imageUrl,
    super.parentId,
    super.sortOrder,
    super.isActive,
    super.createdAt,
    super.updatedAt,
  });

  factory CategoryModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return CategoryModel(
      id: doc.id,
      name: data['name'] as String? ?? '',
      slug: data['slug'] as String? ?? '',
      imageUrl: data['imageUrl'] as String?,
      parentId: data['parentId'] as String?,
      sortOrder: data['sortOrder'] as int? ?? 0,
      isActive: data['isActive'] as bool? ?? true,
      createdAt: FirestoreSerialization.parseDate(data['createdAt']),
      updatedAt: FirestoreSerialization.parseDate(data['updatedAt']),
    );
  }

  Map<String, dynamic> toMap({bool isCreate = false}) {
    final map = <String, dynamic>{
      'name': name,
      'slug': slug,
      'imageUrl': imageUrl,
      'parentId': parentId,
      'sortOrder': sortOrder,
      'isActive': isActive,
    };
    if (!isCreate && createdAt != null) {
      map['createdAt'] = Timestamp.fromDate(createdAt!);
    }
    return map;
  }
}
