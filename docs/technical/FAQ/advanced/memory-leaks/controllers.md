# Memory Leak: Controllers

## Purpose

Controllers manage resources like listeners and native platform connections. Not disposing them keeps these resources alive in memory even after the widget is removed, causing memory leaks.

**DevTools to verify:** Memory tab (Diff Snapshots)

**When does this happen?**
- Every time you create a TextEditingController, ScrollController, AnimationController, etc.
- When you use TextField, ListView with controller, or custom animations
- Common in forms, search fields, scrollable lists, animated widgets

**Rule:** If it has a `.dispose()` method, call it in your widget's `dispose()` method.

**Controllers that need disposal:**
- TextEditingController
- AnimationController
- ScrollController
- PageController
- TabController
- VideoPlayerController
- TransformationController
- FocusNode

---

## The Pattern

```dart
// WRONG - Memory Leak
class _MyWidgetState extends State<MyWidget> {
  final _controller = TextEditingController();
  // Missing dispose()
}

// RIGHT - Properly Disposed
@override
void dispose() {
  _controller.dispose();
  super.dispose();
}
```

---

## Real Console Output

```
Opening WRONG example
[LEAK] TextEditingController created - ID: 324656447
[LEAK] This controller will NEVER be disposed!
[User navigates back]
[LEAK] Widget is being removed but controller is NOT disposed!
[LEAK] Controller 324656447 will stay in memory FOREVER!
```

**Notice:** No error thrown. Controller stays in memory consuming resources.

---

## How to Confirm in DevTools Memory Tab

**Important:** Use profile mode for accurate memory profiling. Debug mode has extra retained objects.

**Open DevTools Memory Tab:**
1. Run: `flutter run --profile` (NOT debug mode!)
2. Open DevTools: http://localhost:9100
3. Click "Memory" tab (top menu)
4. Click "Diff Snapshots" tab (you'll see 3 tabs: Profile Memory, Diff Snapshots, Trace Instances)
5. Now you'll see icons at top left: ● (circle), 🗑️ (trash), ↕️ (up/down arrow)

**Detection Steps (Follow in order!):**

**SNAPSHOT 1 (Baseline):**
1. Click "Snapshot" button - Black circle icon (●) at top left
2. You'll see "main-1" appear in the left panel ✓ (You already did this!)

**Now open the leak example:**
3. In your app: Navigate to "Memory Leak Examples" → Open "BAD: Controller Leak"
4. In your app: Type something in the TextField
5. In your app: Press back button to return to main screen

**Clean up memory:**
6. In DevTools: Click "GC" button (trash can icon)
7. Wait 2 seconds

**SNAPSHOT 2 (After leak):**
8. In DevTools: Click "Snapshot" button (● circle icon) again
9. You'll see "main-2" appear below "main-1" in the left panel

**Compare the 2 snapshots:**
10. Click on "main-1" in the left panel
11. Then click on "main-2" in the left panel
12. Click "Diff" button (up/down arrow icon at top)
13. Now you'll see the difference table - classes that leaked!

**Find the Leak in Diff View:**
1. After clicking "Diff", you'll see a table with class names
2. In the search box at top, type: "TextEditingController"
3. You'll see a row like this:
   ```
   Class Name                  | Instances | Size
   TextEditingController      | 1         | 256 bytes
   ```
4. If "Instances" column shows count > 0 = LEAK!
5. Click on "TextEditingController" row to see which object leaked
6. Click "Retaining Path" tab to see what's holding it in memory

**What to screenshot:**
- `controller_leak_diff.png` - Diff view showing leaked controller
- `controller_leak_retaining_path.png` - Click object → Retaining Path tab
- Save to: `docs/technical/FAQ/screenshots/`

**Expected Results:**
- WRONG: Instance count = 1 or more (LEAK)
- RIGHT: Instance count = 0 (properly freed)

---

## Code Examples

**Live example:** `lib/samples/intermediate/memory-leak/controller_leak_example.dart`

### TextEditingController

```dart
// WRONG
class _BadState extends State<BadWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }
  // Missing dispose()
}

// RIGHT
@override
void dispose() {
  _controller.dispose();
  super.dispose();
}
```

### FocusNode

```dart
// WRONG
final _focusNode = FocusNode();
// Missing dispose()

// RIGHT
@override
void dispose() {
  _focusNode.dispose();
  super.dispose();
}
```

---

## Checklist

- [ ] Do I have any controllers?
- [ ] Called .dispose() on ALL of them?
- [ ] Tested navigating back multiple times?
- [ ] Verified in DevTools (instance count = 0)?
