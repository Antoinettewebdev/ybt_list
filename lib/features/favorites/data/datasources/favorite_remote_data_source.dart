import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_paths.dart';
import '../../../../core/data/base_firestore_data_source.dart';
import '../models/favorite_model.dart';

class FavoriteRemoteDataSource extends BaseFirestoreDataSource<FavoriteModel> {
  FavoriteRemoteDataSource(super.firestore);

  @override
  String get collectionPath => FirestorePaths.favorites;

  @override
  FavoriteModel fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) =>
      FavoriteModel.fromFirestore(doc);

  @override
  Map<String, dynamic> toMap(FavoriteModel item, {required bool isCreate}) =>
      item.toMap(isCreate: isCreate);

  @override
  String getId(FavoriteModel item) => item.id;

  Future<List<FavoriteModel>> getByUser(String userId) => getAll(
        query: collectionRef.where('userId', isEqualTo: userId),
      );
}
