# Event Loop - Microtasks vs Event Queue

## Overview

Dart's event loop handles asynchronous operations. Understanding how it works helps you write efficient async code and avoid common pitfalls.

---

## Event Loop Structure

```
┌─────────────────────────┐
│    Microtask Queue      │  (High priority)
└─────────────────────────┘
           ↓
┌─────────────────────────┐
│     Event Queue         │  (Normal priority)
└─────────────────────────┘
```

**Order of execution**:
1. Run synchronous code
2. Process **all** microtasks
3. Process **one** event
4. Repeat from step 2

---

## Microtask Queue

**High priority** - runs before any events

**Created by**:
- `scheduleMicrotask()`
- `Future.microtask()`
- Completing Futures

**Example**:
```dart
void main() {
  scheduleMicrotask(() => print('Microtask 1'));
  scheduleMicrotask(() => print('Microtask 2'));
  print('Sync');
}

// Output:
// Sync
// Microtask 1
// Microtask 2
```

---

## Event Queue

**Normal priority** - runs after all microtasks

**Created by**:
- `Future.delayed()`
- `Future.then()`
- Timer
- I/O operations
- User interactions

**Example**:
```dart
void main() {
  Future(() => print('Event 1'));
  Future(() => print('Event 2'));
  print('Sync');
}

// Output:
// Sync
// Event 1
// Event 2
```

---

## Execution Order

```dart
void main() {
  print('1: Sync');

  Future(() => print('3: Event'));

  scheduleMicrotask(() => print('2: Microtask'));

  print('1: Sync again');
}

// Output:
// 1: Sync
// 1: Sync again
// 2: Microtask
// 3: Event
```

**Order**:
1. All sync code runs first
2. All microtasks run
3. Events run one at a time

---

## Complex Example

```dart
void main() {
  print('Start');

  // Event Queue
  Future(() {
    print('Future 1');
    scheduleMicrotask(() => print('Microtask inside Future 1'));
  });

  // Microtask Queue
  scheduleMicrotask(() {
    print('Microtask 1');
    Future(() => print('Future inside Microtask 1'));
  });

  // Event Queue
  Future(() => print('Future 2'));

  print('End');
}

// Output:
// Start
// End
// Microtask 1
// Future 1
// Microtask inside Future 1
// Future 2
// Future inside Microtask 1
```

**Explanation**:
1. Sync code: "Start", "End"
2. Microtask 1 (schedules Future inside)
3. Future 1 (schedules Microtask inside)
4. Microtask inside Future 1
5. Future 2
6. Future inside Microtask 1

---

## Future Types

### Future() - Event Queue
```dart
Future(() => print('Event queue'));
```

### Future.microtask() - Microtask Queue
```dart
Future.microtask(() => print('Microtask queue'));
```

### Future.delayed() - Event Queue (after delay)
```dart
Future.delayed(Duration(seconds: 1), () => print('After 1 second'));
```

### Future.value() - Microtask Queue
```dart
Future.value(42).then((value) => print('Microtask: $value'));
```

---

## Practical Examples

### Example 1: UI Update
```dart
void updateUI() async {
  print('Starting update');

  // Schedule microtask - runs before next frame
  scheduleMicrotask(() {
    print('Update calculated values');
  });

  // Schedule event - runs after microtasks
  Future(() {
    print('Refresh UI');
  });

  print('Update scheduled');
}

// Output:
// Starting update
// Update scheduled
// Update calculated values
// Refresh UI
```

### Example 2: API Call with Cache
```dart
Future<String> getData() async {
  // Check cache (microtask - fast)
  return await Future.microtask(() {
    if (hasCache()) {
      return getCachedData();
    }
    return null;
  }).then((cached) {
    if (cached != null) return cached;

    // Fetch from network (event - slower)
    return Future(() => fetchFromNetwork());
  });
}
```

---

## Common Pitfalls

### Pitfall 1: Infinite Microtasks
```dart
// BAD - blocks event queue
void infiniteMicrotasks() {
  scheduleMicrotask(() {
    print('Microtask');
    infiniteMicrotasks(); // Schedules another microtask
  });
}

// Event queue never runs
// UI freezes
```

### Pitfall 2: Wrong Priority
```dart
// BAD - using microtask for heavy work
scheduleMicrotask(() {
  performHeavyCalculation(); // Blocks event loop
});

// GOOD - use event queue
Future(() {
  performHeavyCalculation();
});
```

---

## When to Use Each

### Use Microtasks:
- Critical code that must run ASAP
- Before next event
- Before UI updates
- Very short operations

### Use Events (Future):
- Normal async operations
- API calls
- File I/O
- Heavy computations
- Most use cases

---

## Timer vs Future

### Timer
```dart
Timer(Duration(seconds: 1), () {
  print('Timer callback');
});
```

### Future.delayed
```dart
Future.delayed(Duration(seconds: 1), () {
  print('Future callback');
});
```

Both add to event queue after delay.

---

## async/await and Event Loop

```dart
Future<void> example() async {
  print('1: Before await');

  await Future.delayed(Duration(seconds: 1));

  print('2: After await');
}

// await pauses function execution
// Other code can run during delay
// Resumes after Future completes
```

---

## Common Questions

**Q: What runs first - microtask or event?**
A: Microtasks always run before events.

**Q: Can microtasks block the event queue?**
A: Yes, if you schedule infinite microtasks, events never run.

**Q: When should I use scheduleMicrotask?**
A: Rarely. Use Future() for most async operations.

**Q: Does await create a microtask?**
A: The continuation after await is scheduled as a microtask.

---

## Visual Summary

```
main() {
  print('A');                        // 1. Sync
  Future(() => print('C'));          // 4. Event
  scheduleMicrotask(() => print('B')); // 2. Microtask
  print('A2');                       // 1. Sync
  Future.microtask(() => print('B2')); // 3. Microtask
}

// Output: A, A2, B, B2, C
```

**Rule**: Sync → All Microtasks → One Event → Repeat

---

## Best Practices

1. Prefer `Future()` over `scheduleMicrotask()` for most cases
2. Never create infinite microtask loops
3. Use microtasks only for critical, fast operations
4. Keep microtasks short
5. Use event queue for normal async work

---

## References

- No live code example needed (conceptual topic)
- Related: `lib/samples/intermediate/future_vs_stream_example.dart`
