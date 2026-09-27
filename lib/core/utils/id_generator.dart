import 'package:cloud_firestore/cloud_firestore.dart';

/// Generates Firestore document IDs (collections created on first write).
abstract final class IdGenerator {
  static String newId([FirebaseFirestore? firestore]) =>
      (firestore ?? FirebaseFirestore.instance).collection('_ids').doc().id;
}
