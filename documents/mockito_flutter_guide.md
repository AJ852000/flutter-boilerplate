
# 🚀 Mockito in Flutter: A Beginner-Friendly Guide

Mockito is a **powerful mocking framework** for Dart and Flutter that helps you test your apps without relying on real implementations of services like APIs, databases, or repositories.

---

## 🔍 What is Mockito?
- Mockito lets you **create fake versions** of your classes automatically.
- You can **control what those fakes return** during tests.
- You can **verify interactions** (e.g., check if a method was called).

This is very useful for:
✅ Unit Tests  
✅ Widget Tests  
✅ Integration Tests  

---

## 🛠️ Setup Mockito

Add these dependencies to your `pubspec.yaml`:

```yaml
dev_dependencies:
  mockito: ^5.4.2
  build_runner: ^2.4.6
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
```

Then run:

```bash
flutter pub get
```

---

## 🏗️ Step 1: Create an Abstract Repository

Suppose we have an **AuthRepository**:

```dart
abstract class AuthRepository {
  Future<String> login(String username, String password);
}
```

---

## 🏗️ Step 2: Generate a Mock with Mockito

Create a new test file `auth_repository_test.dart`:

```dart
import 'package:mockito/annotations.dart';
import 'package:new_boilerplate/features/auth/repositories/auth_repository.dart';

@GenerateMocks([AuthRepository])
void main() {}
```

Now run this command:

```bash
flutter pub run build_runner build
```

👉 This generates a file: **`auth_repository_test.mocks.dart`**  
It will contain a `MockAuthRepository` class.

---

## 🏗️ Step 3: Use Mock in Integration Test

Here’s a **real integration test example**:

`integration_test/app_test.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';
import 'package:new_boilerplate/core/serviceLocator.dart';
import 'package:new_boilerplate/features/auth/repositories/auth_repository.dart';
import 'package:new_boilerplate/main.dart' as app;

import 'auth_repository_test.mocks.dart'; // generated mock

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthRepository mockRepo;

  setUp(() async {
    await sl.reset(); // clear GetIt before each test
    mockRepo = MockAuthRepository();

    // Register mock in service locator
    sl.registerLazySingleton<AuthRepository>(() => mockRepo);
  });

  testWidgets("🔑 Login uses mockito mock repo", (tester) async {
    // Arrange: define mock behavior
    when(mockRepo.login("Ajay", "1234"))
        .thenAnswer((_) async => "Welcome Ajay (mockito)");

    // Start app
    app.main();
    await tester.pumpAndSettle();

    // Act: enter username and password
    await tester.enterText(find.byType(TextField).at(0), "Ajay");
    await tester.enterText(find.byType(TextField).at(1), "1234");

    await tester.tap(find.widgetWithText(ElevatedButton, "Login"));
    await tester.pumpAndSettle();

    // Assert: check SnackBar
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text("Welcome Ajay (mockito)"), findsOneWidget);

    // Verify: method called exactly once
    verify(mockRepo.login("Ajay", "1234")).called(1);
  });
}
```

---

## ✅ Benefits of Mockito
✨ No need to write manual mocks.  
✨ Easy to **simulate success or failure** cases.  
✨ Lets you **verify function calls**.  
✨ Works with **unit, widget, and integration tests**.  

---

## 📌 Common Mockito Tricks

- Mocking any value:
  ```dart
  when(mockRepo.login(any, any)).thenAnswer((_) async => "Hello User");
  ```

- Throwing an exception:
  ```dart
  when(mockRepo.login(any, any)).thenThrow(Exception("Server down"));
  ```

- Verifying calls:
  ```dart
  verify(mockRepo.login("Ajay", "1234")).called(1);
  verifyNever(mockRepo.login("OtherUser", any));
  ```

---

# 🎯 Summary

1. Add `mockito` and `build_runner`.  
2. Annotate your interfaces with `@GenerateMocks`.  
3. Run `flutter pub run build_runner build`.  
4. Use mocks in **integration tests** to simulate API/data behavior.  

👉 Mockito makes your tests **fast, predictable, and isolated** 🚀

---

Happy Testing! 🎉
