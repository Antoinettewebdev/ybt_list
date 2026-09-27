/// Firestore collection and subcollection paths.
/// Collections are created automatically on first write.
abstract final class FirestorePaths {
  static const String users = 'users';
  static const String chats = 'chats';
  static const String messages = 'messages';
  static const String products = 'products';
  static const String categories = 'categories';
  static const String orders = 'orders';
  static const String reviews = 'reviews';
  static const String notifications = 'notifications';
  static const String payments = 'payments';
  static const String favorites = 'favorites';

  static String chatMessages(String chatId) =>
      '$chats/$chatId/$messages';
}
