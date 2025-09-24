# Flutter Testing with Mockito 🚀

Welcome to this comprehensive guide on testing Flutter applications using Mockito! This tutorial will help you understand:

- ✨ **Test-Driven Development (TDD)** basics
- 🎯 **Bloc Pattern** for state management
- 🧪 **Unit Testing** with Mockito
- 🔄 **Integration Testing**
- 💉 **Dependency Injection**

By the end of this guide, you'll be confident in writing tests for your Flutter applications!

---

## 🔹 1. Setup Dependencies

Before writing code, we need the right packages. Add these to `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.3 # State management using Bloc
  get_it: ^7.6.4 # Service locator for dependency injection

dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
  mockito: ^5.4.3 # For creating mocks in tests
  build_runner: ^2.4.6 # Generates mock classes
```

Run:

```bash
flutter pub get
```

## 🌟 Understanding the Project Structure

Before we dive into the code, let's understand how our project is organized:

```
lib/
  ├── features/
  │   └── auth/
  │       ├── repositories/     # Data layer
  │       ├── bloc/            # Business logic
  │       └── view/            # UI components
test/
  ├── mocks/                   # Generated mocks
  ├── unit_test/              # Unit tests
  └── integration_test/        # Integration tests
```

This structure follows the **Clean Architecture** principle, separating concerns into distinct layers.

## 🔹 2. Repository Layer: Data Access

The Repository pattern is a crucial concept in clean architecture. It acts as a bridge between your application and data sources (API, database, etc.).

### 📄 `auth_repository.dart`

```dart
class AuthRepository {
  // Simulates an API call for login
  Future<String> login(String username, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return "Welcome $username (real repo)";
  }
}
```

> 🎓 **Learning Points:**
>
> - Repositories abstract data access
> - Makes testing easier by allowing mock implementations
> - Follows Single Responsibility Principle
> - Can be easily swapped with different implementations

---

## 🔹 2. Repository Layer

**Repositories** are classes responsible for fetching data (from API, DB, etc.).

### 📄 `auth_repository.dart` (Real Repository)

```dart
class AuthRepository {
  // Simulates an API call for login
  Future<String> login(String username, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return "Welcome $username (real repo)";
  }
}
```

> **Concept:** A repository abstracts data access. UI or Bloc doesn’t know whether data comes from API, DB, or mock.

---

## 🔹 3. BLoC Pattern Implementation

The BLoC (Business Logic Component) pattern is a state management solution that separates business logic from UI. Let's break it down:

### 1. Events: User Actions 🎮

```dart
abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String username;
  final String password;
  LoginRequested(this.username, this.password);
}
```

> 🎓 **Learning Points:**
>
> - Events represent user actions
> - They are immutable
> - Can carry data needed for the action

### 2. States: UI States 📱

```dart
abstract class AuthState {}

class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {
  final String message;
  AuthSuccess(this.message);
}
class AuthFailure extends AuthState {
  final String error;
  AuthFailure(this.error);
}
```

> 🎓 **Learning Points:**
>
> - States represent what UI should show
> - Can be multiple states (loading, success, error)
> - Immutable and can carry data

### 3. The BLoC Class: Business Logic 🧠

```dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repo;

  AuthBloc({required this.repo}) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final msg = await repo.login(event.username, event.password);
        emit(AuthSuccess(msg));
      } catch (_) {
        emit(AuthFailure("Login failed"));
      }
    });
  }
}
```

> 🎓 **Learning Points:**
>
> - BLoC connects events to states
> - Uses dependency injection for testability
> - Handles business logic and error cases
> - Emits new states based on events

## 🔹 4. Testing with Mockito 🧪

### Step 1: Generate Mocks

First, create a file to tell Mockito what to mock:

```dart
@GenerateMocks([AuthRepository])
void main() {}
```

Run the generator:

```bash
flutter pub run build_runner build
```

### Step 2: Writing Unit Tests

Here's our comprehensive test file that showcases different testing scenarios:

