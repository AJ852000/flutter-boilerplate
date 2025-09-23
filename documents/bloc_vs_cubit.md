# ⚡ Cubit vs 🔥 Bloc in Flutter

Both **Cubit** and **Bloc** come from the [`flutter_bloc`](https://pub.dev/packages/flutter_bloc) package.  
The difference lies in **how they handle events and states**.

---

## 🔹 Conceptual Difference

| Feature        | Cubit ⚡                | Bloc 🔥                |
| -------------- | ----------------------- | ---------------------- |
| API complexity | Simple                  | More structured        |
| Works with     | Methods directly        | Events → State mapping |
| Best for       | Simple state management | Complex logic flows    |
| Boilerplate    | Low                     | High                   |
| Flexibility    | Less                    | More                   |
| Under the hood | Base class              | Built on top of Cubit  |

👉 **Cubit = lightweight Bloc**.  
👉 **Bloc = scalable, event-driven architecture**.

---

## 🔹 Flow Diagram

### ⚡ Cubit Flow

```
UI → call method → Cubit → emit(State) → UI updates
```

### 🔥 Bloc Flow

```
UI → add(Event) → Bloc → on<Event> handler → emit(State) → UI updates
```

---

## 🔹 Simple Example: Counter App

### ⚡ Cubit Example

```dart
class CounterCubit extends Cubit<int> {
  CounterCubit() : super(0);

  void increment() => emit(state + 1);
}
```

Usage in UI:

```dart
BlocBuilder<CounterCubit, int>(
  builder: (context, state) {
    return Column(
      children: [
        Text('Counter: $state'),
        ElevatedButton(
          onPressed: () => context.read<CounterCubit>().increment(),
          child: Text('Increment'),
        ),
      ],
    );
  },
);
```

---

### 🔥 Bloc Example

```dart
// Events
abstract class CounterEvent {}
class Increment extends CounterEvent {}

// Bloc
class CounterBloc extends Bloc<CounterEvent, int> {
  CounterBloc() : super(0) {
    on<Increment>((event, emit) => emit(state + 1));
  }
}
```

Usage in UI:

```dart
BlocBuilder<CounterBloc, int>(
  builder: (context, state) {
    return Column(
      children: [
        Text('Counter: $state'),
        ElevatedButton(
          onPressed: () => context.read<CounterBloc>().add(Increment()),
          child: Text('Increment'),
        ),
      ],
    );
  },
);
```

---

## 🔹 Real-World Example: Fetch User from API

We need states:

- **Loading ⏳**
- **Success ✅**
- **Failure ❌**

---

### ⚡ Cubit Example

```dart
// States
abstract class UserState {}
class UserInitial extends UserState {}
class UserLoading extends UserState {}
class UserLoaded extends UserState {
  final String name;
  UserLoaded(this.name);
}
class UserError extends UserState {
  final String message;
  UserError(this.message);
}

// Cubit
class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  Future<void> fetchUser() async {
    try {
      emit(UserLoading());
      await Future.delayed(Duration(seconds: 2)); // simulate API
      emit(UserLoaded("Ajay Jadhav"));
    } catch (_) {
      emit(UserError("Failed to load user"));
    }
  }
}
```

Usage:

```dart
BlocBuilder<UserCubit, UserState>(
  builder: (context, state) {
    if (state is UserLoading) return CircularProgressIndicator();
    if (state is UserLoaded) return Text("Hello, ${state.name}");
    if (state is UserError) return Text("Error: ${state.message}");
    return ElevatedButton(
      onPressed: () => context.read<UserCubit>().fetchUser(),
      child: Text("Load User"),
    );
  },
);
```

---

### 🔥 Bloc Example

```dart
// Events
abstract class UserEvent {}
class FetchUser extends UserEvent {}

// States
abstract class UserState {}
class UserInitial extends UserState {}
class UserLoading extends UserState {}
class UserLoaded extends UserState {
  final String name;
  UserLoaded(this.name);
}
class UserError extends UserState {
  final String message;
  UserError(this.message);
}

// Bloc
class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<FetchUser>(_onFetchUser);
  }

  Future<void> _onFetchUser(FetchUser event, Emitter<UserState> emit) async {
    try {
      emit(UserLoading());
      await Future.delayed(Duration(seconds: 2)); // simulate API
      emit(UserLoaded("Ajay Jadhav"));
    } catch (_) {
      emit(UserError("Failed to load user"));
    }
  }
}
```

Usage:

```dart
BlocBuilder<UserBloc, UserState>(
  builder: (context, state) {
    if (state is UserLoading) return CircularProgressIndicator();
    if (state is UserLoaded) return Text("Hello, ${state.name}");
    if (state is UserError) return Text("Error: ${state.message}");
    return ElevatedButton(
      onPressed: () => context.read<UserBloc>().add(FetchUser()),
      child: Text("Load User"),
    );
  },
);
```

---

## 🔹 Folder Structure (Single Feature)

### ⚡ Cubit

```
user/
 ├── cubit/
 │    ├── user_cubit.dart
 │    └── user_state.dart
 ├── models/
 │    └── user_model.dart
 ├── repository/
 │    └── user_repository.dart
 └── view/
      └── user_page.dart
```

### 🔥 Bloc

```
user/
 ├── bloc/
 │    ├── user_bloc.dart
 │    ├── user_event.dart
 │    └── user_state.dart
 ├── models/
 │    └── user_model.dart
 ├── repository/
 │    └── user_repository.dart
 └── view/
      └── user_page.dart
```

---

## 🔹 Full App Folder Structure

### ⚡ Cubit

```
features/
 ├── auth/
 │    ├── cubit/
 │    │    ├── auth_cubit.dart
 │    │    └── auth_state.dart
 │    ├── repository/
 │    └── view/
 ├── user/
 │    ├── cubit/
 │    │    ├── user_cubit.dart
 │    │    └── user_state.dart
 │    ├── repository/
 │    └── view/
 ├── posts/
 │    ├── cubit/
 │    │    ├── posts_cubit.dart
 │    │    └── posts_state.dart
 │    ├── repository/
 │    └── view/
 └── common/
      └── widgets/
```

---

### 🔥 Bloc

```
features/
 ├── auth/
 │    ├── bloc/
 │    │    ├── auth_bloc.dart
 │    │    ├── auth_event.dart
 │    │    └── auth_state.dart
 │    ├── repository/
 │    └── view/
 ├── user/
 │    ├── bloc/
 │    │    ├── user_bloc.dart
 │    │    ├── user_event.dart
 │    │    └── user_state.dart
 │    ├── repository/
 │    └── view/
 ├── posts/
 │    ├── bloc/
 │    │    ├── posts_bloc.dart
 │    │    ├── posts_event.dart
 │    │    └── posts_state.dart
 │    ├── repository/
 │    └── view/
 └── common/
      └── widgets/
```

---

## 🔹 When to Use What?

✅ **Use Cubit (⚡)**

- Simple features: counters, toggles, single API fetch.
- Lower boilerplate, faster to implement.

✅ **Use Bloc (🔥)**

- Complex features: authentication, CRUD flows, pagination, caching.
- Scales better with multiple events and states.

---

## 🔹 Quick Analogy

- **Cubit ⚡ = Swiss Army Knife 🔪**  
  → Small, handy, does the job quickly.

- **Bloc 🔥 = Full Toolbox 🧰**  
  → More setup, but perfect for complex construction.
