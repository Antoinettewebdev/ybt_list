import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_paths.dart';
import '../../../../core/data/base_firestore_data_source.dart';
import '../models/review_model.dart';

class ReviewRemoteDataSource extends BaseFirestoreDataSource<ReviewModel> {
  ReviewRemoteDataSource(super.firestore);

  @override
  String get collectionPath => FirestorePaths.reviews;

  @override
  ReviewModel fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) =>
      ReviewModel.fromFirestore(doc);

  @override
  Map<String, dynamic> toMap(ReviewModel item, {required bool isCreate}) =>
      item.toMap(isCreate: isCreate);

  @override
  String getId(ReviewModel item) => item.id;

  Future<List<ReviewModel>> getByProduct(String productId) => getAll(
        query: collectionRef
            .where('productId', isEqualTo: productId)
            .orderBy('createdAt', descending: true),
      );
}
