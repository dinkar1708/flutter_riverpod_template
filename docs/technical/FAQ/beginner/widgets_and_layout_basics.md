# Beginner Level: Flutter Widgets & Layout Mechanics (Onboarding Guide)

This guide covers fundamental Flutter UI building blocks, widget lifecycles, and layout rules for onboarding developers.

---

## Table of Contents

1. [StatelessWidget vs StatefulWidget](#1-statelesswidget-vs-statefulwidget)
2. [StatefulWidget Lifecycle in Detail](#2-statefulwidget-lifecycle-in-detail)
3. [`didUpdateWidget()` vs `didChangeDependencies()`](#3-didupdatewidget-vs-didchangedependencies)
4. [Understanding `BuildContext` & the `mounted` Check](#4-understanding-buildcontext--the-mounted-check)
5. [`MaterialApp` vs `CupertinoApp` vs `WidgetsApp`](#5-materialapp-vs-cupertinoapp-vs-widgetsapp)
6. [Layout Essentials: `Row`, `Column`, `Expanded` & `Flexible`](#6-layout-essentials-row-column-expanded--flexible)
7. [`SizedBox` vs `Container` & `AspectRatio`](#7-sizedbox-vs-container--aspectratio)
8. [`SafeArea`, `Padding`, `Margin` & `Visibility`](#8-safearea-padding-margin--visibility)
9. [`resizeToAvoidBottomInset` & Keyboard Handling](#9-resizetoavoidbottominset--keyboard-handling)
10. [`TextEditingController` Lifecycle](#10-texteditingcontroller-lifecycle)
11. [`NetworkImage` vs `Image.network`](#11-networkimage-vs-imagenetwork)
12. [Introduction to Slivers & `CustomScrollView`](#12-introduction-to-slivers--customscrollview)
13. [Widget Keys: When and Why](#13-widget-keys-when-and-why)
14. [`FutureBuilder` & `StreamBuilder` Essentials](#14-futurebuilder--streambuilder-essentials)
15. [`ValueNotifier` & `ChangeNotifier`](#15-valuenotifier--changenotifier)
16. [`MediaQuery` for Responsive Layouts](#16-mediaquery-for-responsive-layouts)
17. [`Positioned`, `Stack` & `FittedBox`](#17-positioned-stack--fittedbox)
18. [Modal Bottom Sheets & `Scaffold` Features](#18-modal-bottom-sheets--scaffold-features)
19. [Flutter Inspector & Debugging Tools](#19-flutter-inspector--debugging-tools)

---

## 1. StatelessWidget vs StatefulWidget

### Q1: What is the difference between `StatelessWidget` and `StatefulWidget`?
**Answer:**
- **`StatelessWidget`**: An immutable widget whose visual configuration does not change over time. It has no internal mutable state (e.g., `Text`, `Icon`, `Divider`).
- **`StatefulWidget`**: A widget that can alter its appearance dynamically in response to user interactions, timers, or asynchronous events. It creates a companion mutable `State` object that persists across widget rebuilds.

---

## 2. StatefulWidget Lifecycle in Detail

### Q2: Walk through the `StatefulWidget` lifecycle methods in execution order.
**Answer:**

**Live Interactive Example:** [lib/samples/beginner/lifecycle_methods_example.dart](../../../../lib/samples/beginner/lifecycle_methods_example.dart)

**Lifecycle Flow:**
1. createState() - Creates the persistent State object
2. initState() - Called once. Initialize controllers & listeners
3. didChangeDependencies() - Called when InheritedWidget (Theme/MediaQuery) changes
4. build() - Renders the widget tree (Called frequently)
5. didUpdateWidget() - Parent widget rebuilt with new properties (Optional)
6. setState() - Triggers synchronous rebuild schedule (Manual)
7. deactivate() - State temporarily removed from widget tree
8. dispose() - Called once. Destroy controllers, streams, and animations

**Real Execution Output (Tested):**
```
📱 [LifecycleExample] createState() called (before this)
[LifecycleExample] initState() - Called ONCE when widget is inserted into tree
   └─ Good for: Controllers, listeners, initial data fetch
🔄 [LifecycleExample] didChangeDependencies() - Called after initState and when InheritedWidget changes
   └─ Call count: 1
🎨 [LifecycleExample] build() - Building UI (call #1)
[User Action] setState() called - Counter: 1
   └─ This will trigger build() to re-render UI
🎨 [LifecycleExample] build() - Building UI (call #2)
🟢 [ChildWidget] initState() called
🎨 [ChildWidget] build() called
⬅️ [ChildWidget] Popping back to parent
[ChildWidget] dispose() - Child widget cleanup
⬅️ [User Action] Navigator.pop() called
   └─ This will trigger deactivate() then dispose()
[LifecycleExample] deactivate() - Widget being removed from tree
   └─ Called before dispose() during navigation pop
[LifecycleExample] dispose() - CLEANUP TIME!
   └─ Dispose controllers, cancel streams, remove listeners here
   └─ Widget will never be used again after this
```

**Memory Leak Warning:**
Forgetting to dispose controllers, timers, or streams causes memory leaks! These are **silent** - no error is thrown, but memory keeps growing until the app crashes.

**How to Detect Memory Leaks:**
Use Flutter DevTools Memory tab to find undisposed objects. See detailed guide: [Memory Leak Detection](../../advanced/security_and_performance_optimization.md#4-memory-leak-detection--devtools-snapshot-diffing)

**Interactive Memory Leak Examples:** [lib/samples/intermediate/memory_leak_example.dart](../../../../lib/samples/intermediate/memory_leak_example.dart)

---

## 3. `didUpdateWidget()` vs `didChangeDependencies()`

### Q3: When are `didUpdateWidget()` and `didChangeDependencies()` called?
**Answer:**
- **`didChangeDependencies()`**: Called immediately after `initState()` and whenever an **`InheritedWidget`** that this state depends on (via `context.dependOnInheritedWidgetOfExactType`) updates (e.g., user toggles Dark/Light theme, system locale changes).
- **`didUpdateWidget(covariant T oldWidget)`**: Called when the **parent widget rebuilds** and passes new constructor properties to this `StatefulWidget`, while Flutter reuses the existing `State` instance. Ideal for restarting animations or fetching new data when an ID argument changes.

---

## 4. Understanding `BuildContext` & the `mounted` Check

### Q4: What is `BuildContext` and why should you check `mounted` before calling `setState()`?
**Answer:**
- **`BuildContext`**: A handle to the widget's location within the Element Tree. It allows querying ancestor widgets (e.g., `Theme.of(context)`, `Navigator.of(context)`).
- **`mounted` check**: When an asynchronous task (`await apiCall()`) completes, the user might have already navigated away from the screen, unmounting the widget. Calling `setState()` or using context on an unmounted state throws an error.

```dart
Future<void> submitData() async {
  final result = await api.sendData();
  // Safe check before updating UI
  if (!mounted) return;
  setState(() {
    _status = result;
  });
}
```

---

## 5. `MaterialApp` vs `CupertinoApp` vs `WidgetsApp`

### Q5: Compare `WidgetsApp`, `MaterialApp`, and `CupertinoApp`.
**Answer:**
- **`WidgetsApp`**: The base root application widget providing routing, localization, and accessibility without any design-specific styling.
- **`MaterialApp`**: Wraps `WidgetsApp` and adds Google Material 3 theming, animations, scaffolds, typography, and Material components.
- **`CupertinoApp`**: Wraps `WidgetsApp` and provides Apple iOS design language styling, icons, and transitions.

---

## 6. Layout Essentials: `Row`, `Column`, `Expanded` & `Flexible`

### Q6: What are common mistakes with Expanded and unbounded height/width?
**Answer:**

**Live Examples:**
- TextField mistakes: [textfield_common_mistakes_example.dart](../../../../lib/samples/beginner/textfield_common_mistakes_example.dart)
- ListView mistakes: [expanded_listview_mistake_example.dart](../../../../lib/samples/beginner/expanded_listview_mistake_example.dart)

**Common Errors:**

1. **TextField in Row without Expanded** - Unbounded width error
2. **TextField in Expanded (Column) without maxLines** - Unbounded height error
3. **ListView in Column without Expanded** - "Vertical viewport was given unbounded height"

**Solutions:**
- Row + TextField: Wrap TextField with `Expanded`
- Column + TextField in Expanded: Set `maxLines: null` and `expands: true`
- Column + ListView: Wrap ListView with `Expanded` or `SizedBox(height: ...)`

### Q7: Differentiate between `MainAxisAlignment` and `CrossAxisAlignment`.
**Answer:**
- **In a `Row`**:
  - `mainAxisAlignment` aligns children **Horizontally** (left to right).
  - `crossAxisAlignment` aligns children **Vertically** (top to bottom).
- **In a `Column`**:
  - `mainAxisAlignment` aligns children **Vertically** (top to bottom).
  - `crossAxisAlignment` aligns children **Horizontally** (left to right).

### Q8: What is the difference between `Expanded` and `Flexible`?
**Answer:**
- **`Expanded`**: Forces its child to take **all available remaining space** (`FlexFit.tight`).
- **`Flexible`**: Allows its child to take **up to its needed size**, but no more than the remaining available space (`FlexFit.loose`).

---

## 7. `SizedBox` vs `Container` & `AspectRatio`

### Q8: When should you use `SizedBox`, `Container`, or `AspectRatio`?
**Answer:**
- **`SizedBox`**: Use when you only need fixed width/height spacing. It is lightweight, backed by a `const` constructor, and compiles directly into a single `RenderConstrainedBox`.
- **`Container`**: Use only when you need complex decorations (background color, gradients, borders, shadows, shape, margins, matrix transforms).
- **`AspectRatio`**: Forces a child widget to maintain a specific width-to-height ratio (e.g., `aspectRatio: 16 / 9` for video players) regardless of parent container size.

---

## 8. `SafeArea`, `Padding`, `Margin` & `Visibility`

### Q9: What is the purpose of `SafeArea`?
**Answer:**
`SafeArea` automatically insets its child with appropriate padding to prevent UI elements from being obstructed by system features (notches, dynamic island, status bar, home indicator bar).

---

## 9. `resizeToAvoidBottomInset` & Keyboard Handling

### Q10: What does `resizeToAvoidBottomInset` do in `Scaffold`?
**Answer:**
When set to `true` (default), the `Scaffold` automatically resizes its body height when the software keyboard appears, preventing text inputs from being covered by the on-screen keyboard.

---

## 10. `TextEditingController` Lifecycle

### Q11: How do you properly manage a `TextEditingController`?
**Answer:**
Always instantiate in `initState()` (or declare in state) and **always call `.dispose()`** in the `dispose()` lifecycle method to prevent severe memory leaks.

```dart
class _MyFormState extends State<MyForm> {
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose(); // Prevent memory leak!
    super.dispose();
  }
}
```

---

## 11. `NetworkImage` vs `Image.network`

### Q12: What is the difference between `NetworkImage` and `Image.network`?
**Answer:**
- **`NetworkImage`**: An `ImageProvider` object that fetches an image from a URL. It is **not a widget**; it is used inside widget properties (e.g., `CircleAvatar(backgroundImage: NetworkImage(url))` or `BoxDecoration(image: DecorationImage(image: NetworkImage(url)))`).
- **`Image.network`**: A **Widget** named constructor that builds a visual image element on screen, internally using `NetworkImage`.

---

## 12. Introduction to Slivers & `CustomScrollView`

### Q13: What is a Sliver and why are they used?
**Answer:**
A **Sliver** is a portion of a scrollable area that renders child items **lazily on-demand** as they enter the screen viewport.
- Used in `CustomScrollView` for collapsible headers (`SliverAppBar`), sticky headers, and unified scrolling containing both lists and grids.

---

## 13. Widget Keys: When and Why

### Q14: What are Keys in Flutter and when should you use them?
**Answer:**

**Live Interactive Example:** [lib/samples/beginner/keys_example.dart](../../../../lib/samples/beginner/keys_example.dart)

**Keys** help Flutter identify which widgets in a list have changed, been added, or been removed. They preserve state when widgets move around in the tree.

**Types of Keys:**
- **`ValueKey<T>`**: Uses a specific value (e.g., `ValueKey(user.id)`). Best for lists where each item has a unique ID.
- **`ObjectKey`**: Uses object identity for equality comparison.
- **`UniqueKey`**: Generates a unique key every time. Use when you want to force widget recreation.
- **`GlobalKey`**: Allows access to a widget's state from anywhere in the app. Use sparingly (can access form state, trigger animations, scroll to positions).

```dart
// Example: Reorderable list items maintain state
ListView.builder(
  itemCount: users.length,
  itemBuilder: (context, index) {
    return UserCard(
      key: ValueKey(users[index].id), // Preserves state when list reorders
      user: users[index],
    );
  },
)

// GlobalKey example: Access form state
final _formKey = GlobalKey<FormState>();

Form(
  key: _formKey,
  child: Column(children: [...]),
)

// Later in code:
if (_formKey.currentState?.validate() ?? false) {
  _formKey.currentState?.save();
}
```

**When to use:**
- Reorderable lists or animations
- Preserving scroll position or text input state
- Accessing widget state from outside the widget tree (GlobalKey)

---

## 14. `FutureBuilder` & `StreamBuilder` Essentials

### Q15: How do `FutureBuilder` and `StreamBuilder` work?
**Answer:**

**Live Interactive Example:** [lib/samples/beginner/futurebuilder_example.dart](../../../../lib/samples/beginner/futurebuilder_example.dart)

Both widgets rebuild automatically based on asynchronous data changes.

**`FutureBuilder<T>`**: Listens to a single asynchronous computation (e.g., API call).
**`StreamBuilder<T>`**: Listens to a continuous stream of events (e.g., WebSocket, real-time database).

```dart
// FutureBuilder example
FutureBuilder<User>(
  future: api.fetchUser(userId),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }
    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    }
    if (snapshot.hasData) {
      return Text('Hello ${snapshot.data!.name}');
    }
    return SizedBox.shrink();
  },
)

// StreamBuilder example
StreamBuilder<int>(
  stream: counterStream,
  initialData: 0,
  builder: (context, snapshot) {
    return Text('Count: ${snapshot.data}');
  },
)
```

**Connection States:**
- `none`: No connection to async source
- `waiting`: Actively waiting for data
- `active`: Stream is delivering data (Stream only)
- `done`: Future completed or Stream closed

**Note:** In modern Riverpod apps, `AsyncNotifier` + `AsyncValue` is preferred over `FutureBuilder` for better testability and state management.

---

## 15. `ValueNotifier` & `ChangeNotifier`

### Q16: What are `ValueNotifier` and `ChangeNotifier`?
**Answer:**
Lightweight state management solutions for simple local widget state.

**`ValueNotifier<T>`**: Holds a single value and notifies listeners when the value changes.
**`ChangeNotifier`**: Base class for models that notify listeners manually via `notifyListeners()`.

```dart
// ValueNotifier example
class CounterWidget extends StatefulWidget {
  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  final _counter = ValueNotifier<int>(0);

  @override
  void dispose() {
    _counter.dispose(); // Always dispose!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder<int>(
          valueListenable: _counter,
          builder: (context, value, child) {
            return Text('Count: $value');
          },
        ),
        ElevatedButton(
          onPressed: () => _counter.value++,
          child: Text('Increment'),
        ),
      ],
    );
  }
}

// ChangeNotifier example
class CartModel extends ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => List.unmodifiable(_items);

  void addItem(Product product) {
    _items.add(product);
    notifyListeners(); // Manually trigger rebuild
  }

  void removeItem(Product product) {
    _items.remove(product);
    notifyListeners();
  }
}
```

**When to use:**
- Simple counters, toggles, or form field coordination
- Small widgets that don't need global state
- Quick prototypes

**Modern alternative:** Riverpod's `Notifier` provides better testability and doesn't require `BuildContext`.

---

## 16. `MediaQuery` for Responsive Layouts

### Q17: How do you use `MediaQuery` to build responsive UIs?
**Answer:**

**Live Interactive Example:** [lib/samples/beginner/mediaquery_example.dart](../../../../lib/samples/beginner/mediaquery_example.dart)

`MediaQuery` provides information about the device screen size, orientation, padding, text scaling, and platform brightness.

```dart
@override
Widget build(BuildContext context) {
  final size = MediaQuery.sizeOf(context);
  final padding = MediaQuery.paddingOf(context);
  final orientation = MediaQuery.orientationOf(context);
  final brightness = MediaQuery.platformBrightnessOf(context);

  return Container(
    width: size.width * 0.8, // 80% of screen width
    padding: EdgeInsets.only(top: padding.top), // Safe area padding
    child: orientation == Orientation.portrait
        ? PortraitLayout()
        : LandscapeLayout(),
  );
}

// Responsive breakpoints
Widget build(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;

  if (width < 600) {
    return MobileLayout(); // Phone
  } else if (width < 900) {
    return TabletLayout(); // Tablet
  } else {
    return DesktopLayout(); // Desktop
  }
}
```

**Common Properties:**
- `size`: Screen dimensions (width, height)
- `padding`: Safe area insets (notch, status bar, home indicator)
- `viewInsets`: Keyboard height when visible
- `devicePixelRatio`: Physical pixels per logical pixel
- `orientation`: Portrait or landscape
- `textScaleFactor`: User's text size preference

**Performance tip:** Use specific methods like `MediaQuery.sizeOf(context)` instead of `MediaQuery.of(context)` to avoid unnecessary rebuilds.

---

## 17. `Positioned`, `Stack` & `FittedBox`

### Q18: Explain `Stack`, `Positioned`, and `FittedBox`.
**Answer:**

**`Stack`**: Overlays widgets on top of each other (z-axis layering).
**`Positioned`**: Positions a child widget absolutely within a `Stack` using top, bottom, left, right offsets.
**`FittedBox`**: Scales and positions its child to fit within available space while maintaining aspect ratio.

```dart
// Stack + Positioned example
Stack(
  children: [
    // Background image (bottom layer)
    Image.network('https://example.com/bg.jpg'),

    // Positioned overlay (top layer)
    Positioned(
      top: 20,
      right: 20,
      child: Icon(Icons.favorite, color: Colors.red),
    ),

    // Bottom-left badge
    Positioned(
      bottom: 10,
      left: 10,
      child: Container(
        padding: EdgeInsets.all(8),
        color: Colors.black54,
        child: Text('New', style: TextStyle(color: Colors.white)),
      ),
    ),
  ],
)

// FittedBox example
Container(
  width: 100,
  height: 50,
  child: FittedBox(
    fit: BoxFit.contain, // Scales text to fit container
    child: Text('This is a very long text that will scale'),
  ),
)
```

**BoxFit values:**
- `contain`: Entire widget fits inside, may have empty space
- `cover`: Fills entire container, may crop content
- `fill`: Stretches to fill, may distort aspect ratio
- `fitWidth` / `fitHeight`: Scale to match specific dimension

---

## 18. Modal Bottom Sheets & `Scaffold` Features

### Q19: How do you show a Modal Bottom Sheet?
**Answer:**
Use `showModalBottomSheet()` to display a bottom sheet that overlays the screen with a semi-transparent barrier.

```dart
void _showOptions(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Allow custom height
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Wrap content height
        children: [
          ListTile(
            leading: Icon(Icons.share),
            title: Text('Share'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.delete),
            title: Text('Delete'),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    ),
  );
}
```

### Q20: What are key features of the `Scaffold` widget?
**Answer:**
`Scaffold` provides the basic Material Design visual layout structure.

**Key properties:**
- `appBar`: Top app bar with title and actions
- `body`: Main content area
- `floatingActionButton`: Circular action button
- `bottomNavigationBar`: Bottom navigation tabs
- `drawer` / `endDrawer`: Side navigation drawers
- `bottomSheet`: Persistent bottom sheet
- `backgroundColor`: Background color
- `resizeToAvoidBottomInset`: Resize when keyboard appears (default: true)

```dart
Scaffold(
  appBar: AppBar(
    title: Text('My App'),
    actions: [
      IconButton(icon: Icon(Icons.search), onPressed: () {}),
    ],
  ),
  body: Center(child: Text('Content')),
  floatingActionButton: FloatingActionButton(
    onPressed: () {},
    child: Icon(Icons.add),
  ),
  drawer: Drawer(
    child: ListView(
      children: [
        DrawerHeader(child: Text('Menu')),
        ListTile(title: Text('Home')),
        ListTile(title: Text('Settings')),
      ],
    ),
  ),
)
```

**Showing SnackBars:**
```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('Item saved!'),
    action: SnackBarAction(label: 'Undo', onPressed: () {}),
  ),
);
```

---

## 19. Flutter Inspector & Debugging Tools

### Q21: How do you use Flutter Inspector and DevTools for debugging?
**Answer:**
**Flutter Inspector** helps visualize the widget tree, diagnose layout issues, and debug UI problems.

**How to open:**
- VS Code: Click "Flutter Inspector" tab or `Cmd+Shift+P` → "Flutter: Open DevTools"
- Android Studio: View → Tool Windows → Flutter Inspector
- Command line: `flutter run` then press `v` to open DevTools in browser

**Key Features:**

**1. Widget Inspector:**
- **Select Widget Mode**: Click widgets in app to highlight them in tree
- **Show Guidelines**: Display padding, margins, and alignment guides
- **Show Baselines**: Debug text alignment issues
- **Slow Animations**: Reduce animation speed to 0.1x for debugging

**2. Layout Explorer:**
- Visualize constraints and sizes
- See `BoxConstraints` passed down
- Debug overflow errors (yellow/black stripes)

**3. Performance Tab:**
- Frame rendering timeline
- Identify UI jank (frames taking >16ms)
- CPU profiler for expensive `build()` methods

**4. Memory Tab:**
- Detect memory leaks
- Heap snapshots
- Track widget instances

**Common Debug Commands:**
```dart
// Print widget tree to console
debugDumpApp();

// Print render tree
debugDumpRenderTree();

// Print layer tree
debugDumpLayerTree();

// Check if widget is mounted
if (!mounted) return;

// Debug mode check
if (kDebugMode) {
  print('This only runs in debug mode');
}
```

**Debug Paint:**
```bash
# Show all visual debug information
flutter run --debug-show-checked-mode-banner
```

**Hot Reload Tips:**
- Use `r` in terminal to hot reload
- Use `R` to hot restart
- Use `p` to show performance overlay
- Use `o` to toggle platform (iOS/Android)
