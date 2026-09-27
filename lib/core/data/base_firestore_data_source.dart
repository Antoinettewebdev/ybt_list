import 'package:cloud_firestore/cloud_firestore.dart';

import '../errors/exceptions.dart';
import '../utils/firestore_timestamp.dart';

/// Generic CRUD operations for top-level Firestore collections.
abstract class BaseFirestoreDataSource<T> {
  BaseFirestoreDataSource(this._firestore);

  final FirebaseFirestore _firestore;

  String get collectionPath;

  /// Exposed for feature-specific queries in subclasses.
  CollectionReference<Map<String, dynamic>> get collectionRef =>
      _firestore.collection(collectionPath);

  T fromDocument(DocumentSnapshot<Map<String, dynamic>> doc);

  Map<String, dynamic> toMap(T item, {required bool isCreate});

  String getId(T item);

  Future<T> create(T item) async {
    try {
      final id = getId(item);
      final data = FirestoreTimestamp.withServerTimestamps(
        isCreate: true,
        data: toMap(item, isCreate: true),
      );
      await collectionRef.doc(id).set(data);
      final doc = await collectionRef.doc(id).get();
      return fromDocument(doc);
    } on FirebaseException catch (e) {
      throw FirestoreException(e.message ?? 'Create failed.', code: e.code);
    } catch (e) {
      throw FirestoreException(e.toString());
    }
  }

  Future<T> getById(String id) async {
    try {
      final doc = await collectionRef.doc(id).get();
      if (!doc.exists) {
        throw FirestoreException('Document not found.', code: 'not-found');
      }
      return fromDocument(doc);
    } on FirestoreException {
      rethrow;
    } on FirebaseException catch (e) {
      throw FirestoreException(e.message ?? 'Read failed.', code: e.code);
    }
  }

  Future<List<T>> getAll({Query<Map<String, dynamic>>? query}) async {
    try {
      final snapshot = query != null
          ? await query.get()
          : await collectionRef.get();
      return snapshot.docs.map(fromDocument).toList();
    } on FirebaseException catch (e) {
      throw FirestoreException(e.message ?? 'List failed.', code: e.code);
    }
  }

  Stream<List<T>> watchAll({
    Query<Map<String, dynamic>> Function(
      CollectionReference<Map<String, dynamic>>,
    )? queryBuilder,
  }) {
    final query = queryBuilder != null
        ? queryBuilder(collectionRef)
        : collectionRef;
    return query.snapshots().map(
          (s) => s.docs.map(fromDocument).toList(),
        );
  }

  Future<T> update(String id, T item) async {
    try {
      final data = FirestoreTimestamp.withServerTimestamps(
        isCreate: false,
        data: toMap(item, isCreate: false),
      );
      data.remove('createdAt');
      await collectionRef.doc(id).update(data);
      final doc = await collectionRef.doc(id).get();
      return fromDocument(doc);
    } on FirebaseException catch (e) {
      throw FirestoreException(e.message ?? 'Update failed.', code: e.code);
    }
  }

  Future<void> delete(String id) async {
    try {
      await collectionRef.doc(id).delete();
    } on FirebaseException catch (e) {
      throw FirestoreException(e.message ?? 'Delete failed.', code: e.code);
    }
  }
}
