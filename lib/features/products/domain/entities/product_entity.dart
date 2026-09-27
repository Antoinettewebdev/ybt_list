import 'package:equatable/equatable.dart';

import '../../../../core/utils/money.dart';

class ProductEntity extends Equatable {
  const ProductEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.sellerId,
    this.images = const [],
    this.stock = 0,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String description;
  final Money price;
  final String categoryId;
  final String sellerId;
  final List<String> images;
  final int stock;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        categoryId,
        sellerId,
        images,
        stock,
        isActive,
        createdAt,
        updatedAt,
      ];
}
