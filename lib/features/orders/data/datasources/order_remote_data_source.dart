import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_paths.dart';
import '../../../../core/data/base_firestore_data_source.dart';
import '../models/order_model.dart';

class OrderRemoteDataSource extends BaseFirestoreDataSource<OrderModel> {
  OrderRemoteDataSource(super.firestore);

  @override
  String get collectionPath => FirestorePaths.orders;

  @override
  OrderModel fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) =>
      OrderModel.fromFirestore(doc);

  @override
  Map<String, dynamic> toMap(OrderModel item, {required bool isCreate}) =>
      item.toMap(isCreate: isCreate);

  @override
  String getId(OrderModel item) => item.id;

  Stream<List<OrderModel>> watchByUser(String userId) => watchAll(
        queryBuilder: (col) => col
            .where('userId', isEqualTo: userId)
            .orderBy('createdAt', descending: true),
      );
}
