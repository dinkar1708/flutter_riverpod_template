# Memory Leak: Async Callbacks & setState After Dispose

## Purpose

Async operations can complete after a widget is disposed. Calling setState on a disposed widget throws an error and may cause crashes. The mounted check prevents this.

**DevTools to verify:** Console (NOT Memory tab!)

**When does this happen?**
- Using Future.delayed(), async/await, then() callbacks
- Making API calls, database queries, file operations
- Common in: Data fetching, image loading, delayed animations, background processing

**Rule:** Check `if (mounted)` before calling `setState()` in async operations.

**This is the ONLY leak pattern that throws a visible error!** All others are silent.

---

## The Pattern

```dart
// WRONG - setState after widget is disposed
class _MyWidgetState extends State<MyWidget> {
  void loadData() {
    Future.delayed(Duration(seconds: 3), () {
      setState(() { /* ... */ });  // Widget might be disposed!
    });
  }
}

// RIGHT - Check mounted before setState
void loadData() {
  Future.delayed(Duration(seconds: 3), () {
    if (mounted) {  // Check if still in tree
      setState(() { /* ... */ });
    }
  });
}
```

---

## Real Console Output

```
Opening WRONG example - setState after dispose
[LEAK] Starting async task...
[User navigates back before task completes]
[LEAK] Widget disposed but async task is still running!
[3 seconds later...]
[LEAK] Async task done, calling setState (might be disposed!)
[ERROR] setState FAILED! Widget was disposed!
[ERROR] setState() called after dispose(): _SetStateAfterDisposeExampleState
         (lifecycle state: defunct, not mounted)

This error happens if you call setState() on a State object for a widget
that no longer appears in the widget tree.
```

**Notice:** This is the ONLY leak that throws an error! All other leaks are silent.

---

## Why This is Different

| Pattern | Silent? | Error? |
|---------|---------|--------|
| Controllers not disposed | Silent | No |
| Timer not cancelled | Silent | No |
| StreamSubscription not cancelled | Silent | No |
| Listener not removed | Silent | No |
| setState after dispose | **NOT silent** | **YES** |

Flutter actively checks if a widget is mounted before allowing setState(). This is the only leak pattern Flutter can detect and warn you about.

---

## Why This Causes a Leak

Async callbacks capture `this` (the State object):

```dart
Future.delayed(Duration(seconds: 3), () {
  setState(() { /* ... */ });  // Closure captures State object
});
```

If the widget is disposed before the async completes:
```
Future → Closure → State object (disposed but not freed)
```

---

## How to Confirm in DevTools Console (Not Memory Tab!)

**This leak shows in CONSOLE, not Memory tab:**
- Debug mode: Works fine (you'll see the error)
- Profile mode: Also works

**Detection Steps:**
1. Run: `flutter run` (debug or profile mode)
2. Open your IDE's console or terminal
3. Navigate to async leak WRONG example
4. Navigate back immediately (before 3 seconds)
5. Wait 3 seconds
6. See Flutter ERROR in console!

**The Error:**
- Console shows: "setState() called after dispose()"
- Full Flutter error message appears
- This is the ONLY leak that throws an error

**What to screenshot:**
- `async_leak_console_error.png` - Console showing setState error (most important!)
- Save to: `docs/technical/FAQ/screenshots/`

**Expected Results:**
- WRONG: Flutter error in console
- RIGHT: No error, console shows "Widget disposed, skipping setState"

---

## Code Examples

**Live example:** `lib/samples/intermediate/memory-leak/async_leak_example.dart`

### HTTP Request Example

```dart
// WRONG
Future<void> fetchData() async {
  final response = await http.get(Uri.parse('https://api.example.com'));
  setState(() {  // Widget might be disposed!
    _data = response.body;
  });
}

// RIGHT
Future<void> fetchData() async {
  final response = await http.get(Uri.parse('https://api.example.com'));
  if (!mounted) return;  // Check before setState
  setState(() {
    _data = response.body;
  });
}
```

### Timer Callback Example

```dart
// WRONG
void startTimer() {
  Timer(Duration(seconds: 5), () {
    setState(() { /* ... */ });  // Widget might be disposed!
  });
}

// RIGHT
void startTimer() {
  Timer(Duration(seconds: 5), () {
    if (!mounted) return;  // Check before setState
    setState(() { /* ... */ });
  });
}
```

---

## Checklist

- [ ] Do I have async operations calling setState()?
- [ ] Checked if (mounted) before setState()?
- [ ] Tested navigating back quickly (before async completes)?
- [ ] Verified no "setState after dispose" error in console?
