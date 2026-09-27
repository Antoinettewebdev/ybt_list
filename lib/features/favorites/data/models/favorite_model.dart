import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/data/firestore_serialization.dart';
import '../../domain/entities/favorite_entity.dart';

class FavoriteModel extends FavoriteEntity {
  const FavoriteModel({
    required super.id,
    required super.userId,
    required super.productId,
    super.createdAt,
  });

  factory FavoriteModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    return FavoriteModel(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      productId: data['productId'] as String? ?? '',
      createdAt: FirestoreSerialization.parseDate(data['createdAt']),
    );
  }

  Map<String, dynamic> toMap({bool isCreate = false}) => {
        'userId': userId,
        'productId': productId,
      };
}
