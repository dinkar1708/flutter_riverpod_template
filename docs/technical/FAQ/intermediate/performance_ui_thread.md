# Performance: UI Thread Blocking

## Purpose

Heavy computations on the UI thread cause jank (stuttering) and freeze the app. Using isolates keeps the UI responsive at 60fps.

**DevTools to verify:** Performance tab → Timeline

---

## When does this happen?

- Large JSON parsing (10,000+ items)
- Image processing (resize, compress, filters)
- Encryption/decryption
- Complex calculations
- Sorting/filtering large datasets

**Symptom:** UI freezes, animations stutter, app feels unresponsive.

---

## The Problem

```dart
// WRONG - Blocks UI thread for 2 seconds
void parseData() {
  // Heavy computation on UI thread
  final result = expensiveCalculation(); // UI freezes!
  setState(() => data = result);
}
```

**What happens:**
- UI thread blocked for 2 seconds
- Screen freezes
- Animations stop
- User taps don't respond
- Frame rate drops from 60fps to 0fps

---

## The Solution

**Use `compute()` to run work on separate isolate:**

```dart
// RIGHT - Runs on separate isolate, UI stays smooth
Future<void> parseData() async {
  // Runs on separate thread
  final result = await compute(expensiveCalculation, inputData);
  if (!mounted) return;
  setState(() => data = result);
}
```

---

## How to Verify in DevTools

**Performance Tab → Timeline:**

**BAD example (UI blocked):**
1. Tap "Run Heavy Task"
2. Open DevTools Performance tab
3. See red/yellow bars in frame chart (jank!)
4. Frame time > 16ms (below 60fps)
5. UI thread shows long-running task

**GOOD example (using isolate):**
1. Tap "Run with Isolate"
2. Open DevTools Performance tab
3. See green bars (smooth!)
4. Frame time < 16ms (60fps maintained)
5. Work happens off UI thread

---

## Rule

**If operation takes > 16ms → Use isolate**

16ms = 1 frame at 60fps. Anything longer causes jank.

---

## Checklist

- [ ] Heavy computation moved to isolate?
- [ ] Used `compute()` or `Isolate.spawn()`?
- [ ] Checked `mounted` before setState after async?
- [ ] Tested in DevTools Performance tab?
- [ ] Frame rate stays at 60fps?

---

## Code Example

**Live example:** `lib/samples/intermediate/performance/ui_thread_blocking_example.dart`

**Test it:**
1. Open "UI Thread Blocking" from samples
2. Try BAD example - UI freezes for 2 seconds
3. Try GOOD example - UI stays smooth
4. Check DevTools Performance tab to see difference

---

## Console Logs

**BAD example (UI frozen):**
```
🔴 [WRONG] Starting heavy task on UI thread...
🔴 [WRONG] UI will FREEZE for ~2 seconds!
🔴 [WRONG] Task completed in 262ms
🔴 [WRONG] UI was FROZEN during this time!
💀 [WRONG] User could not interact with app!
```

**GOOD example (UI smooth):**
```
✅ [GOOD] Starting heavy task on separate isolate...
✅ [GOOD] UI will stay RESPONSIVE!
✅ [GOOD] Task completed in 260ms
✅ [GOOD] UI remained SMOOTH during calculation!
✅ [GOOD] User could still interact with app!
```
