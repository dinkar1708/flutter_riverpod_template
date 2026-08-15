# Beginner Level: Dart & Flutter Fundamentals (Onboarding Guide)

This document is part of the **Engineering Knowledge Transfer & Mentorship Series**. It provides fundamental concepts, definitions, and model Q&As designed for junior engineers and onboarding developers.

---

## Table of Contents

1. [What is Flutter & Dart?](#1-what-is-flutter--dart)
2. [Dart Type System (`final`, `const`, `static`)](#2-dart-type-system-final-const-static)
3. [`Object` vs `dynamic` vs `var`](#3-object-vs-dynamic-vs-var)
4. [Sound Null Safety & Null-Aware Operators](#4-sound-null-safety--null-aware-operators)
5. [Functions, Named Parameters & `typedef`](#5-functions-named-parameters--typedef)
6. [Object-Oriented Concepts: Mixins, Extensions & Factory Constructors](#6-object-oriented-concepts-mixins-extensions--factory-constructors)
7. [Asynchronous Core: `Future` vs `Stream`](#7-asynchronous-core-future-vs-stream)
8. [Debugging with `assert()` & Compiler Tree Shaking](#8-debugging-with-assert--compiler-tree-shaking)
9. [Packages vs Plugins & `pubspec.yaml`](#9-packages-vs-plugins--pubspecyaml)
10. [Hot Reload vs Hot Restart](#10-hot-reload-vs-hot-restart)
11. [Build Modes: Debug, Profile & Release](#11-build-modes-debug-profile--release)
12. [Singleton Pattern in Dart](#12-singleton-pattern-in-dart)

---

## 1. What is Flutter & Dart?

### Q1: What is Flutter and why does it use Dart?
**Answer:**
- **Flutter**: An open-source UI toolkit created by Google for building natively compiled applications for mobile (iOS, Android), web, and desktop (macOS, Windows, Linux) from a single codebase.
- **Why Dart?**:
  1. **Dual Compilation**: Uses JIT (Just-In-Time) compilation during development for instant **Hot Reload**, and AOT (Ahead-Of-Time) compilation for high-performance native machine code in production.
  2. **Declarative Layouts**: Dart's syntax allows creating UI trees without needing a separate markup language (like XML or JSX).
  3. **Single-Threaded Event Loop**: Fast object allocation and generational garbage collection ideal for smooth 60fps/120fps UI rendering.

---

## 2. Dart Type System (`final`, `const`, `static`)

### Q2: What is the difference between `final`, `const`, and `static`?
**Answer:**
- **`final` (Runtime Constant)**: Can be assigned only once, but its value is calculated at runtime (e.g., `final now = DateTime.now();`).
- **`const` (Compile-time Constant)**: Value must be known at compile time (e.g., `const maxRetries = 3;`). Const objects are canonicalized in memory (reused).
- **`static` (Class-Level Variable/Method)**: Belongs to the class itself rather than individual instances. Shared across all objects of that class.

```dart
class ApiConfig {
  static const String baseUrl = 'https://api.example.com'; // Shared compile-time constant
  final DateTime initializedAt;                            // Runtime instance constant

  ApiConfig() : initializedAt = DateTime.now();
}
```

---

## 3. `Object` vs `dynamic` vs `var`

### Q3: How do `Object`, `dynamic`, and `var` differ in Dart?
**Answer:**
- **`var` (Type Inference)**: Dart infers the type at compile time. Once assigned (e.g., `var name = 'John'`), the type is fixed as `String`.
- **`dynamic` (Dynamic Typing)**: Disables static type checking. You can reassign any type to it and call any method; errors only appear at runtime.
- **`Object` / `Object?` (Base Type)**: The root class of all non-nullable Dart objects. Type-safe; you cannot call methods without an explicit `is` type check.

---

## 4. Sound Null Safety & Null-Aware Operators

### Q4: What is Sound Null Safety and what are the main null-aware operators?
**Answer:**
**Sound Null Safety** guarantees that non-nullable types cannot hold `null`, catching null reference errors at compile time.

| Operator | Name | Purpose | Example |
| :--- | :--- | :--- | :--- |
| `?.` | Null-Aware Access | Executes call only if target is not null. | `user?.profile?.avatarUrl` |
| `??` | If-Null / Coalescing | Returns right operand if left is null. | `name ?? 'Anonymous'` |
| `??=` | Null-Aware Assignment | Assigns value only if variable is null. | `cachedData ??= loadData()` |
| `!` | Null Assertion | Asserts to compiler that value is not null. | `snapshot.data!` |
| `late` | Late Initialization | Defers initialization until first access. | `late final String token;` |

---

## 5. Functions, Named Parameters & `typedef`

### Q5: Explain Positional Parameters, Named Parameters, and `typedef`.
**Answer:**
- **Positional Parameters `[ ]`**: Bound by their position in the argument list.
- **Named Parameters `{ }`**: Bound by parameter name. Can be optional or marked `required`.
- **`typedef` (Function Alias)**: Creates a reusable type alias for a specific function signature.

```dart
// Type alias for a callback receiving an ID and status
typedef OnStatusChanged = void Function(int id, bool isActive);

void registerHandler({required String name, required OnStatusChanged onStatusChanged}) {
  onStatusChanged(101, true);
}
```

---

## 6. Object-Oriented Concepts: Mixins, Extensions & Factory Constructors

### Q6: What are Mixins, Extensions, and Factory Constructors?
**Answer:**
- **Mixin (`mixin`)**: Reusable code plugged into class hierarchies without single-inheritance limits (`class User with Loggable`).
- **Extension Method (`extension on Type`)**: Adds custom methods to existing classes without subclassing.
- **Factory Constructor (`factory`)**: Can return a cached Singleton instance or subtype rather than always allocating a new object.

```dart
// Extension on String
extension StringUtils on String {
  bool get isValidEmail => RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
}
```

---

## 7. Asynchronous Core: `Future` vs `Stream`

### Q7: What is the difference between a `Future` and a `Stream`?
**Answer:**
- **`Future<T>`**: Represents a **single asynchronous value or error** delivered at a future time (e.g., an HTTP GET response).
- **`Stream<T>`**: Represents a **sequence of asynchronous events** emitted over time (e.g., WebSocket messages, Firebase database real-time sync, sensor data).
  - *Single-Subscription Stream*: Allowed only one listener.
  - *Broadcast Stream*: Allows multiple concurrent listeners (`stream.asBroadcastStream()`).

---

## 8. Debugging with `assert()` & Compiler Tree Shaking

### Q8: What is `assert()` and how does Flutter Tree Shaking work?
**Answer:**
- **`assert(condition, message)`**: Validates invariants during **debug development mode**. Completely stripped out and ignored in production release builds (zero runtime performance cost).
- **Flutter Tree Shaking**: The AOT compiler analyzes dependencies across the entire code graph and icon font packages, removing unused classes, functions, and icon glyphs from the final binary to minimize APK/IPA download size.

---

## 9. Packages vs Plugins & `pubspec.yaml`

### Q9: What is the difference between a Package and a Plugin in Flutter?
**Answer:**
- **Package**: Pure Dart code (e.g., `riverpod`, `dio`, `intl`).
- **Plugin**: Combines Dart code with native platform implementations (Kotlin/Swift/C++) using platform channels (e.g., `flutter_secure_storage`, `camera`, `path_provider`).

---

## 10. Hot Reload vs Hot Restart

### Q10: Explain the difference between Hot Reload and Hot Restart.
**Answer:**
- **Hot Reload (⚡️ sub-second)**: Injects updated source code into the running Dart VM and triggers a widget rebuild **preserving the current application state** (variables, form inputs, scroll position).
- **Hot Restart (🔄 1-2 seconds)**: Destroys and restarts the Dart VM, recompiling code and **resetting the application state** back to `main()`.

---

## 11. Build Modes: Debug, Profile & Release

### Q11: What are the three Flutter build modes and when should each be used?
**Answer:**
Flutter has three build modes, each optimized for different development stages:

**1. Debug Mode (Development)**
- **Command**: `flutter run` (default)
- **Features**:
  - JIT (Just-In-Time) compilation for fast Hot Reload
  - All assertions (`assert()`) enabled
  - Service extensions enabled (DevTools, debugger)
  - Observatory and debugging enabled
  - No code obfuscation or optimization
- **Performance**: Slower, larger binary size
- **Use for**: Active development, debugging, testing new features

**2. Profile Mode (Performance Testing)**
- **Command**: `flutter run --profile`
- **Features**:
  - AOT (Ahead-Of-Time) compilation for production-like performance
  - Service extensions enabled (Performance overlay, timeline)
  - DevTools performance profiling enabled
  - Assertions disabled
  - Some optimizations applied
- **Performance**: Near-production speed with profiling capabilities
- **Use for**: Performance benchmarking, identifying bottlenecks, frame rate analysis
- **Cannot use**: Emulators/Simulators (requires physical device)

**3. Release Mode (Production)**
- **Command**: `flutter build apk --release` or `flutter run --release`
- **Features**:
  - Full AOT compilation to native machine code
  - All debugging aids disabled
  - Maximum optimizations enabled
  - Assertions disabled
  - Smallest binary size
  - No debugger/DevTools connection
- **Performance**: Fastest execution, optimized for end users
- **Use for**: App Store/Play Store releases, production builds

**Comparison Table:**

| Feature | Debug | Profile | Release |
|---------|-------|---------|---------|
| Compilation | JIT | AOT | AOT |
| Hot Reload | ✅ Yes | ❌ No | ❌ No |
| Assertions | ✅ Enabled | ❌ Disabled | ❌ Disabled |
| DevTools | ✅ Full Access | ✅ Performance Only | ❌ Disabled |
| Optimization | ❌ None | ⚠️ Partial | ✅ Maximum |
| Binary Size | Large | Medium | Small |
| Performance | Slow | Fast | Fastest |

**Code Example - Detecting Build Mode:**
```dart
import 'package:flutter/foundation.dart';

void logMessage(String message) {
  if (kDebugMode) {
    print('[DEBUG] $message');
  } else if (kProfileMode) {
    print('[PROFILE] $message');
  } else if (kReleaseMode) {
    // Don't log in production
  }
}

Widget build(BuildContext context) {
  return Stack(
    children: [
      MyApp(),
      // Show debug banner only in debug mode
      if (kDebugMode)
        Positioned(
          top: 40,
          right: 10,
          child: Container(
            color: Colors.red,
            padding: EdgeInsets.all(8),
            child: Text('DEBUG MODE', style: TextStyle(color: Colors.white)),
          ),
        ),
    ],
  );
}
```

---

## 12. Singleton Pattern in Dart

### Q12: How do you implement the Singleton pattern in Dart?
**Answer:**
The **Singleton pattern** ensures that a class has only one instance throughout the app's lifetime. It's commonly used for services like database connections, API clients, or app configuration.

**Method 1: Factory Constructor (Recommended)**
```dart
class ApiClient {
  // Private static instance
  static final ApiClient _instance = ApiClient._internal();

  // Private constructor
  ApiClient._internal();

  // Public factory constructor returns the same instance
  factory ApiClient() {
    return _instance;
  }

  // Your methods
  Future<void> fetchData() async {
    print('Fetching data...');
  }
}

// Usage
void main() {
  final client1 = ApiClient();
  final client2 = ApiClient();

  print(identical(client1, client2)); // true - same instance!
}
```

**Method 2: Static Getter**
```dart
class DatabaseService {
  static DatabaseService? _instance;

  DatabaseService._();

  static DatabaseService get instance {
    _instance ??= DatabaseService._();
    return _instance!;
  }

  void query(String sql) {
    print('Executing: $sql');
  }
}

// Usage
DatabaseService.instance.query('SELECT * FROM users');
```

**Method 3: Late Initialization (Lazy Singleton)**
```dart
class Logger {
  static final Logger instance = Logger._();

  Logger._() {
    print('Logger initialized');
  }

  void log(String message) {
    print('[LOG] $message');
  }
}

// Usage
Logger.instance.log('App started');
```

**With Riverpod (Modern Approach)**
```dart
// Singleton provider - never disposed
@Riverpod(keepAlive: true)
ApiClient apiClient(ApiClientRef ref) {
  return ApiClient();
}

// Usage in widget
final client = ref.read(apiClientProvider);
```

**When to Use Singletons:**
- ✅ Database connections
- ✅ API clients (Dio instance)
- ✅ App configuration
- ✅ Analytics/logging services
- ✅ Shared preferences wrapper
- ❌ **Avoid for**: UI state, user data, session-specific data

**Thread Safety Note:**
Dart is single-threaded (event loop), so the above implementations are thread-safe within the main isolate. For multi-isolate apps, each isolate gets its own singleton instance.
