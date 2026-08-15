# Memory Leak Detection & Prevention

## Purpose

Memory leaks in Flutter are silent - they don't throw errors but consume memory until the app crashes with OOM (Out of Memory). This guide helps you identify, prevent, and fix common memory leak patterns.

---

## When to Worry About Memory Leaks?

**Always check when:**
- Using TextEditingController, AnimationController, ScrollController, etc.
- Using Timer.periodic() or Stream.listen()
- Calling addListener() on any object
- Using async operations with setState()
- Navigating between screens frequently
- App runs for extended periods (background services, long sessions)

**Symptoms of memory leaks:**
- App crashes with OOM after extended use
- App becomes slow over time
- Memory usage keeps increasing in DevTools

---

## Quick Overview

**5 out of 6 common leaks are SILENT (no error):**
1. Controllers not disposed - Silent
2. Timers not cancelled - Silent
3. StreamSubscriptions not cancelled - Silent
4. Listeners not removed - Silent
5. FocusNode not disposed - Silent
6. setState after dispose - **Throws error (only this one!)**

---

## Leak Patterns

1. [Controllers](controllers.md) - TextEditingController, AnimationController, ScrollController, etc.
2. [Timers & Streams](timers-and-streams.md) - Timer.periodic(), StreamSubscription
3. [Listeners](listeners.md) - addListener/removeListener
4. [Async Callbacks](async-callbacks.md) - setState after dispose, mounted checks

---

## DevTools Detection

**Debug vs Profile Mode:**
- Debug mode: Can see console logs and setState errors
- Profile mode: Required for DevTools Memory tab (accurate memory profiling)
- Recommendation: Use profile mode for memory leak verification

**Which DevTools Tab to Use:**
- Controllers: Memory tab
- Timers: Memory tab
- Streams: Memory tab
- Listeners: Memory tab
- Async callbacks: Console (not Memory tab!)

**Memory Tab Detection Steps:**
1. Run: `flutter run --profile`
2. Open DevTools: http://localhost:9100
3. Click "Memory" tab
4. Click "Snapshot" (baseline)
5. Navigate to leak example page
6. Navigate back
7. Click "GC" button (garbage collection)
8. Click "Snapshot" again
9. Click "Diff" to compare
10. Search for leaked objects
11. If count > 0 after navigating back = LEAK!

**Screenshot what to look for:**
- Class name in diff view
- Instance count > 0
- Delta showing +1 or more

---

## Quick Checklist

**Controllers:**
- [ ] Called .dispose() on all controllers?

**Timers:**
- [ ] Called timer.cancel() in dispose()?

**Streams:**
- [ ] Called subscription.cancel() in dispose()?

**Listeners:**
- [ ] Called removeListener() before dispose()?

**Async:**
- [ ] Checked if (mounted) before setState()?

**Testing:**
- [ ] Tested navigation back multiple times?
- [ ] Verified in DevTools Memory tab?

---

## Code Examples

Interactive examples: `lib/samples/intermediate/memory-leak/`

Each example has WRONG (leak) and RIGHT (fixed) versions with console logs.
