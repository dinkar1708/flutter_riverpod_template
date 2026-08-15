# Memory Leak: Listeners

## Purpose

Listeners create circular references. If not removed, the listener holds a reference to your widget's State, preventing garbage collection even after the widget is destroyed.

**DevTools to verify:** Memory tab (Retaining Path)

**When does this happen?**
- When you call addListener() on controllers, notifiers, or change notifiers
- Listening to text changes, scroll position, animation values
- Common in: Live search, scroll-based animations, form validation

**Rule:** Every `addListener()` needs a matching `removeListener()` in `dispose()`.

**Applies to:**
- ChangeNotifier.addListener()
- ValueNotifier.addListener()
- TextEditingController.addListener()
- AnimationController.addListener()

---

## The Pattern

```dart
// WRONG - Listener not removed
class _MyWidgetState extends State<MyWidget> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    print('Text: ${_controller.text}');
  }
  // Missing removeListener()
}

// RIGHT - Remove listener before dispose
@override
void dispose() {
  _controller.removeListener(_onTextChanged);  // Remove first
  _controller.dispose();                        // Then dispose
  super.dispose();
}
```

---

## Real Console Output

```
Opening WRONG example - listener not removed
[LEAK] TextEditingController created - ID: 940485227
[LEAK] Adding listener to controller...
[LEAK] Listener added but will NEVER be removed!
[LEAK] Listener triggered - Text: ""
[LEAK] Listener triggered - Text: "g"
[User navigates back]
[LEAK] Widget is being removed but listener is STILL ATTACHED!
[LEAK] Listener will keep the State object in memory FOREVER!
```

**Notice:** Listener holds a reference to the State object, preventing garbage collection.

---

## Why This Causes a Leak

When you call `addListener()`, the controller stores a reference to your callback. The callback captures `this` (the State object):

```
Controller → Listener callback → State object
```

Even after the widget is removed, the controller still holds this reference, keeping the State object in memory forever.

---

## How to Confirm in DevTools Memory Tab

**Important:** Use profile mode for accurate memory profiling.

**Open DevTools Memory Tab:**
1. Run: `flutter run --profile` (NOT debug mode!)
2. Open DevTools: http://localhost:9100
3. Click "Memory" tab

**Detection Steps:**
1. Click "Snapshot" button (baseline)
2. Navigate to listener leak example
3. Navigate back
4. Click "GC" button (garbage collection)
5. Click "Snapshot" button again
6. Click "Diff" to compare snapshots

**Find the Leak:**
- Search: Your State class name (e.g., "_ListenerLeakExampleState")
- Look for: Instance count > 0 (State should be 0 but it leaked!)
- Click object → "Retaining Path" tab
- See: Controller → _listeners → Closure → State object

**What to screenshot:**
- `listener_leak_diff.png` - Diff view showing leaked State
- `listener_leak_retaining_path.png` - Retaining path showing listener chain
- Save to: `docs/technical/FAQ/screenshots/`

**Expected Results:**
- WRONG: State instance count = 1 (leaked!)
- RIGHT: State instance count = 0 (properly freed)

---

## Code Examples

**Live example:** `lib/samples/intermediate/memory-leak/listener_leak_example.dart`

```dart
// WRONG
class _BadState extends State<BadWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_onTextChanged);  // LEAK!
  }

  void _onTextChanged() {
    print('Text: ${_controller.text}');
  }
  // Missing removeListener() and dispose()
}

// RIGHT
@override
void dispose() {
  _controller.removeListener(_onTextChanged);  // Remove first
  _controller.dispose();                        // Then dispose
  super.dispose();
}
```

---

## Common Mistake

```dart
// WRONG ORDER - This will crash!
@override
void dispose() {
  _controller.dispose();                       // Disposed first
  _controller.removeListener(_onTextChanged);  // Can't remove from disposed controller!
  super.dispose();
}

// RIGHT ORDER
@override
void dispose() {
  _controller.removeListener(_onTextChanged);  // Remove first
  _controller.dispose();                        // Then dispose
  super.dispose();
}
```

Always remove listeners BEFORE disposing the controller.

---

## Checklist

- [ ] Did I call .addListener() anywhere?
- [ ] Called .removeListener() BEFORE .dispose()?
- [ ] Tested navigating back multiple times?
- [ ] Verified State instance count = 0 in DevTools?
