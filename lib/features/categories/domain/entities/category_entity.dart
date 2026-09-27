import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  const CategoryEntity({
    required this.id,
    required this.name,
    required this.slug,
    this.imageUrl,
    this.parentId,
    this.sortOrder = 0,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String name;
  final String slug;
  final String? imageUrl;
  final String? parentId;
  final int sortOrder;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [
        id,
        name,
        slug,
        imageUrl,
        parentId,
        sortOrder,
        isActive,
        createdAt,
        updatedAt,
      ];
}
