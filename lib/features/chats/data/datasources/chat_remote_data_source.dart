import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../core/constants/firestore_paths.dart';
import '../../../../core/data/base_firestore_data_source.dart';
import '../models/chat_model.dart';

class ChatRemoteDataSource extends BaseFirestoreDataSource<ChatModel> {
  ChatRemoteDataSource(super.firestore);

  @override
  String get collectionPath => FirestorePaths.chats;

  @override
  ChatModel fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) =>
      ChatModel.fromFirestore(doc);

  @override
  Map<String, dynamic> toMap(ChatModel item, {required bool isCreate}) =>
      item.toMap(isCreate: isCreate);

  @override
  String getId(ChatModel item) => item.id;

  Stream<List<ChatModel>> watchUserChats(String userId) => watchAll(
        queryBuilder: (col) => col
            .where('participantIds', arrayContains: userId)
            .orderBy('lastMessageAt', descending: true),
      );
}
