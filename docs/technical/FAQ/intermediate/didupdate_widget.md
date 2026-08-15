# didUpdateWidget Lifecycle Method

## Purpose

`didUpdateWidget()` is called when the parent widget reconfigures the child widget with new parameters. Use it to react to changes in widget properties.

---

## When It's Called

```
Parent changes → didUpdateWidget() → build()
```

**Not called on first build** - only `initState()` runs first time.

---

## Basic Usage

```dart
class MyWidget extends StatefulWidget {
  final int value;

  const MyWidget({required this.value});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late int _internalValue;

  @override
  void initState() {
    super.initState();
    _internalValue = widget.value;  // Initialize from widget
  }

  @override
  void didUpdateWidget(MyWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Compare old vs new
    if (oldWidget.value != widget.value) {
      _internalValue = widget.value;  // Update internal state
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text('Value: $_internalValue');
  }
}
```

---

## Lifecycle Order

### First Build:
```
1. initState()
2. build()
```

### Parent Changes:
```
1. didUpdateWidget(oldWidget)
2. build()
```

### Widget Removed:
```
1. dispose()
```

---

## Common Use Cases

### Use Case 1: Update Internal State
```dart
@override
void didUpdateWidget(CounterWidget oldWidget) {
  super.didUpdateWidget(oldWidget);

  if (oldWidget.initialCount != widget.initialCount) {
    setState(() {
      _count = widget.initialCount;
    });
  }
}
```

### Use Case 2: Re-initialize Resources
```dart
@override
void didUpdateWidget(VideoPlayer oldWidget) {
  super.didUpdateWidget(oldWidget);

  if (oldWidget.videoUrl != widget.videoUrl) {
    _controller.dispose();
    _controller = VideoController(widget.videoUrl);
    _controller.initialize();
  }
}
```

### Use Case 3: Reset Animation
```dart
@override
void didUpdateWidget(AnimatedWidget oldWidget) {
  super.didUpdateWidget(oldWidget);

  if (oldWidget.duration != widget.duration) {
    _controller.duration = widget.duration;
    _controller.reset();
  }
}
```

---

## Complete Example

```dart
class UserProfile extends StatefulWidget {
  final String userId;
  final String userName;

  const UserProfile({
    required this.userId,
    required this.userName,
  });

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late String _displayName;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _displayName = widget.userName;
    _loadUserData();
  }

  @override
  void didUpdateWidget(UserProfile oldWidget) {
    super.didUpdateWidget(oldWidget);

    // User changed - reload data
    if (oldWidget.userId != widget.userId) {
      _displayName = widget.userName;
      _loadUserData();
    }

    // Name updated - update display
    if (oldWidget.userName != widget.userName) {
      setState(() {
        _displayName = widget.userName;
      });
    }
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    // Load data...
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return CircularProgressIndicator();
    }

    return Text(_displayName);
  }
}
```

---

## Comparing Old and New Values

```dart
@override
void didUpdateWidget(ConfigWidget oldWidget) {
  super.didUpdateWidget(oldWidget);

  // Single property
  if (oldWidget.theme != widget.theme) {
    _applyTheme(widget.theme);
  }

  // Multiple properties
  if (oldWidget.width != widget.width ||
      oldWidget.height != widget.height) {
    _updateSize(widget.width, widget.height);
  }
}
```

---

## With setState

If you need to trigger a rebuild after updating internal state:

```dart
@override
void didUpdateWidget(MyWidget oldWidget) {
  super.didUpdateWidget(oldWidget);

  if (oldWidget.value != widget.value) {
    setState(() {
      _internalValue = widget.value;
      _recalculate();  // Additional work
    });
  }
}
```

---

## Common Mistakes

### Mistake 1: Forgetting super.didUpdateWidget

```dart
// WRONG
@override
void didUpdateWidget(MyWidget oldWidget) {
  // Missing super call
  if (oldWidget.value != widget.value) {
    _update();
  }
}

// RIGHT
@override
void didUpdateWidget(MyWidget oldWidget) {
  super.didUpdateWidget(oldWidget);  // Required
  if (oldWidget.value != widget.value) {
    _update();
  }
}
```

### Mistake 2: Unnecessary setState

```dart
// WRONG - setState not needed
@override
void didUpdateWidget(MyWidget oldWidget) {
  super.didUpdateWidget(oldWidget);
  setState(() {});  // build() will be called anyway
}

// RIGHT - only use setState if changing internal state
@override
void didUpdateWidget(MyWidget oldWidget) {
  super.didUpdateWidget(oldWidget);
  if (oldWidget.value != widget.value) {
    setState(() {
      _recalculate();  // Changing internal state
    });
  }
}
```

### Mistake 3: Not Comparing Old vs New

```dart
// WRONG - updates even if value didn't change
@override
void didUpdateWidget(MyWidget oldWidget) {
  super.didUpdateWidget(oldWidget);
  _value = widget.value;  // Always updates
}

// RIGHT - only update if changed
@override
void didUpdateWidget(MyWidget oldWidget) {
  super.didUpdateWidget(oldWidget);
  if (oldWidget.value != widget.value) {
    _value = widget.value;
  }
}
```

---

## didUpdateWidget vs initState

| Aspect | initState | didUpdateWidget |
|--------|-----------|-----------------|
| When | First build only | Parent changes |
| Old widget | No access | Has oldWidget param |
| Frequency | Once | Multiple times |
| Use | Initialize | React to changes |

---

## Common Questions

**Q: When is didUpdateWidget called?**
A: When parent widget rebuilds with new parameters for this widget.

**Q: Do I need setState in didUpdateWidget?**
A: Only if you're updating internal state. build() is called automatically after didUpdateWidget.

**Q: What if I don't override didUpdateWidget?**
A: Widget still rebuilds with new parameters, but you can't react to the change.

**Q: Can I use async in didUpdateWidget?**
A: Yes, but don't await inside didUpdateWidget. Schedule async work instead.

---

## Best Practices

1. Always call `super.didUpdateWidget(oldWidget)` first
2. Compare old vs new values before updating
3. Use `setState` only if changing internal state
4. Don't do expensive work here - schedule it
5. Keep it focused on reacting to parameter changes

---

## Code Reference

Live example: `lib/samples/intermediate/didupdate_widget_example.dart`
