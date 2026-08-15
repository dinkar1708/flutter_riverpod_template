# InheritedWidget

## Purpose

InheritedWidget allows sharing data down the widget tree without passing it through every widget. It's the foundation for Theme, MediaQuery, and state management solutions like Provider and Riverpod.

---

## Objective

**Problem**: Passing data through many widget layers is tedious

```dart
// Without InheritedWidget
Parent(data) → Child1(data) → Child2(data) → DeepChild(data)
```

**Solution**: InheritedWidget makes data accessible to all descendants

```dart
// With InheritedWidget
InheritedWidget(data)
  ├─ Child1() → accesses data directly
  └─ Child2()
       └─ DeepChild() → accesses data directly
```

---

## Basic Structure

```dart
class AppState extends InheritedWidget {
  final int counter;

  const AppState({
    super.key,
    required this.counter,
    required super.child,
  });

  static AppState? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppState>();
  }

  @override
  bool updateShouldNotify(AppState oldWidget) {
    return oldWidget.counter != counter;
  }
}
```

---

## How to Use

### 1. Create InheritedWidget

```dart
class UserData extends InheritedWidget {
  final String userName;
  final String userId;

  const UserData({
    super.key,
    required this.userName,
    required this.userId,
    required super.child,
  });

  // Access method
  static UserData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UserData>();
  }

  // Notify when to rebuild
  @override
  bool updateShouldNotify(UserData oldWidget) {
    return oldWidget.userName != userName ||
           oldWidget.userId != userId;
  }
}
```

### 2. Wrap Widget Tree

```dart
UserData(
  userName: 'John',
  userId: '123',
  child: MyApp(),
)
```

### 3. Access from Descendants

```dart
class ProfileWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userData = UserData.of(context);
    return Text('Hello ${userData?.userName}');
  }
}
```

---

## Complete Example

```dart
class ThemeProvider extends InheritedWidget {
  final Color primaryColor;
  final Color accentColor;

  const ThemeProvider({
    super.key,
    required this.primaryColor,
    required this.accentColor,
    required super.child,
  });

  static ThemeProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ThemeProvider>();
  }

  @override
  bool updateShouldNotify(ThemeProvider oldWidget) {
    return oldWidget.primaryColor != primaryColor ||
           oldWidget.accentColor != accentColor;
  }
}

// Usage
ThemeProvider(
  primaryColor: Colors.blue,
  accentColor: Colors.orange,
  child: MaterialApp(
    home: HomePage(),
  ),
)

// Access in any descendant
class MyButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context);

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: theme?.primaryColor,
      ),
      child: Text('Button'),
    );
  }
}
```

---

## updateShouldNotify

Controls when to rebuild dependent widgets:

```dart
@override
bool updateShouldNotify(AppState oldWidget) {
  // Return true to rebuild, false to skip
  return oldWidget.counter != counter;
}
```

**Return true**: Dependent widgets rebuild
**Return false**: No rebuild, better performance

---

## With State Management

Combine InheritedWidget with StatefulWidget for mutable state:

```dart
class CounterProvider extends StatefulWidget {
  final Widget child;

  const CounterProvider({super.key, required this.child});

  @override
  State<CounterProvider> createState() => CounterProviderState();
}

class CounterProviderState extends State<CounterProvider> {
  int _counter = 0;

  void increment() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedCounter(
      counter: _counter,
      increment: increment,
      child: widget.child,
    );
  }
}

class _InheritedCounter extends InheritedWidget {
  final int counter;
  final VoidCallback increment;

  const _InheritedCounter({
    required this.counter,
    required this.increment,
    required super.child,
  });

  static _InheritedCounter? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<_InheritedCounter>();
  }

  @override
  bool updateShouldNotify(_InheritedCounter oldWidget) {
    return oldWidget.counter != counter;
  }
}

// Usage
CounterProvider(
  child: MaterialApp(
    home: HomePage(),
  ),
)

// Access
class CounterDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final inherited = _InheritedCounter.of(context);

    return Column(
      children: [
        Text('Count: ${inherited?.counter}'),
        ElevatedButton(
          onPressed: inherited?.increment,
          child: Text('Increment'),
        ),
      ],
    );
  }
}
```

---

## Built-in InheritedWidgets

Flutter uses InheritedWidget internally:

### Theme
```dart
Theme.of(context)  // InheritedWidget
```

### MediaQuery
```dart
MediaQuery.of(context)  // InheritedWidget
```

### Scaffold
```dart
Scaffold.of(context)  // InheritedWidget
```

---

## Common Questions

**Q: What's the purpose of InheritedWidget?**
A: Share data down the widget tree without passing through every widget.

**Q: When should I use InheritedWidget?**
A: When multiple widgets need access to the same data and they're not direct parent-child.

**Q: Is InheritedWidget the same as Provider?**
A: No, Provider is built on top of InheritedWidget but adds more features.

**Q: What's updateShouldNotify for?**
A: Controls when dependent widgets should rebuild - return true to rebuild, false to skip.

---

## Why Use InheritedWidget

1. **Avoid Prop Drilling**: Don't pass data through every widget
2. **Efficient Updates**: Only rebuilds widgets that need it
3. **Clean Code**: Descendants access data directly
4. **Foundation**: Powers Theme, MediaQuery, Provider

---

## Alternatives

- **Provider package**: Easier API built on InheritedWidget
- **Riverpod**: Modern state management
- **Bloc**: For complex state
- **GetX**: All-in-one solution

For most apps, use Provider or Riverpod instead of raw InheritedWidget.

---

## Code Reference

Live example: `lib/samples/intermediate/inherited_widget_example.dart`
