# Memory Leak: Timers and Streams

## Purpose

Timers and Streams continue running in the background even after widgets are disposed. Cancelling them prevents unnecessary CPU usage and memory retention.

**DevTools to verify:** Memory tab OR debug logs

**When does this happen?**
- Using Timer.periodic() for polling, auto-refresh, countdowns
- Using Stream.listen() for real-time data, websockets, database listeners
- Common in: Live updates, chat apps, real-time dashboards, background tasks

**Rule:** Timers and StreamSubscriptions must be cancelled in `dispose()`.

---

## Pattern 1: Timers

```dart
// WRONG - Timer keeps running
class _MyWidgetState extends State<MyWidget> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() { /* ... */ });
    });
  }
  // Missing timer.cancel()
}

// RIGHT - Cancel in dispose
@override
void dispose() {
  _timer.cancel();
  super.dispose();
}
```

### Real Console Output

```
Opening WRONG example - timer never stops
[LEAK] Starting timer that will NEVER stop!
[LEAK] Timer tick #1
[LEAK] Timer tick #2
[User navigates back]
[LEAK] Widget is being removed but timer is STILL RUNNING!
[LEAK] Timer will continue ticking in the background FOREVER!
[LEAK] Timer tick #3 (Widget is GONE!)
[LEAK] Timer tick #4
... continues forever ...
```

**Notice:** Timer keeps running even after widget is removed.

---

## Pattern 2: Streams

```dart
// WRONG - Stream keeps listening
class _MyWidgetState extends State<MyWidget> {
  late StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = someStream.listen((data) {
      setState(() { /* ... */ });
    });
  }
  // Missing subscription.cancel()
}

// RIGHT - Cancel in dispose
@override
void dispose() {
  _subscription.cancel();
  super.dispose();
}
```

### Real Console Output

```
Opening WRONG example - stream never cancelled
[LEAK] Creating stream subscription
[LEAK] Subscription created but will NEVER be cancelled!
[LEAK] Stream event received: 0
[LEAK] Stream event received: 1
[User navigates back]
[LEAK] Widget is being removed but stream is STILL LISTENING!
[LEAK] Stream will continue processing events FOREVER!
[LEAK] Stream event received: 2
... continues forever ...
```

**Notice:** Stream keeps emitting events after widget is removed.

---

## How to Confirm in DevTools Memory Tab

**Mode Options:**
- Debug mode: Can see console logs (timer/stream continuing)
- Profile mode: Required for Memory tab verification

**Open DevTools Memory Tab:**
1. Run: `flutter run --profile` (for Memory tab verification)
2. Open DevTools: http://localhost:9100
3. Click "Memory" tab

**Detection Steps:**
1. Click "Snapshot" button (baseline)
2. Navigate to timer/stream leak example
3. Navigate back
4. Click "GC" button (garbage collection)
5. Click "Snapshot" button again
6. Click "Diff" to compare snapshots

**Find the Leak:**
- Timer: Search "_TimerImpl"
- Stream: Search "StreamSubscription" or "_ControllerSubscription"
- Look for: Instance count > 0
- Also watch console - timer/stream keeps running after navigating back

**What to screenshot:**
- `timer_leak_diff.png` - Diff view showing leaked timer
- `timer_leak_console.png` - Console showing timer running after dispose
- `stream_leak_diff.png` - Diff view showing leaked stream
- Save to: `docs/technical/FAQ/screenshots/`

**Expected Results:**
- WRONG: Instance count > 0, console shows events after dispose
- RIGHT: Instance count = 0, console shows no events after dispose

---

## Code Examples

**Live examples:**
- Timer: `lib/samples/intermediate/memory-leak/timer_leak_example.dart`
- Stream: `lib/samples/intermediate/memory-leak/stream_leak_example.dart`

---

## Checklist

- [ ] Do I have Timer.periodic() or Timer()?
- [ ] Called timer.cancel() in dispose()?
- [ ] Do I have StreamSubscription?
- [ ] Called subscription.cancel() in dispose()?
- [ ] Verified console shows timer/stream stops?
- [ ] Verified in DevTools (instance count = 0)?
