# Const vs Final

## Quick Summary

| Feature | final | const |
|---------|-------|-------|
| When set | Runtime | Compile-time |
| Value known | At runtime | At compile-time |
| Widget rebuilds | Yes | No |
| Memory | New instance | Shared instance |

---

## final - Runtime Constant

**Definition**: Variable that can be set once at runtime and cannot be changed after.

**Examples**:
```dart
final name = "John";
final now = DateTime.now(); // OK - evaluated at runtime
final random = Random().nextInt(100); // OK - runtime value

// Can be set in constructor
class User {
  final String name;
  User(this.name); // Set once when object created
}
```

**Cannot reassign**:
```dart
final x = 10;
x = 20; // ERROR: Can't reassign final variable
```

---

## const - Compile-time Constant

**Definition**: Value must be known at compile-time and is deeply immutable.

**Examples**:
```dart
const pi = 3.14159; // Known at compile-time
const maxCount = 100; // Known at compile-time
const widget = Text('Hello'); // Widget can be const

const now = DateTime.now(); // ERROR: Not known at compile-time
const random = Random().nextInt(100); // ERROR: Evaluated at runtime
```

**Shared memory**:
```dart
const a = Point(1, 2);
const b = Point(1, 2);
print(identical(a, b)); // true - same instance in memory!

final c = Point(1, 2);
final d = Point(1, 2);
print(identical(c, d)); // false - different instances
```

---

## const in Flutter Widgets

### Without const (rebuilds every time)

```dart
class MyPage extends StatefulWidget {
  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Rebuilds on every setState
        Text('Static text'),
        Text('Counter: $_counter'),
      ],
    );
  }
}
```

Every time `setState()` is called, `Text('Static text')` is rebuilt even though it never changes.

### With const (does NOT rebuild)

```dart
class _MyPageState extends State<MyPage> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Does NOT rebuild - reuses existing widget
        const Text('Static text'),
        Text('Counter: $_counter'),
      ],
    );
  }
}
```

The `const Text('Static text')` is built once and reused on every rebuild.

---

## Performance Impact

**Example - Without const**:
```dart
setState(() {
  _counter++;
});

// Rebuilds:
// - Column widget
// - Text('Static') - Unnecessary!
// - Text('Counter: $_counter') - Necessary
```

**Example - With const**:
```dart
setState(() {
  _counter++;
});

// Rebuilds:
// - Column widget
// - const Text('Static') - Skipped!
// - Text('Counter: $_counter') - Necessary
```

---

## Rules for const

### Can use const when:
- All values are known at compile-time
- Widget parameters don't change
- No variables from runtime

```dart
const Text('Hello'); //
const Icon(Icons.home); //
const SizedBox(height: 20); //
const Padding(
  padding: EdgeInsets.all(16),
  child: Text('Hi'),
); //
```

### Cannot use const when:
- Using variables
- Values computed at runtime
- Widget parameters change

```dart
final name = 'John';
const Text(name); // name is final, not const

const Text('Count: $_counter'); // _counter changes

const DateTime.now(); // Runtime value
```

---

## Constructor Syntax

**const constructor**:
```dart
class MyWidget extends StatelessWidget {
  const MyWidget({super.key}); // const constructor

  @override
  Widget build(BuildContext context) {
    return const Text('Hello');
  }
}

// Can be used as const
const MyWidget(); // Works
```

**Non-const constructor**:
```dart
class MyWidget extends StatelessWidget {
  MyWidget(); // No const

  @override
  Widget build(BuildContext context) {
    return const Text('Hello');
  }
}

// Cannot be used as const
const MyWidget(); // ERROR
MyWidget(); // Works but not const
```

---

## Common Questions

**Q: What's the difference between final and const?**
A: final is runtime constant (set once), const is compile-time constant (immutable, shared memory).

**Q: Why use const widgets?**
A: Performance - const widgets skip rebuilds, saving memory and CPU.

**Q: Can I use const with variables?**
A: No, const values must be known at compile-time. Use final for variables.

**Q: When should I use const in Flutter?**
A: For any widget that doesn't change - Text, Icon, Padding, SizedBox, etc.

---

## Console Logs

When running the example and clicking counter:

```
🔄 [BUILD] Main build called - counter: 0
[REBUILD] _NonConstWidget rebuilt!
[NO REBUILD] _ConstWidget - only builds once!

🔄 [BUILD] Main build called - counter: 1
[REBUILD] _NonConstWidget rebuilt!
(notice: _ConstWidget does NOT print - it's not rebuilt!)

🔄 [BUILD] Main build called - counter: 2
[REBUILD] _NonConstWidget rebuilt!
(notice: _ConstWidget does NOT print - it's not rebuilt!)
```

---

## Best Practices

1. **Always use const for static widgets**
   ```dart
   const Text('Hello') //
   Text('Hello') // Wasteful
   ```

2. **Use const constructors when possible**
   ```dart
   class MyWidget extends StatelessWidget {
     const MyWidget({super.key}); //
   }
   ```

3. **Use final for class fields**
   ```dart
   class User {
     final String name; // Cannot change after creation
     User(this.name);
   }
   ```

4. **Check DevTools Performance tab**
   - See rebuild counts
   - Identify unnecessary rebuilds
   - Add const to reduce rebuilds

---

## Code Reference

Live example: `lib/samples/beginner/const_vs_final_example.dart`
