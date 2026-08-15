# Root/Wrapper Widgets

## What are Root Widgets?

Root widgets are the foundational widgets that wrap and provide structure to your Flutter app. They handle app-level configuration, layout structure, and common UI patterns.

---

## 1. Scaffold

**Purpose**: Provides basic Material Design app structure

**Key Features**:
- appBar - Top app bar
- body - Main content area
- bottomNavigationBar - Bottom navigation
- drawer - Side menu
- floatingActionButton - Floating action button
- bottomSheet - Bottom sheet
- backgroundColor - Background color

**Example**:
```dart
Scaffold(
  appBar: AppBar(title: Text('Home')),
  body: Center(child: Text('Content')),
  floatingActionButton: FloatingActionButton(
    onPressed: () {},
    child: Icon(Icons.add),
  ),
  drawer: Drawer(child: ListView(...)),
)
```

**When to use**: Almost every screen needs a Scaffold to provide standard Material Design structure.

---

## 2. SafeArea

**Purpose**: Avoids system UI intrusions (notches, status bar, navigation bar)

**Key Features**:
- Automatically adds padding to avoid system UI
- Works on all platforms (iOS notches, Android navigation)
- Can configure which sides to apply (top, bottom, left, right)

**Example**:
```dart
SafeArea(
  child: Column(
    children: [
      Text('This text avoids the notch'),
      // ... more widgets
    ],
  ),
)
```

**When to use**:
- When content might be hidden by notches or system UI
- Usually wrap the body of Scaffold
- Essential for full-screen layouts

---

## 3. MaterialApp

**Purpose**: Root widget that configures the entire app

**Key Features**:
- theme - App-wide theme (colors, fonts)
- darkTheme - Dark mode theme
- routes - Named route configuration
- initialRoute - Starting screen
- title - App title (appears in task switcher)
- debugShowCheckedModeBanner - Show/hide debug banner
- locale - Localization settings
- navigatorKey - Access Navigator from anywhere

**Example**:
```dart
MaterialApp(
  title: 'My App',
  theme: ThemeData(
    primarySwatch: Colors.blue,
    brightness: Brightness.light,
  ),
  darkTheme: ThemeData(
    brightness: Brightness.dark,
  ),
  home: HomePage(),
  routes: {
    '/settings': (context) => SettingsPage(),
    '/profile': (context) => ProfilePage(),
  },
)
```

**When to use**:
- Once at the very root of your app (in main.dart)
- Wraps your entire application
- Never use multiple MaterialApp widgets

---

## 4. Padding

**Purpose**: Adds spacing around child widget

**Key Features**:
- EdgeInsets.all(value) - Same padding on all sides
- EdgeInsets.symmetric(horizontal:, vertical:) - Different horizontal/vertical
- EdgeInsets.only(left:, top:, right:, bottom:) - Specific sides
- EdgeInsets.fromLTRB(left, top, right, bottom) - Explicit values

**Example**:
```dart
Padding(
  padding: EdgeInsets.all(16),
  child: Text('Padded text'),
)

Padding(
  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  child: TextField(),
)
```

**When to use**:
- Add space around any widget
- Separate content from edges
- Create breathing room in layouts

---

## 5. Center

**Purpose**: Centers child widget both horizontally and vertically

**Key Features**:
- Centers child in available space
- Simple, single-purpose widget
- No configuration needed

**Example**:
```dart
Center(
  child: Text('Centered text'),
)

Center(
  child: CircularProgressIndicator(),
)
```

**When to use**:
- Center content in available space
- Loading indicators
- Empty state messages
- Login forms

---

## 6. Container

**Purpose**: Combines common painting, positioning, and sizing widgets

**Key Features**:
- padding - Internal spacing
- margin - External spacing
- decoration - Background, borders, shadows
- width/height - Fixed dimensions
- constraints - Min/max width/height
- alignment - Align child inside Container
- color - Background color (use decoration for more control)

**Example**:
```dart
Container(
  padding: EdgeInsets.all(16),
  margin: EdgeInsets.all(8),
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(8),
    boxShadow: [
      BoxShadow(
        color: Colors.black26,
        blurRadius: 4,
        offset: Offset(2, 2),
      ),
    ],
  ),
  child: Text('Styled container'),
)
```

**When to use**:
- Need multiple styling properties (padding + decoration + margin)
- Create boxes with backgrounds, borders, shadows
- Size constraints
- Most versatile layout widget

---

## Common Patterns

### Pattern 1: Full App Structure
```dart
MaterialApp(
  home: Scaffold(
    appBar: AppBar(title: Text('Home')),
    body: SafeArea(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: YourContent(),
      ),
    ),
  ),
)
```

### Pattern 2: Centered Loading
```dart
Scaffold(
  body: Center(
    child: CircularProgressIndicator(),
  ),
)
```

### Pattern 3: Styled Card
```dart
Container(
  margin: EdgeInsets.all(8),
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
    boxShadow: [BoxShadow(...)],
  ),
  child: YourContent(),
)
```

---

## Interview Tips

**Q: When should I use Container vs Padding?**
- Use **Padding** when you only need spacing (simpler, more performant)
- Use **Container** when you need padding + decoration + sizing

**Q: Where does SafeArea go?**
- Usually inside Scaffold body
- Before your main content
- Can wrap entire Scaffold for full safety

**Q: Can I use multiple Scaffold widgets?**
- Yes, each screen can have its own Scaffold
- No, don't nest Scaffold inside Scaffold

**Q: MaterialApp vs Scaffold - what's the difference?**
- **MaterialApp**: Root of entire app (once in main.dart)
- **Scaffold**: Structure for each screen (multiple, one per screen)

---

## Code Reference

Live example: `lib/samples/beginner/root_widgets_example.dart`
