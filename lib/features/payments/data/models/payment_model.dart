import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/data/firestore_serialization.dart';
import '../../domain/entities/payment_entity.dart';

class PaymentModel extends PaymentEntity {
  const PaymentModel({
    required super.id,
    required super.orderId,
    required super.userId,
    required super.amount,
    super.method,
    super.status,
    super.transactionRef,
    super.createdAt,
    super.updatedAt,
  });

  factory PaymentModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};
    return PaymentModel(
      id: doc.id,
      orderId: data['orderId'] as String? ?? '',
      userId: data['userId'] as String? ?? '',
      amount: FirestoreSerialization.parseMoney(
        Map<String, dynamic>.from(data['amount'] ?? {}),
      ),
      method: FirestoreSerialization.enumFromString(
        PaymentMethod.values,
        data['method'] as String?,
        PaymentMethod.mobileMoney,
      ),
      status: FirestoreSerialization.enumFromString(
        PaymentStatus.values,
        data['status'] as String?,
        PaymentStatus.pending,
      ),
      transactionRef: data['transactionRef'] as String?,
      createdAt: FirestoreSerialization.parseDate(data['createdAt']),
      updatedAt: FirestoreSerialization.parseDate(data['updatedAt']),
    );
  }

  Map<String, dynamic> toMap({bool isCreate = false}) {
    final map = <String, dynamic>{
      'orderId': orderId,
      'userId': userId,
      'amount': FirestoreSerialization.moneyToMap(amount),
      'method': FirestoreSerialization.enumToString(method),
      'status': FirestoreSerialization.enumToString(status),
      'transactionRef': transactionRef,
    };
    if (!isCreate && createdAt != null) {
      map['createdAt'] = Timestamp.fromDate(createdAt!);
    }
    return map;
  }
}
