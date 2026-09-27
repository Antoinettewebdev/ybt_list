import 'package:equatable/equatable.dart';

class FavoriteEntity extends Equatable {
  const FavoriteEntity({
    required this.id,
    required this.userId,
    required this.productId,
    this.createdAt,
  });

  final String id;
  final String userId;
  final String productId;
  final DateTime? createdAt;

  @override
  List<Object?> get props => [id, userId, productId, createdAt];
}
