# BuildContext

## What is BuildContext?

BuildContext is a handle to the location of a widget in the widget tree. Every widget has a BuildContext, which is passed to the `build()` method.

Think of it as an "address" that helps you access parent widgets, navigate, show dialogs, access theme, and more.

---

## Common Uses

### 1. Accessing Theme
```dart
Widget build(BuildContext context) {
  final theme = Theme.of(context);
  return Container(
    color: theme.primaryColor,
    child: Text(
      'Hello',
      style: theme.textTheme.bodyLarge,
    ),
  );
}
```

### 2. Accessing MediaQuery (Screen Size)
```dart
Widget build(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final width = size.width;
  final height = size.height;

  return Text('Screen: $width x $height');
}
```

### 3. Navigation
```dart
// Navigate to new screen
Navigator.push(
  context,
  MaterialPageRoute(builder: (_) => SecondScreen()),
);

// Go back
Navigator.pop(context);

// Navigate with named route
Navigator.pushNamed(context, '/settings');
```

### 4. Showing Dialogs
```dart
// Show dialog
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text('Alert'),
    content: Text('This is a dialog'),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text('OK'),
      ),
    ],
  ),
);
```

### 5. Showing SnackBar
```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('Action completed!')),
);
```

---

## Common Errors and Solutions

### Error 1: Using context across async gaps

**WRONG:**
```dart
Future<void> loadData() async {
  await Future.delayed(Duration(seconds: 2));
  Navigator.pop(context); // May crash! Widget might be disposed
}
```

**RIGHT:**
```dart
Future<void> loadData() async {
  await Future.delayed(Duration(seconds: 2));
  if (mounted) {
    Navigator.pop(context); // Safe - checks if widget still exists
  }
}
```

### Error 2: Wrong context for Scaffold features

**WRONG:**
```dart
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Page')),
      body: ElevatedButton(
        onPressed: () {
          // This context is above Scaffold!
          Scaffold.of(context).openDrawer();
        },
        child: Text('Open Drawer'),
      ),
    );
  }
}
```

**RIGHT (Solution 1 - Builder):**
```dart
class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Page')),
      body: Builder(
        builder: (context) {
          // This context is inside Scaffold!
          return ElevatedButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            child: Text('Open Drawer'),
          );
        },
      ),
    );
  }
}
```

**RIGHT (Solution 2 - ScaffoldMessenger):**
```dart
// For SnackBars, use ScaffoldMessenger instead
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('Message')),
);
```

---

## Common Questions

**Q: What is BuildContext?**
A: Handle to location of a widget in the widget tree. Used to access parent widgets, theme, media query, navigator.

**Q: Why do we need BuildContext?**
A: To traverse the widget tree and access inherited data from parent widgets (theme, media query, etc.)

**Q: Can I use BuildContext after async operations?**
A: Not directly. Always check `if (mounted)` before using context after `await`.

**Q: What's the difference between context in StatelessWidget and StatefulWidget?**
A: Both receive context in `build()`. StatefulWidget can also access it via `this.context` in State class methods.

---

## Console Logs

When running the example:

```
[BuildContext] Accessing theme via context
[BuildContext] Screen size: 392.0 x 800.0
[BuildContext] Navigating via Navigator.of(context)
[BuildContext] Popping screen via Navigator.pop(context)
[BuildContext] Showing SnackBar via ScaffoldMessenger.of(context)
```

---

## Code Reference

Live example: `lib/samples/beginner/buildcontext_example.dart`
