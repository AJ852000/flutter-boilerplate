# 🚀 Flutter Dependency Injection + Mockito (Beginner-Friendly Full Demo)

This guide is a **beginner-friendly explanation** of a real-world Flutter setup using:

- **Dependency Injection (GetIt)**
- **Bloc architecture**
- **UI layer**
- **Unit tests** (with Mockito)
- **Integration tests** (with Mockito)

We will go step by step, explaining concepts deeply so you can understand the implementation.

---

## 🔹 1. Setup Dependencies

Before writing code, we need the right packages. Add these to `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^9.2.0  # State management using Bloc
  get_it: ^7.6.0          # Service locator for dependency injection

dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
  mockito: ^5.4.2         # For creating mocks in tests
  build_runner: ^2.4.6     # Generates mock classes
```

Run:

```bash
flutter pub get
```

> **Tip:** Always install `mockito` and `build_runner` for automated test mocks. Manual mocks can be error-prone.

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

## 🔹 3. Service Locator (GetIt)

**GetIt** allows registering services once and using them anywhere.

### 📄 `service_locator.dart`

```dart
import 'package:get_it/get_it.dart';
import 'repositories/auth_repository.dart';

final sl = GetIt.instance;

// Setup method for production or test environment
void setupLocator({bool isTest = false}) {
  sl.registerLazySingleton<AuthRepository>(() => AuthRepository());
}
```

> **Concept:** Instead of creating new instances everywhere, we let GetIt manage a single instance for the app. Makes testing easier.

---

## 🔹 4. Bloc Layer

**Bloc** manages the state of the app and separates business logic from UI.

### 📄 `auth_event.dart`

```dart
abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String username;
  final String password;
  LoginRequested(this.username, this.password);
}
```

### 📄 `auth_state.dart`

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

### 📄 `auth_bloc.dart`

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repo; // Repository is injected for testability

  AuthBloc({required this.repo}) : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading()); // Show loading state
      try {
        final msg = await repo.login(event.username, event.password);
        emit(AuthSuccess(msg)); // Emit success if login works
      } catch (_) {
        emit(AuthFailure("Login failed")); // Handle errors
      }
    });
  }
}
```

> **Concept:** Bloc receives repository via constructor. This allows **mocking repositories** in tests without changing Bloc logic.

---

## 🔹 5. UI Layer

### 📄 `login_page.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginPageWithBloc extends StatelessWidget {
  final AuthBloc authBloc;
  const LoginPageWithBloc({super.key, required this.authBloc});

  @override
  Widget build(BuildContext context) {
    final userCtrl = TextEditingController();
    final passCtrl = TextEditingController();

    return BlocProvider<AuthBloc>.value(
      value: authBloc,
      child: Scaffold(
        appBar: AppBar(title: const Text("Login")),
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(controller: userCtrl, decoration: const InputDecoration(labelText: "Username")),
                  TextField(controller: passCtrl, decoration: const InputDecoration(labelText: "Password")),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(LoginRequested(userCtrl.text, passCtrl.text));
                    },
                    child: const Text("Login"),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
```

> **Concept:** UI listens to Bloc state changes and updates widgets accordingly.

---

## 🔹 6. Main Entry

### 📄 `main.dart`

```dart
import 'package:flutter/material.dart';
import 'core/service_locator.dart';
import 'features/auth/view/login_page.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/auth/repositories/auth_repository.dart';

void main({bool useMock = false}) {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Builder(
        builder: (context) => LoginPageWithBloc(
          authBloc: AuthBloc(repo: sl<AuthRepository>()),
        ),
      ),
    );
  }
}
```

> **Concept:** The app always uses the DI container to get repository instances, ensuring **loose coupling**.

---

## 🔹 7. Generate Mockito Mocks

Create `test/mocks/auth_repository_test.dart`:

```dart
import 'package:mockito/annotations.dart';
import '../../lib/features/auth/repositories/auth_repository.dart';

@GenerateMocks([AuthRepository])
void main() {}
```

Run:

```bash
flutter pub run build_runner build
```

> Generates `auth_repository_test.mocks.dart` containing `MockAuthRepository`.

---

## 🔹 8. Integration Test (Mockito)

### 📄 `app_test.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';
import '../../lib/features/auth/bloc/auth_bloc.dart';
import '../../lib/features/auth/bloc/auth_event.dart';
import '../../lib/features/auth/view/login_page.dart';
import '../mocks/auth_repository_test.mocks.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthRepository mockRepo;

  setUp(() {
    mockRepo = MockAuthRepository();
  });

  testWidgets("Login uses mockito mock repo", (tester) async {
    when(mockRepo.login('Ajay', '1234')).thenAnswer((_) async => 'Welcome Ajay (mockito)');

    await tester.pumpWidget(
      MaterialApp(
        home: LoginPageWithBloc(authBloc: AuthBloc(repo: mockRepo)),
      ),
    );

    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).at(0), 'Ajay');
    await tester.enterText(find.byType(TextField).at(1), '1234');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Login'));
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Welcome Ajay (mockito)'), findsOneWidget);
    verify(mockRepo.login('Ajay', '1234')).called(1);
  });
}
```

---

## 🔹 9. Unit Test (Mockito)

### 📄 `auth_bloc_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';
import '../../lib/features/auth/bloc/auth_bloc.dart';
import '../../lib/features/auth/bloc/auth_event.dart';
import '../../lib/features/auth/bloc/auth_state.dart';
import '../mocks/auth_repository_test.mocks.dart';

void main() {
  late MockAuthRepository mockRepo;
  late AuthBloc authBloc;

  setUp(() {
    mockRepo = MockAuthRepository();
    authBloc = AuthBloc(repo: mockRepo);
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc Unit Test', () {
    test('emits [AuthLoading, AuthSuccess] on successful login', () async {
      when(mockRepo.login('Ajay', '1234')).thenAnswer((_) async => 'Welcome Ajay (mockito)');

      authBloc.add(LoginRequested('Ajay', '1234'));

      await expectLater(
        authBloc.stream,
        emitsInOrder([
          isA<AuthLoading>(),
          isA<AuthSuccess>().having((s) => s.message, 'message', 'Welcome Ajay (mockito)'),
        ]),
      );

      verify(mockRepo.login('Ajay', '1234')).called(1);
    });
  });
}
```

---

## 🔹 10. Running Tests

```bash
# Unit tests
flutter test

# Integration tests
flutter test integration_test
```

---

## ✅ 11. Summary

- **DI + GetIt** makes swapping real and mock repositories easy.
- **Bloc** separates business logic from UI.
- **Mockito** allows **mocking, stubbing, and verifying calls**.
- Fully supports **unit and integration tests**.
- Beginner-friendly explanation for **understanding each layer** and **best practices in real apps**.

