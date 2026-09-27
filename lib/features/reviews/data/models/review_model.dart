import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/data/firestore_serialization.dart';
import '../../domain/entities/review_entity.dart';

class ReviewModel extends ReviewEntity {
  const ReviewModel({
    required super.id,
    required super.productId,
    required super.userId,
    required super.rating,
    super.comment,
    super.createdAt,
    super.updatedAt,
  });

  factory ReviewModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return ReviewModel(
      id: doc.id,
      productId: data['productId'] as String? ?? '',
      userId: data['userId'] as String? ?? '',
      rating: (data['rating'] as num?)?.toDouble() ?? 0,
      comment: data['comment'] as String?,
      createdAt: FirestoreSerialization.parseDate(data['createdAt']),
      updatedAt: FirestoreSerialization.parseDate(data['updatedAt']),
    );
  }

  Map<String, dynamic> toMap({bool isCreate = false}) {
    final map = <String, dynamic>{
      'productId': productId,
      'userId': userId,
      'rating': rating,
      'comment': comment,
    };
    if (!isCreate && createdAt != null) {
      map['createdAt'] = Timestamp.fromDate(createdAt!);
    }
    return map;
  }
}
