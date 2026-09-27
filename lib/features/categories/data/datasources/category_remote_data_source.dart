import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_paths.dart';
import '../../../../core/data/base_firestore_data_source.dart';
import '../models/category_model.dart';

class CategoryRemoteDataSource extends BaseFirestoreDataSource<CategoryModel> {
  CategoryRemoteDataSource(super.firestore);

  @override
  String get collectionPath => FirestorePaths.categories;

  @override
  CategoryModel fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) =>
      CategoryModel.fromFirestore(doc);

  @override
  Map<String, dynamic> toMap(CategoryModel item, {required bool isCreate}) =>
      item.toMap(isCreate: isCreate);

  @override
  String getId(CategoryModel item) => item.id;
}
