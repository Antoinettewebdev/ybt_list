import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/data/firestore_serialization.dart';
import '../../domain/entities/order_entity.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    required super.id,
    required super.userId,
    required super.items,
    required super.totalAmount,
    super.status,
    super.shippingAddress,
    super.createdAt,
    super.updatedAt,
  });

  factory OrderModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    final rawItems = data['items'] as List<dynamic>? ?? [];
    return OrderModel(
      id: doc.id,
      userId: data['userId'] as String? ?? '',
      items: rawItems
          .map((e) => OrderItemModel.fromMap(Map<String, dynamic>.from(e)))
          .toList(),
      totalAmount: FirestoreSerialization.parseMoney(
        Map<String, dynamic>.from(data['totalAmount'] ?? {}),
      ),
      status: FirestoreSerialization.enumFromString(
        OrderStatus.values,
        data['status'] as String?,
        OrderStatus.pending,
      ),
      shippingAddress: data['shippingAddress'] as String?,
      createdAt: FirestoreSerialization.parseDate(data['createdAt']),
      updatedAt: FirestoreSerialization.parseDate(data['updatedAt']),
    );
  }

  Map<String, dynamic> toMap({bool isCreate = false}) {
    final map = <String, dynamic>{
      'userId': userId,
      'items': items.map((e) => OrderItemModel.fromEntity(e).toMap()).toList(),
      'totalAmount': FirestoreSerialization.moneyToMap(totalAmount),
      'status': FirestoreSerialization.enumToString(status),
      'shippingAddress': shippingAddress,
    };
    if (!isCreate && createdAt != null) {
      map['createdAt'] = Timestamp.fromDate(createdAt!);
    }
    return map;
  }
}

class OrderItemModel extends OrderItemEntity {
  const OrderItemModel({
    required super.productId,
    required super.productName,
    required super.quantity,
    required super.unitPrice,
  });

  factory OrderItemModel.fromEntity(OrderItemEntity entity) => OrderItemModel(
        productId: entity.productId,
        productName: entity.productName,
        quantity: entity.quantity,
        unitPrice: entity.unitPrice,
      );

  factory OrderItemModel.fromMap(Map<String, dynamic> data) => OrderItemModel(
        productId: data['productId'] as String? ?? '',
        productName: data['productName'] as String? ?? '',
        quantity: data['quantity'] as int? ?? 1,
        unitPrice: FirestoreSerialization.parseMoney(
          Map<String, dynamic>.from(data['unitPrice'] ?? {}),
        ),
      );

  Map<String, dynamic> toMap() => {
        'productId': productId,
        'productName': productName,
        'quantity': quantity,
        'unitPrice': FirestoreSerialization.moneyToMap(unitPrice),
      };
}
