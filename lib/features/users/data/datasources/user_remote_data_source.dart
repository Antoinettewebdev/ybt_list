import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_paths.dart';
import '../../../../core/data/base_firestore_data_source.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

class UserRemoteDataSource extends BaseFirestoreDataSource<UserModel> {
  UserRemoteDataSource(super.firestore);

  @override
  String get collectionPath => FirestorePaths.users;

  @override
  UserModel fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) =>
      UserModel.fromFirestore(doc);

  @override
  Map<String, dynamic> toMap(UserModel item, {required bool isCreate}) =>
      item.toMap(isCreate: isCreate);

  @override
  String getId(UserModel item) => item.id;

  Future<UserModel?> getByEmail(String email) async {
    try {
      final snapshot = await collectionRef
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      if (snapshot.docs.isEmpty) return null;
      return fromDocument(snapshot.docs.first);
    } on FirebaseException catch (e) {
      throw FirestoreException(e.message ?? 'Query failed.', code: e.code);
    }
  }

  Future<void> createIfNotExists(UserModel user) async {
    final doc = await collectionRef.doc(user.id).get();
    if (!doc.exists) {
      await create(user);
    }
  }
}
