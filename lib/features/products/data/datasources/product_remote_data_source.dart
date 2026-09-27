import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_paths.dart';
import '../../../../core/data/base_firestore_data_source.dart';
import '../models/product_model.dart';

class ProductRemoteDataSource extends BaseFirestoreDataSource<ProductModel> {
  ProductRemoteDataSource(super.firestore);

  @override
  String get collectionPath => FirestorePaths.products;

  @override
  ProductModel fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) =>
      ProductModel.fromFirestore(doc);

  @override
  Map<String, dynamic> toMap(ProductModel item, {required bool isCreate}) =>
      item.toMap(isCreate: isCreate);

  @override
  String getId(ProductModel item) => item.id;

  Future<List<ProductModel>> getByCategory(String categoryId) => getAll(
        query: collectionRef
            .where('categoryId', isEqualTo: categoryId)
            .where('isActive', isEqualTo: true),
      );
}
