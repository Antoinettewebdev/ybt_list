import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/data/firestore_serialization.dart';
import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.categoryId,
    required super.sellerId,
    super.images,
    super.stock,
    super.isActive,
    super.createdAt,
    super.updatedAt,
  });

  factory ProductModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return ProductModel(
      id: doc.id,
      name: data['name'] as String? ?? '',
      description: data['description'] as String? ?? '',
      price: FirestoreSerialization.parseMoney(
        Map<String, dynamic>.from(data['price'] ?? {}),
      ),
      categoryId: data['categoryId'] as String? ?? '',
      sellerId: data['sellerId'] as String? ?? '',
      images: List<String>.from(data['images'] ?? []),
      stock: data['stock'] as int? ?? 0,
      isActive: data['isActive'] as bool? ?? true,
      createdAt: FirestoreSerialization.parseDate(data['createdAt']),
      updatedAt: FirestoreSerialization.parseDate(data['updatedAt']),
    );
  }

  Map<String, dynamic> toMap({bool isCreate = false}) {
    final map = <String, dynamic>{
      'name': name,
      'description': description,
      'price': FirestoreSerialization.moneyToMap(price),
      'categoryId': categoryId,
      'sellerId': sellerId,
      'images': images,
      'stock': stock,
      'isActive': isActive,
    };
    if (!isCreate && createdAt != null) {
      map['createdAt'] = Timestamp.fromDate(createdAt!);
    }
    return map;
  }
}
