# Intermediate Level: State Management & Riverpod 3.0 Guide

This guide details modern state management paradigms, Riverpod 3.0 code generation, `AsyncValue` lifecycle, and best practices.

---

## Table of Contents

1. [Why Riverpod 3.0? (Comparison with Provider & Bloc)](#1-why-riverpod-30-comparison-with-provider--bloc)
2. [`@riverpod` Code Generation](#2-riverpod-code-generation)
3. [`Notifier` vs `AsyncNotifier`](#3-notifier-vs-asyncnotifier)
4. [`ref.watch`, `ref.read`, `ref.listen` & `ref.select`](#4-refwatch-refread-reflisten--refselect)
5. [Managing Asynchronous State with `AsyncValue`](#5-managing-asynchronous-state-with-asyncvalue)
6. [`keepAlive: true` vs Auto-Dispose & Riverpod Lifecycle](#6-keepalive-true-vs-auto-dispose--riverpod-lifecycle)
7. [Unit Testing Notifiers with `ProviderContainer`](#7-unit-testing-notifiers-with-providercontainer)

---

## 1. Why Riverpod 3.0? (Comparison with Provider & Bloc)

### Q1: Why choose Riverpod 3.0 over `Provider` with `ChangeNotifier`?
**Answer:**

**Production Example:** [counter_provider.dart](../../../../lib/feature/counter/providers/counter_provider.dart)

**Problems with Provider + ChangeNotifier:**

1. **BuildContext Dependency**
```dart
// OLD Provider way - needs context
final counter = Provider.of<CounterNotifier>(context);
final counter = context.read<CounterNotifier>();
```

2. **Runtime Errors**
```dart
// Can throw ProviderNotFoundException at runtime
final value = Provider.of<MyNotifier>(context);  // Crash if not provided!
```

3. **Manual Disposal Required**
```dart
class CounterNotifier extends ChangeNotifier {
  int _count = 0;

  void increment() {
    _count++;
    notifyListeners();  // Manual notification
  }

  @override
  void dispose() {
    // Must remember to dispose
    super.dispose();
  }
}
```

4. **No Built-in Async Support**
```dart
// Have to manually manage loading/error states
class MyNotifier extends ChangeNotifier {
  bool isLoading = false;
  String? error;
  Data? data;

  Future<void> fetchData() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      data = await api.fetch();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
```

**Riverpod 3.0 Solutions:**

1. **No BuildContext Needed**
```dart
// Modern Riverpod - works anywhere
final counter = ref.read(counterProvider);
final counter = ref.watch(counterProvider);  // In widgets
```

2. **Compile-Time Safety**
```dart
// Type-safe, can't have wrong provider
final count = ref.watch(counterProvider);  // Always correct type
```

3. **Auto-Disposal**
```dart
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;  // Auto-disposed when not used

  void increment() => state++;  // No notifyListeners needed
}
```

4. **Built-in AsyncValue**
```dart
@riverpod
class UserData extends _$UserData {
  @override
  Future<User> build() async {
    return await api.fetchUser();  // Handles loading/error automatically
  }
}

// In UI
ref.watch(userDataProvider).when(
  data: (user) => Text(user.name),
  loading: () => CircularProgressIndicator(),
  error: (e, st) => Text('Error: $e'),
);
```

5. **Code Generation = Less Boilerplate**
```dart
// OLD Provider way - 15+ lines
final counterProvider = ChangeNotifierProvider<CounterNotifier>((ref) {
  return CounterNotifier();
});

class CounterNotifier extends ChangeNotifier {
  int _count = 0;
  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

// NEW Riverpod way - 5 lines
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0;
  void increment() => state++;
}
```

**Comparison Table:**

| Feature | Provider + ChangeNotifier | Riverpod 3.0 |
|---------|---------------------------|--------------|
| BuildContext required | Yes | No |
| Compile-time safety | No | Yes |
| Auto-disposal | Manual | Automatic |
| Async state handling | Manual | AsyncValue built-in |
| Code generation | No | Yes |
| Testing | Harder (needs widget) | Easy (ProviderContainer) |
| Performance | Good | Better (selective rebuilds) |
| Learning curve | Easy | Medium |

### Q2: When should you still use Provider instead of Riverpod?
**Answer:**
- **Legacy projects**: Already using Provider extensively
- **Team familiarity**: Team only knows Provider
- **Simple apps**: Very basic state needs

For new projects or growing codebases, Riverpod is recommended.

---

## 2. `@riverpod` Code Generation

### Q3: How does modern `@riverpod` syntax replace legacy Riverpod providers?
**Answer:**

**Production Example:** [lib/feature/counter/providers/counter_provider.dart](../../../../lib/feature/counter/providers/counter_provider.dart)

Instead of manually typing `StateNotifierProvider<MyNotifier, MyState>`, annotate classes with `@riverpod`:

```dart
// Modern Riverpod 3.0 Synchronous Notifier
@riverpod
class Counter extends _$Counter {
  @override
  int build() => 0; // Initial state

  void increment() => state++;
}

// Generates: counterProvider
```

---

## 3. `Notifier` vs `AsyncNotifier`

### Q4: When should you use `AsyncNotifier` over a standard `Notifier`?
**Answer:**
- **`Notifier<T>`**: For synchronous state machines (e.g., UI toggles, tabs, theme mode).
- **`AsyncNotifier<T>`**: For asynchronous workflows (API queries, database reads, authentication). It returns `Future<T>` in `build()` and manages `state` as `AsyncValue<T>`.

```dart
@riverpod
class UserRepositoryNotifier extends _$UserRepositoryNotifier {
  @override
  Future<List<RepositoryListModel>> build(String username) async {
    // Automatically enters AsyncLoading state during network fetch
    return ref.read(userRepositoryProvider).getRepositories(username, 30);
  }
}
```

---

## 4. `ref.watch`, `ref.read`, `ref.listen` & `ref.select`

### Q5: When should each `ref` method be used?
**Answer:**

| Method | Where to Call | Behavior | Primary Use Case |
| :--- | :--- | :--- | :--- |
| **`ref.watch(p)`** | `Widget.build()`, `Notifier.build()` | Subscribes & triggers rebuild on state change | Displaying data in UI |
| **`ref.read(p)`** | Event callbacks (`onPressed`) | Reads state once without subscribing | Button taps, dispatching actions |
| **`ref.listen(p, cb)`**| `Widget.build()`, `Notifier.build()` | Executes side-effect callback without rebuilding | Showing SnackBars, dialogs, route push |
| **`ref.watch(p.select(cb))`**| `Widget.build()` | Rebuilds only when selected sub-property changes | Optimizing high-frequency rebuilds |

---

## 5. Managing Asynchronous State with `AsyncValue`

### Q6: How do you consume `AsyncValue` in the UI?
**Answer:**
Using `.when()` or `.maybeWhen()`:

```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  final state = ref.watch(userRepositoryNotifierProvider('google'));

  return state.when(
    data: (repos) => ListView.builder(
      itemCount: repos.length,
      itemBuilder: (ctx, i) => ListTile(title: Text(repos[i].name)),
    ),
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (err, stack) => Center(child: Text('Error: $err')),
  );
}
```

---

## 6. `keepAlive: true` vs Auto-Dispose & Riverpod Lifecycle

### Q7: How does auto-disposal work in Riverpod 3.0?
**Answer:**
- By default, `@riverpod` providers are **auto-disposed** when the last listening widget unmounts.
- To keep a provider alive permanently across the app lifecycle, specify `@Riverpod(keepAlive: true)`.
- Use `ref.onDispose(() => controller.dispose())` to clean up resources when the provider is destroyed.

---

## 7. Unit Testing Notifiers with `ProviderContainer`

### Q8: How do you test a Riverpod provider in isolation?
**Answer:**
```dart
void main() {
  test('Counter increments correctly', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(counterProvider), 0);

    container.read(counterProvider.notifier).increment();
    expect(container.read(counterProvider), 1);
  });
}
```
