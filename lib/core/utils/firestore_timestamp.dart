import 'package:cloud_firestore/cloud_firestore.dart';

/// Helpers for Firestore [Timestamp] serialization.
abstract final class FirestoreTimestamp {
  static Timestamp now() => Timestamp.now();

  static Timestamp? fromDate(DateTime? date) =>
      date != null ? Timestamp.fromDate(date) : null;

  static DateTime? toDate(Timestamp? timestamp) => timestamp?.toDate();

  static Map<String, dynamic> withServerTimestamps({
    required bool isCreate,
    Map<String, dynamic>? data,
  }) {
    final map = Map<String, dynamic>.from(data ?? {});
    if (isCreate) {
      map['createdAt'] = FieldValue.serverTimestamp();
    }
    map['updatedAt'] = FieldValue.serverTimestamp();
    return map;
  }
}
