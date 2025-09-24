# 🚀 Dependency Injection in Flutter using GetIt (with Integration Testing)

This guide explains **Dependency Injection (DI)** in Flutter using **GetIt**, shows how to structure dependencies, and how to **swap repositories** (Production vs Test) for integration testing.

---

## 🔹 1. What is Dependency Injection (DI)?

### ❌ Without DI (tight coupling)

```dart
class UserBloc {
  final UserRepository repo = UserRepository(); // tightly coupled
}
```

Problems:

- Cannot easily replace `UserRepository` with a **mock** in tests.
- Hard to maintain in large projects.

### ✅ With DI (loose coupling)

```dart
class UserBloc {
  final UserRepository repo;
  UserBloc(this.repo); // injected
}
```

Benefits:

- Testability (swap real vs fake repos).
- Clear separation of concerns.
- Better scalability.

---

## 🔹 2. Why Use GetIt?

[`get_it`](https://pub.dev/packages/get_it) is a **service locator** that:

- Registers services, repositories, and blocs once.
- Resolves them anywhere in the app (`sl<T>()`).
- Allows swapping implementations for **different environments** (prod vs test).

---

## 🔹 3. Install GetIt

In `pubspec.yaml`:

```yaml
dependencies:
  get_it: ^7.6.0
```

---

## 🔹 4. Setup Service Locator

📄 `../lib/core/serviceLocator.dart`

```dart
import 'package:get_it/get_it.dart';
import 'repositories/auth_repository.dart';
import 'repositories/mock_auth_repository.dart';

final sl = GetIt.instance;

void setupLocator({bool isTest = false}) {

  if (isTest) {
    // Register fake repo for testing
    sl.registerLazySingleton<AuthRepository>(() => MockAuthRepository());
  } else {
    // Register real repo for production
    sl.registerLazySingleton<AuthRepository>(() => AuthRepository());
  }
}
```

---

## 🔹 5. Repositories

📄 `../lib/features/auth/repositories/auth_repository.dart`

```dart
class AuthRepository {
  Future<String> login(String username, String password) async {
    // Simulated API call
    await Future.delayed(const Duration(seconds: 1));
    return "Welcome $username (real repo)";
  }
}
```

📄 `../lib/features/auth/repositories/mock_auth_repository.dart`

```dart
import 'auth_repository.dart';

class MockAuthRepository extends AuthRepository {
  @override
  Future<String> login(String username, String password) async {
    return "Welcome $username (mock repo)";
  }
}
```

---

## 🔹 6. Bloc Layer

📄 `../lib/features/auth/bloc/auth_event.dart`

```dart
abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  final String username;
  final String password;

  LoginRequested(this.username, this.password);
}
```

📄 `../lib/features/auth/bloc/auth_state.dart`

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

📄 `../lib/features/auth/bloc/auth_bloc.dart`

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../repositories/auth_repository.dart';
import '../../../service_locator.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repo = sl<AuthRepository>();

  AuthBloc() : super(AuthInitial()) {
    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final msg = await repo.login(event.username, event.password);
        emit(AuthSuccess(msg));
      } catch (e) {
        emit(AuthFailure("Login failed"));
      }
    });
  }
}
```

---

## 🔹 7. UI Layer

📄 `../lib/features/auth/view/login_page.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_boilerplate/features/auth/bloc/auth_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController userCtrl = TextEditingController();
    final TextEditingController passCtrl = TextEditingController();

    return Scaffold(
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
                TextField(
                    controller: userCtrl,
                    decoration: const InputDecoration(labelText: "Username")),
                TextField(
                    controller: passCtrl,
                    decoration: const InputDecoration(labelText: "Password")),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context
                        .read<AuthBloc>()
                        .add(LoginRequested(userCtrl.text, passCtrl.text));
                  },
                  child: const Text("Login"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
```

---

## 🔹 8. Main Entry

📄 `../lib/main.dart`

```dart
import 'package:flutter/material.dart';
import 'package:new_boilerplate/features/auth/view/login_provider.dart';
import 'core/serviceLocator.dart';

void main({bool useMock = false}) {
  setupLocator(isTest: useMock);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter boilerplate',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginProvider(),
    );
  }
}

```

---

## 🔹 9. Integration Test with Mock Repository

📄 `../test/integration_test/app_test.dart`

```dart
import 'package:flutter/material.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:new_boilerplate/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Login uses mock repo", (tester) async {
    app.main(useMock: true);
    await tester.pumpAndSettle();

    // Enter username/password
    await tester.enterText(find.byType(TextField).at(0), "Ajay");
    await tester.enterText(find.byType(TextField).at(1), "1234");

    // Tap login
    final loginButton = find.widgetWithText(ElevatedButton, 'Login');
    await tester.tap(loginButton);

    await tester.pump();
    await tester.pumpAndSettle();

    // Verify SnackBar is shown
    final snackBarFinder = find.byType(SnackBar);
    expect(snackBarFinder, findsOneWidget);

    // Verify text (adjust once we know the actual output)
    expect(
      find.descendant(
        of: snackBarFinder,
        matching: find.text("Welcome Ajay (mock repo)"),
      ),
      findsOneWidget,
    );
  });
}
```

---

## 🔹 10. How DI + GetIt Helps Here

| Scenario            | Repository Used         |
| ------------------- | ----------------------- |
| Production run      | `AuthRepository` (real) |
| Integration testing | `MockAuthRepository`    |

- **Same Bloc/UI code** works without change.
- Only `service_locator.dart` decides which dependency to inject.
- Easy to maintain, test, and scale.

---

## ✅ Summary

- **GetIt** provides a clean way to manage dependencies.
- Use `setupLocator(isTest: true)` to **inject test repositories**.
- Works seamlessly with **Bloc, Cubit, Provider, or Riverpod**.
- Great for **integration tests** where you need to mock APIs.
