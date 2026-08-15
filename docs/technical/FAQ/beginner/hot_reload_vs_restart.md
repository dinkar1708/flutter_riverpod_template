# Hot Reload vs Hot Restart

## Quick Comparison

| Feature | Hot Reload | Hot Restart |
|---------|------------|-------------|
| Speed | Fast (1-2 seconds) | Slower (3-5 seconds) |
| State | Preserved | Lost/Reset |
| When | UI changes | main() changes |
| Keyboard | Press "r" | Press "R" |

---

## Hot Reload

**What it does**: Injects updated code into running app while preserving state.

**Speed**: Very fast (1-2 seconds)

**State**: Preserved - variables, counters, text fields keep their values

**When to use**:
- Changing widget UI
- Updating text or styles
- Modifying colors, padding, margins
- Adding/removing widgets
- Changing layout structure

**Example**:
```dart
// Before Hot Reload
Text('Hello World')

// After Hot Reload - counter value preserved
Text('Hello Flutter')
```

---

## Hot Restart

**What it does**: Restarts the entire app from scratch, calling main() again.

**Speed**: Slower (3-5 seconds)

**State**: Lost - everything resets to initial values

**When to use**:
- Changes to main() function
- Changes to global variables
- Changes to initState()
- Enum changes
- When hot reload doesn't work

**Example**:
```dart
void main() {
  runApp(MyApp()); // Changes here need Hot Restart
}
```

---

## Keyboard Shortcuts

**Terminal shortcuts when running `flutter run`:**
- `r` - Hot Reload (lowercase)
- `R` - Hot Restart (uppercase)
- `q` - Quit app
- `h` - Help

---

## When Hot Reload Works

Hot Reload works for most UI changes:

```dart
// All these work with Hot Reload:
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Change this text'), // Works
        Container(
          color: Colors.blue, // Change color - Works
          padding: EdgeInsets.all(16), // Change padding - Works
          child: Icon(Icons.home), // Change icon - Works
        ),
      ],
    );
  }
}
```

---

## When Hot Reload Fails

Hot Reload does NOT work for:

### 1. Changes to main()
```dart
void main() {
  runApp(MyApp()); // Need Hot Restart
}
```

### 2. Global variables
```dart
final String appName = 'MyApp'; // Need Hot Restart

void main() {
  runApp(MyApp());
}
```

### 3. Enum changes
```dart
enum Status { active, inactive } // Need Hot Restart
```

### 4. initState() changes
```dart
@override
void initState() {
  super.initState();
  _counter = 10; // Need Hot Restart to see change
}
```

---

## State Preservation Example

### Hot Reload (State Preserved):
```dart
class _MyPageState extends State<MyPage> {
  int _counter = 0; // Current value: 5

  @override
  Widget build(BuildContext context) {
    return Text('Count: $_counter'); // Hot Reload - still shows 5
  }
}
```

### Hot Restart (State Lost):
```dart
class _MyPageState extends State<MyPage> {
  int _counter = 0; // Resets to 0

  @override
  Widget build(BuildContext context) {
    return Text('Count: $_counter'); // Hot Restart - shows 0
  }
}
```

---

## Best Practices

1. **Use Hot Reload for UI changes** - Faster development
2. **Use Hot Restart when Hot Reload fails** - If changes don't appear
3. **Test with Hot Restart before release** - Ensure app starts correctly
4. **Don't rely on Hot Reload for testing** - Some bugs only appear on fresh start

---

## Common Questions

**Q: When should I use Hot Reload vs Hot Restart?**
A: Use Hot Reload for UI changes. Use Hot Restart for main(), global variables, or initState() changes.

**Q: Why doesn't my change appear after Hot Reload?**
A: Some changes require Hot Restart (main(), globals, enums). Try pressing "R" instead of "r".

**Q: Does Hot Reload work in production?**
A: No, Hot Reload only works in debug mode during development.

**Q: Will Hot Reload preserve my text field input?**
A: Yes, Hot Reload preserves all state including text field values, scroll position, etc.

---

## Console Logs

When running the example:

```
[HOT RELOAD] Widget created at: 2024-01-15 10:30:45
[HOT RELOAD] Build called - counter: 0
[HOT RELOAD] Build called - counter: 1
[HOT RELOAD] Build called - counter: 2
```

After Hot Reload - counter value stays same.
After Hot Restart - counter resets to 0 and creation time changes.

---

## Code Reference

Live example: `lib/samples/beginner/hot_reload_example.dart`
