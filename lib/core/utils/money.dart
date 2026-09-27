import 'package:equatable/equatable.dart';

import '../constants/app_constants.dart';

/// Ghana Cedis (GHS) stored in pesewas (1 GHS = 100 pesewas) to avoid float drift.
class Money extends Equatable {
  const Money({required this.amountInPesewas});

  final int amountInPesewas;

  static const String currencyCode = AppConstants.defaultCurrency;

  double get amountInCedis => amountInPesewas / 100;

  factory Money.fromCedis(double cedis) =>
      Money(amountInPesewas: (cedis * 100).round());

  Money operator +(Money other) =>
      Money(amountInPesewas: amountInPesewas + other.amountInPesewas);

  @override
  List<Object?> get props => [amountInPesewas];
}
