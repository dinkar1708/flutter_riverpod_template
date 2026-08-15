# Keyboard Handling

## Purpose

When keyboard appears, it can hide TextField and other input widgets. Proper keyboard handling ensures content scrolls up automatically so users can see what they're typing.

---

## When does this happen?

- TextField at bottom of screen
- Forms with multiple input fields
- Chat input, comment sections, search bars
- Login/signup forms
- Any screen with TextField in lower half

**Symptom:** Keyboard appears and hides the TextField - user can't see what they're typing.

---

## The Problem

```dart
// WRONG - TextField gets hidden by keyboard
Scaffold(
  body: Column(
    children: [
      SomeContent(),
      Spacer(),
      TextField(), // Gets hidden when keyboard appears
    ],
  ),
)
```

---

## The Solution

**Wrap content in SingleChildScrollView:**

```dart
// RIGHT - Content scrolls up when keyboard appears
Scaffold(
  resizeToAvoidBottomInset: true, // Default is true
  body: SingleChildScrollView(
    child: Column(
      children: [
        SomeContent(),
        TextField(), // Will scroll into view
      ],
    ),
  ),
)
```

---

## Common Mistakes

1. **Using Expanded/Flexible** - Doesn't help with keyboard
2. **Setting resizeToAvoidBottomInset: false** - Prevents auto-handling
3. **Fixed height containers** - Blocks scrolling

---

## How to Verify

1. Run app on device or simulator
2. Tap TextField at bottom of screen
3. Keyboard should appear
4. TextField should scroll into view above keyboard
5. You should see what you're typing

---

## Checklist

- [ ] Wrapped content in SingleChildScrollView?
- [ ] Set resizeToAvoidBottomInset: true (or default)?
- [ ] Removed fixed heights that prevent scrolling?
- [ ] Tested on device with keyboard appearing?
- [ ] TextField scrolls into view when tapped?

---

## Code Example

**Live example:** `lib/samples/beginner/keyboard_handling_example.dart`

**Test it:**
1. Open "Keyboard Handling" from samples
2. Try BAD example - tap bottom TextField → hidden by keyboard
3. Try GOOD example - tap bottom TextField → scrolls into view
4. See console logs showing keyboard state
