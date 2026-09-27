import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/categories/data/datasources/category_remote_data_source.dart';
import '../../features/categories/data/repositories/category_repository_impl.dart';
import '../../features/categories/domain/repositories/category_repository.dart';
import '../../features/chats/data/datasources/chat_remote_data_source.dart';
import '../../features/chats/data/datasources/message_remote_data_source.dart';
import '../../features/chats/data/repositories/chat_repository_impl.dart';
import '../../features/chats/data/repositories/message_repository_impl.dart';
import '../../features/chats/domain/repositories/chat_repository.dart';
import '../../features/chats/domain/repositories/message_repository.dart';
import '../../features/favorites/data/datasources/favorite_remote_data_source.dart';
import '../../features/favorites/data/repositories/favorite_repository_impl.dart';
import '../../features/favorites/domain/repositories/favorite_repository.dart';
import '../../features/notifications/data/datasources/notification_remote_data_source.dart';
import '../../features/notifications/data/repositories/notification_repository_impl.dart';
import '../../features/notifications/domain/repositories/notification_repository.dart';
import '../../features/orders/data/datasources/order_remote_data_source.dart';
import '../../features/orders/data/repositories/order_repository_impl.dart';
import '../../features/orders/domain/repositories/order_repository.dart';
import '../../features/payments/data/datasources/payment_remote_data_source.dart';
import '../../features/payments/data/repositories/payment_repository_impl.dart';
import '../../features/payments/domain/repositories/payment_repository.dart';
import '../../features/products/data/datasources/product_remote_data_source.dart';
import '../../features/products/data/repositories/product_repository_impl.dart';
import '../../features/products/domain/repositories/product_repository.dart';
import '../../features/reviews/data/datasources/review_remote_data_source.dart';
import '../../features/reviews/data/repositories/review_repository_impl.dart';
import '../../features/reviews/domain/repositories/review_repository.dart';
import '../../features/users/data/datasources/user_remote_data_source.dart';
import '../../features/users/data/repositories/user_repository_impl.dart';
import '../../features/users/domain/entities/user_entity.dart';
import '../../features/users/domain/repositories/user_repository.dart';

// Firebase instances
final firestoreProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);

final googleSignInProvider = Provider<GoogleSignIn>(
  (ref) => GoogleSignIn(),
);

// Data sources
final userRemoteDataSourceProvider = Provider<UserRemoteDataSource>(
  (ref) => UserRemoteDataSource(ref.watch(firestoreProvider)),
);

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
  (ref) => AuthRemoteDataSource(
    firebaseAuth: ref.watch(firebaseAuthProvider),
    googleSignIn: ref.watch(googleSignInProvider),
    userRemoteDataSource: ref.watch(userRemoteDataSourceProvider),
  ),
);

final chatRemoteDataSourceProvider = Provider<ChatRemoteDataSource>(
  (ref) => ChatRemoteDataSource(ref.watch(firestoreProvider)),
);

final messageRemoteDataSourceProvider = Provider<MessageRemoteDataSource>(
  (ref) => MessageRemoteDataSource(ref.watch(firestoreProvider)),
);

final productRemoteDataSourceProvider = Provider<ProductRemoteDataSource>(
  (ref) => ProductRemoteDataSource(ref.watch(firestoreProvider)),
);

final categoryRemoteDataSourceProvider = Provider<CategoryRemoteDataSource>(
  (ref) => CategoryRemoteDataSource(ref.watch(firestoreProvider)),
);

final orderRemoteDataSourceProvider = Provider<OrderRemoteDataSource>(
  (ref) => OrderRemoteDataSource(ref.watch(firestoreProvider)),
);

final reviewRemoteDataSourceProvider = Provider<ReviewRemoteDataSource>(
  (ref) => ReviewRemoteDataSource(ref.watch(firestoreProvider)),
);

final notificationRemoteDataSourceProvider =
    Provider<NotificationRemoteDataSource>(
  (ref) => NotificationRemoteDataSource(ref.watch(firestoreProvider)),
);

final paymentRemoteDataSourceProvider = Provider<PaymentRemoteDataSource>(
  (ref) => PaymentRemoteDataSource(ref.watch(firestoreProvider)),
);

final favoriteRemoteDataSourceProvider = Provider<FavoriteRemoteDataSource>(
  (ref) => FavoriteRemoteDataSource(ref.watch(firestoreProvider)),
);

// Repositories
final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(ref.watch(authRemoteDataSourceProvider)),
);

final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepositoryImpl(ref.watch(userRemoteDataSourceProvider)),
);

final chatRepositoryProvider = Provider<ChatRepository>(
  (ref) => ChatRepositoryImpl(ref.watch(chatRemoteDataSourceProvider)),
);

final messageRepositoryProvider = Provider<MessageRepository>(
  (ref) => MessageRepositoryImpl(ref.watch(messageRemoteDataSourceProvider)),
);

final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => ProductRepositoryImpl(ref.watch(productRemoteDataSourceProvider)),
);

final categoryRepositoryProvider = Provider<CategoryRepository>(
  (ref) =>
      CategoryRepositoryImpl(ref.watch(categoryRemoteDataSourceProvider)),
);

final orderRepositoryProvider = Provider<OrderRepository>(
  (ref) => OrderRepositoryImpl(ref.watch(orderRemoteDataSourceProvider)),
);

final reviewRepositoryProvider = Provider<ReviewRepository>(
  (ref) => ReviewRepositoryImpl(ref.watch(reviewRemoteDataSourceProvider)),
);

final notificationRepositoryProvider = Provider<NotificationRepository>(
  (ref) => NotificationRepositoryImpl(
    ref.watch(notificationRemoteDataSourceProvider),
  ),
);

final paymentRepositoryProvider = Provider<PaymentRepository>(
  (ref) => PaymentRepositoryImpl(ref.watch(paymentRemoteDataSourceProvider)),
);

final favoriteRepositoryProvider = Provider<FavoriteRepository>(
  (ref) => FavoriteRepositoryImpl(ref.watch(favoriteRemoteDataSourceProvider)),
);

// Auth state stream
final authStateProvider = StreamProvider<UserEntity?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});
