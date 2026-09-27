import 'package:equatable/equatable.dart';

class ReviewEntity extends Equatable {
  const ReviewEntity({
    required this.id,
    required this.productId,
    required this.userId,
    required this.rating,
    this.comment,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String productId;
  final String userId;
  final double rating;
  final String? comment;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  @override
  List<Object?> get props =>
      [id, productId, userId, rating, comment, createdAt, updatedAt];
}
