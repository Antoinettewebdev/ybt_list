import 'package:equatable/equatable.dart';

import '../../../../core/utils/money.dart';

class OrderEntity extends Equatable {
  const OrderEntity({
    required this.id,
    required this.userId,
    required this.items,
    required this.totalAmount,
    this.status = OrderStatus.pending,
    this.shippingAddress,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String userId;
  final List<OrderItemEntity> items;
  final Money totalAmount;
  final OrderStatus status;
  final String? shippingAddress;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  @override
  List<Object?> get props =>
      [id, userId, items, totalAmount, status, shippingAddress, createdAt, updatedAt];
}

class OrderItemEntity extends Equatable {
  const OrderItemEntity({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
  });

  final String productId;
  final String productName;
  final int quantity;
  final Money unitPrice;

  Money get lineTotal => Money(
        amountInPesewas: unitPrice.amountInPesewas * quantity,
      );

  @override
  List<Object?> get props => [productId, productName, quantity, unitPrice];
}

enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled,
}
