import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils/firestore_timestamp.dart';
import '../utils/money.dart';

/// Shared Firestore field parsing and writing helpers.
abstract final class FirestoreSerialization {
  static DateTime? parseDate(dynamic value) {
    if (value is Timestamp) return FirestoreTimestamp.toDate(value);
    if (value is DateTime) return value;
    return null;
  }

  static Money parseMoney(Map<String, dynamic> data) {
    final pesewas = data['amountInPesewas'] as int? ?? 0;
    return Money(amountInPesewas: pesewas);
  }

  static Map<String, dynamic> moneyToMap(Money money) => {
        'amountInPesewas': money.amountInPesewas,
        'currency': Money.currencyCode,
      };

  static String enumToString(Object value) =>
      value.toString().split('.').last;

  static T enumFromString<T>(List<T> values, String? raw, T fallback) {
    if (raw == null) return fallback;
    return values.firstWhere(
      (e) => e.toString().split('.').last == raw,
      orElse: () => fallback,
    );
  }
}
