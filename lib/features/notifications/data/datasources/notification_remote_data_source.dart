import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_paths.dart';
import '../../../../core/data/base_firestore_data_source.dart';
import '../models/notification_model.dart';

class NotificationRemoteDataSource
    extends BaseFirestoreDataSource<NotificationModel> {
  NotificationRemoteDataSource(super.firestore);

  @override
  String get collectionPath => FirestorePaths.notifications;

  @override
  NotificationModel fromDocument(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) =>
      NotificationModel.fromFirestore(doc);

  @override
  Map<String, dynamic> toMap(
    NotificationModel item, {
    required bool isCreate,
  }) =>
      item.toMap(isCreate: isCreate);

  @override
  String getId(NotificationModel item) => item.id;

  Stream<List<NotificationModel>> watchByUser(String userId) => watchAll(
        queryBuilder: (col) => col
            .where('userId', isEqualTo: userId)
            .orderBy('createdAt', descending: true),
      );
}
