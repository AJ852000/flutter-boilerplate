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

## 🎯 Combined Unit and Integration Testing Example

Let's see how to combine unit tests and integration tests using a real-world example.

### 📁 Project Structure

```
lib/
  features/
    auth/
      bloc/
        auth_bloc.dart
      repositories/
        auth_repository.dart
test/
  unit/
    auth_bloc_test.dart
  integration_test/
    auth_flow_test.dart
```

### 🔍 1. Unit Test Example (auth_bloc_test.dart)

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:new_boilerplate/features/auth/bloc/auth_bloc.dart';
import 'package:new_boilerplate/features/auth/repositories/auth_repository.dart';
import '../mocks/auth_repository.mocks.dart';

void main() {
  late AuthBloc authBloc;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    authBloc = AuthBloc(authRepository: mockAuthRepository);
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc', () {
    test('initial state is AuthInitial', () {
      expect(authBloc.state, isA<AuthInitial>());
    });

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthSuccess] when login is successful',
      build: () {
        when(mockAuthRepository.login('user', 'pass'))
            .thenAnswer((_) async => 'token123');
        return authBloc;
      },
      act: (bloc) => bloc.add(LoginRequested('user', 'pass')),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthSuccess>().having(
          (state) => state.token,
          'token',
          'token123',
        ),
      ],
      verify: (_) {
        verify(mockAuthRepository.login('user', 'pass')).called(1);
      },
    );

    blocTest<AuthBloc, AuthState>(
      'emits [AuthLoading, AuthError] when login fails',
      build: () {
        when(mockAuthRepository.login('user', 'pass'))
            .thenThrow(Exception('Failed to login'));
        return authBloc;
      },
      act: (bloc) => bloc.add(LoginRequested('user', 'pass')),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthError>().having(
          (state) => state.error,
          'error message',
          'Failed to login',
        ),
      ],
    );
  });
}
```

### 🔍 2. Integration Test Example (auth_flow_test.dart)

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';
import 'package:new_boilerplate/core/serviceLocator.dart';
import 'package:new_boilerplate/features/auth/repositories/auth_repository.dart';
import 'package:new_boilerplate/main.dart' as app;
import '../mocks/auth_repository.mocks.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthRepository mockAuthRepository;

  setUp(() async {
    await sl.reset();
    mockAuthRepository = MockAuthRepository();
    sl.registerLazySingleton<AuthRepository>(() => mockAuthRepository);
  });

  group('Authentication Flow', () {
    testWidgets('Complete login flow with success scenario',
        (WidgetTester tester) async {
      // 1. Mock repository response
      when(mockAuthRepository.login('test@email.com', 'password123'))
          .thenAnswer((_) async => 'success_token');

      // 2. Launch the app
      app.main();
      await tester.pumpAndSettle();

      // 3. Verify we're on login page
      expect(find.text('Login'), findsOneWidget);

      // 4. Enter credentials
      await tester.enterText(
        find.byKey(Key('email_field')),
        'test@email.com',
      );
      await tester.enterText(
        find.byKey(Key('password_field')),
        'password123',
      );

      // 5. Tap login button
      await tester.tap(find.byKey(Key('login_button')));
      await tester.pumpAndSettle();

      // 6. Verify success state
      expect(find.text('Welcome!'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);

      // 7. Verify repository was called correctly
      verify(mockAuthRepository.login('test@email.com', 'password123'))
          .called(1);
    });

    testWidgets('Login flow with error handling',
        (WidgetTester tester) async {
      // 1. Mock repository error
      when(mockAuthRepository.login(any, any))
          .thenThrow(Exception('Invalid credentials'));

      // 2. Launch the app
      app.main();
      await tester.pumpAndSettle();

      // 3. Enter credentials
      await tester.enterText(
        find.byKey(Key('email_field')),
        'wrong@email.com',
      );
      await tester.enterText(
        find.byKey(Key('password_field')),
        'wrongpass',
      );

      // 4. Tap login button
      await tester.tap(find.byKey(Key('login_button')));
      await tester.pumpAndSettle();

      // 5. Verify error state
      expect(find.text('Invalid credentials'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
```

### 🎯 Key Differences Between Unit and Integration Tests

1. **Unit Tests**:

   - Test individual components in isolation
   - Faster execution
   - More focused on business logic
   - Use `flutter_test` package
   - Run with `flutter test`

2. **Integration Tests**:
   - Test multiple components working together
   - Test UI interactions
   - Slower but more comprehensive
   - Use `integration_test` package
   - Run with `flutter test integration_test`

### 🚀 Running Both Tests

Add this to your CI/CD pipeline:

```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test
```

Remember:

- Unit tests verify your business logic works correctly
- Integration tests ensure everything works together as expected
- Using both gives you the most comprehensive test coverage! 🎯

Happy Testing! 🎉
