import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_paths.dart';
import '../../../../core/data/base_firestore_data_source.dart';
import '../models/payment_model.dart';

class PaymentRemoteDataSource extends BaseFirestoreDataSource<PaymentModel> {
  PaymentRemoteDataSource(super.firestore);

  @override
  String get collectionPath => FirestorePaths.payments;

  @override
  PaymentModel fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) =>
      PaymentModel.fromFirestore(doc);

  @override
  Map<String, dynamic> toMap(PaymentModel item, {required bool isCreate}) =>
      item.toMap(isCreate: isCreate);

  @override
  String getId(PaymentModel item) => item.id;
}
