# YBT Chat

Flutter app with Firebase Firestore, Authentication, and clean architecture.

## Firestore collections

| Collection | Path | Notes |
|------------|------|--------|
| users | `users/{userId}` | Auto-created on signup |
| chats | `chats/{chatId}` | |
| messages | `chats/{chatId}/messages/{messageId}` | Subcollection |
| products | `products/{productId}` | Prices in GHS (pesewas) |
| categories | `categories/{categoryId}` | |
| orders | `orders/{orderId}` | |
| reviews | `reviews/{reviewId}` | |
| notifications | `notifications/{id}` | |
| payments | `payments/{paymentId}` | |
| favorites | `favorites/{favoriteId}` | |

Collections are created automatically on first write.

## Project structure

```
lib/
├── core/                 # Shared errors, DI, utils, base Firestore CRUD
├── features/             # Feature modules (domain / data / presentation)
│   ├── auth/
│   ├── users/
│   ├── chats/
│   ├── products/
│   └── ...
├── firebase_options.dart
└── main.dart
```

## Setup

1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/).

2. Install FlutterFire CLI and configure the app:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

This replaces `lib/firebase_options.dart` and downloads `google-services.json` / `GoogleService-Info.plist`.

3. Enable **Authentication** → Email/Password and **Google** sign-in.

4. Create a **Firestore** database and deploy rules:

```bash
firebase deploy --only firestore:rules,firestore:indexes
```

5. Install dependencies and run:

```bash
flutter pub get
flutter run
```

## Currency (GHS)

Amounts are stored as **pesewas** (integer): `100` = GH₵1.00. Use `Money` and `CurrencyFormatter` from `lib/core/utils/`.

## Usage example

```dart
final productRepo = ref.read(productRepositoryProvider);
final id = IdGenerator.newId();

await productRepo.create(ProductModel(
  id: id,
  name: 'Sample',
  description: 'Description',
  price: Money.fromCedis(49.99),
  categoryId: 'category-id',
  sellerId: ref.read(authStateProvider).value!.id,
));
```

## Auth

- Email/password sign up creates a `users/{uid}` document automatically.
- Google sign-in creates the user document if missing.