```dart
void main() {
  late MockAuthRepository mockRepo;
  late AuthBloc authBloc;

  setUp(() {
    // Create fresh instances before each test
    mockRepo = MockAuthRepository();
    authBloc = AuthBloc(repo: mockRepo);
  });

  tearDown(() {
    // Clean up after each test
    authBloc.close();
  });

  group('AuthBloc Unit Test', () {
    test('emits [AuthLoading, AuthSuccess] on successful login', () async {
      // 1. ARRANGE: Set up the mock behavior
      when(mockRepo.login('Ajay', '1234'))
          .thenAnswer((_) async => 'Welcome Ajay (mockito)');

      // 2. ACT: Trigger the login event
      authBloc.add(LoginRequested('Ajay', '1234'));

      // 3. ASSERT: Verify the expected states
      await expectLater(
        authBloc.stream,
        emitsInOrder([
          isA<AuthLoading>(),
          isA<AuthSuccess>()
              .having((s) => s.message, 'message', 'Welcome Ajay (mockito)'),
        ]),
      );

      // 4. VERIFY: Check if mock was called correctly
      verify(mockRepo.login('Ajay', '1234')).called(1);
    });
  });
}
```

> 🎓 **Learning Points:**
>
> - Use `setUp` and `tearDown` for clean tests
> - Follow the Arrange-Act-Assert pattern
> - Mock external dependencies
> - Verify mock interactions

## 🔹 5. Testing Best Practices 🌟

### 1. Test Organization 📁

```dart
test/
  ├── mocks/                  # Generated mock classes
  │   └── auth_repository_test.dart
  ├── unit_test/             # Unit tests
  │   └── auth_bloc_test.dart
  └── integration_test/      # Integration tests
      └── app_test.dart
```

### 2. The AAA Pattern 🎯

Always structure your tests using the AAA pattern:

```dart
test('login success test', () async {
  // Arrange: Set up test data and conditions
  when(mockRepo.login('user', 'pass'))
      .thenAnswer((_) async => 'Welcome user');

  // Act: Perform the action being tested
  authBloc.add(LoginRequested('user', 'pass'));

  // Assert: Verify the results
  await expectLater(
    authBloc.stream,
    emitsInOrder([
      isA<AuthLoading>(),
      isA<AuthSuccess>(),
    ]),
  );
});
```

### 3. Clean Test Setup ⚙️

Use `setUp` and `tearDown` for clean test organization:

```dart
setUp(() {
  // Create fresh instances before each test
  mockRepo = MockAuthRepository();
  authBloc = AuthBloc(repo: mockRepo);
});

tearDown(() {
  // Clean up after each test
  authBloc.close();
});
```

### 4. Meaningful Test Names 📝

Write descriptive test names that explain the scenario:

```dart
test('should show loading then success when login succeeds', () async {
  // Test code here
});

test('should show loading then error when login fails', () async {
  // Test code here
});
```

## 🔹 6. Integration Testing 🧩

Integration tests verify that different parts of your app work together:

```dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("full login flow test", (tester) async {
    // 1. Set up mock behavior
    when(mockRepo.login('Ajay', '1234'))
        .thenAnswer((_) async => 'Welcome Ajay');

    // 2. Build the widget
    await tester.pumpWidget(
      MaterialApp(
        home: LoginPageWithBloc(authBloc: AuthBloc(repo: mockRepo)),
      ),
    );

    // 3. Interact with widgets
    await tester.enterText(find.byType(TextField).at(0), 'Ajay');
    await tester.enterText(find.byType(TextField).at(1), '1234');
    await tester.tap(find.text('Login'));

    // 4. Wait for animations
    await tester.pumpAndSettle();

    // 5. Verify results
    expect(find.text('Welcome Ajay'), findsOneWidget);
  });
}
```

## 🎉 Conclusion

Testing with Mockito in Flutter helps you:

- ✅ Write reliable, maintainable tests
- ✅ Catch bugs before they reach production
- ✅ Refactor with confidence
- ✅ Document expected behavior
- ✅ Follow best practices

### Running Tests 🏃‍♂️

```bash
# Run all tests
flutter test

# Run integration tests
flutter test integration_test

# Generate mocks
flutter pub run build_runner build
```

## 📚 Further Reading

- [Official Mockito Package](https://pub.dev/packages/mockito)
- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [BLoC Library Documentation](https://bloclibrary.dev)
- [Flutter Integration Testing Guide](https://docs.flutter.dev/testing/integration-tests)

Remember: Good tests make good code better! Happy testing! 🚀
