import 'package:equatable/equatable.dart';

import '../../../../core/utils/money.dart';

class PaymentEntity extends Equatable {
  const PaymentEntity({
    required this.id,
    required this.orderId,
    required this.userId,
    required this.amount,
    this.method = PaymentMethod.mobileMoney,
    this.status = PaymentStatus.pending,
    this.transactionRef,
    this.createdAt,
    this.updatedAt,
  });

  final String id;
  final String orderId;
  final String userId;
  final Money amount;
  final PaymentMethod method;
  final PaymentStatus status;
  final String? transactionRef;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  @override
  List<Object?> get props => [
        id,
        orderId,
        userId,
        amount,
        method,
        status,
        transactionRef,
        createdAt,
        updatedAt,
      ];
}

enum PaymentMethod { mobileMoney, card, bankTransfer, cash }

enum PaymentStatus { pending, completed, failed, refunded }
