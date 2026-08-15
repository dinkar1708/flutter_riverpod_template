# Performance: Unnecessary Widget Rebuilds

## Purpose

Rebuilding entire widget trees on every setState() wastes CPU and causes lag. Using `const` widgets and proper state management prevents unnecessary rebuilds.

**DevTools to verify:** Performance tab → Widget rebuild stats

---

## When does this happen?

- Using setState() in parent widget
- Not using `const` for static widgets
- Rebuilding lists without keys
- Passing callbacks that recreate on every build

**Symptom:** App feels sluggish, scrolling lags, animations stutter.

---

## The Problem

```dart
// WRONG - Rebuilds entire tree every time
setState(() => counter++);  // Rebuilds ALL children!
```

**What happens:**
- setState() called in parent
- Entire widget tree rebuilds
- Even static widgets (that don't change) rebuild
- Wasted CPU cycles
- Performance degradation

---

## The Solution

**Use `const` for static widgets:**

```dart
// RIGHT - Only counter Text rebuilds
setState(() => counter++);

// Static widgets marked const don't rebuild
const Text('Static Label'),  // Never rebuilds!
Text('Count: $counter'),     // Only this rebuilds
```

---

## Common Patterns

### Pattern 1: Use const widgets

```dart
// WRONG
Text('Hello')  // Rebuilds every time

// RIGHT
const Text('Hello')  // Never rebuilds
```

### Pattern 2: Extract stateful parts

```dart
// WRONG - Entire widget rebuilds
Column(
  children: [
    ExpensiveWidget(),  // Rebuilds unnecessarily
    Text('$counter'),
  ],
)

// RIGHT - Only counter rebuilds
Column(
  children: [
    const ExpensiveWidget(),  // const = no rebuild
    Text('$counter'),
  ],
)
```

---

## How to Verify in DevTools

**Performance Tab → Widget Rebuild Stats:**

1. Open DevTools Performance tab
2. Enable "Track widget rebuilds"
3. Tap button that triggers setState
4. See which widgets rebuild

**BAD:** Many widgets show rebuild count
**GOOD:** Only necessary widgets rebuild

---

## Rule

**If it doesn't change → make it `const`**

---

## Checklist

- [ ] Used `const` for static widgets?
- [ ] Extracted changing parts to separate widgets?
- [ ] Used proper state management (Riverpod)?
- [ ] Checked rebuild count in DevTools?
- [ ] App feels smooth?

---

## Code Example

**Live example:** `lib/samples/intermediate/performance/widget_rebuild_example.dart`

**Test it:**
1. Open "Widget Rebuilds" from samples
2. Try BAD example - see rebuild count increase
3. Try GOOD example - only counter rebuilds
4. Check DevTools to see difference

---

## Console Logs

**BAD example (all widgets rebuild):**
```
[WRONG] Calling setState - ALL widgets will rebuild!
[WRONG] Building entire widget tree...
[WRONG] Static header rebuilt 2 times (should be 1!)
[WRONG] Static footer rebuilt 2 times (should be 1!)
[WRONG] Static widgets rebuilt unnecessarily!
[WRONG] Wasted CPU cycles rebuilding widgets that never change!
```

**GOOD example (only counter rebuilds):**
```
[GOOD] Calling setState - only counter widget rebuilds!
[GOOD] Building widget tree (const widgets skip rebuild)...
[GOOD] const header rebuilt 1 times (should stay 1!)
[GOOD] const footer rebuilt 1 times (should stay 1!)
[GOOD] const widgets skipped rebuild!
[GOOD] CPU saved by not rebuilding static widgets!
```
