# Intermediate Level: Flutter Animations & Motion Design

This guide covers Flutter's animation system, controllers, tweens, and common animation patterns for creating smooth, engaging user experiences.

---

## Table of Contents

1. [Animation Fundamentals & `AnimationController`](#1-animation-fundamentals--animationcontroller)
2. [`Tween` & `CurvedAnimation`](#2-tween--curvedanimation)
3. [`vsync` and `TickerProvider` Explained](#3-vsync-and-tickerprovider-explained)
4. [`AnimatedBuilder` vs `AnimatedWidget`](#4-animatedbuilder-vs-animatedwidget)
5. [Implicit Animations (`AnimatedContainer`, `AnimatedOpacity`)](#5-implicit-animations-animatedcontainer-animatedopacity)
6. [`AnimatedSwitcher` & `Hero` Animations](#6-animatedswitcher--hero-animations)
7. [Custom Transitions & Page Route Animations](#7-custom-transitions--page-route-animations)

---

## 1. Animation Fundamentals & `AnimationController`

### Q1: What is an `AnimationController` and how does it work?
**Answer:**

**Live Interactive Example:** [lib/samples/intermediate/animation_controller_example.dart](../../../../lib/samples/intermediate/animation_controller_example.dart)

An **`AnimationController`** is the core engine that drives animations in Flutter. It generates values (typically 0.0 to 1.0) over a specified duration.

**Key responsibilities:**
- Produces animation values over time
- Controls playback (start, stop, reverse, repeat)
- Requires a `TickerProvider` (vsync) to sync with screen refresh rate

```dart
class _AnimatedBoxState extends State<AnimatedBox> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Create controller (0.0 to 1.0 over 2 seconds)
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this, // Provides ticker for frame sync
    );

    // Create animation that maps to specific values
    _animation = Tween<double>(begin: 0, end: 300).animate(_controller);

    // Start animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose(); // CRITICAL: Always dispose!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: _animation.value,
          height: _animation.value,
          color: Colors.blue,
        );
      },
    );
  }
}
```

**Common Controller Methods:**
- `forward()`: Play animation from start to end
- `reverse()`: Play animation from end to start
- `repeat()`: Loop animation continuously
- `reset()`: Reset to beginning (value = 0.0)
- `stop()`: Pause at current position
- `animateTo(value)`: Animate to specific value

---

## 2. `Tween` & `CurvedAnimation`

### Q2: What are Tweens and how do they work with Curves?
**Answer:**
**`Tween<T>`** (in-between) maps the controller's 0.0-1.0 range to meaningful values (colors, sizes, positions).

**`Curve`** modifies the animation's speed over time (easing functions).

```dart
// Basic Tween examples
final sizeTween = Tween<double>(begin: 50, end: 200);
final colorTween = ColorTween(begin: Colors.red, end: Colors.blue);
final offsetTween = Tween<Offset>(begin: Offset.zero, end: Offset(1.0, 0.0));

// Applying a Curve
_controller = AnimationController(duration: Duration(seconds: 1), vsync: this);

_animation = Tween<double>(begin: 0, end: 100).animate(
  CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut, // Slow start, fast middle, slow end
  ),
);
```

**Popular Curves:**
- `Curves.linear`: Constant speed
- `Curves.easeIn`: Slow start, fast end
- `Curves.easeOut`: Fast start, slow end
- `Curves.easeInOut`: Slow start, fast middle, slow end
- `Curves.bounceOut`: Bouncy landing effect
- `Curves.elasticOut`: Elastic spring effect
- `Curves.fastOutSlowIn`: Material Design standard curve

**Multiple Tweens Example:**
```dart
late Animation<double> _sizeAnimation;
late Animation<Color?> _colorAnimation;

@override
void initState() {
  super.initState();
  _controller = AnimationController(duration: Duration(seconds: 2), vsync: this);

  _sizeAnimation = Tween<double>(begin: 50, end: 200).animate(_controller);
  _colorAnimation = ColorTween(begin: Colors.red, end: Colors.blue).animate(_controller);

  _controller.repeat(reverse: true);
}

@override
Widget build(BuildContext context) {
  return AnimatedBuilder(
    animation: _controller,
    builder: (context, child) {
      return Container(
        width: _sizeAnimation.value,
        height: _sizeAnimation.value,
        color: _colorAnimation.value,
      );
    },
  );
}
```

---

## 3. `vsync` and `TickerProvider` Explained

### Q3: What is `vsync` and why is it required in AnimationController?
**Answer:**
**`vsync`** (vertical sync) synchronizes the animation with the device's screen refresh rate (typically 60fps or 120fps).

**Why it's critical:**
- Prevents animations from running when the widget is off-screen (saves battery)
- Synchronizes with the GPU's frame rendering pipeline
- Avoids wasted CPU cycles on invisible animations

**TickerProvider Mixins:**

**1. `SingleTickerProviderStateMixin`** - For ONE animation controller
```dart
class _MyWidgetState extends State<MyWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1));
  }
}
```

**2. `TickerProviderStateMixin`** - For MULTIPLE animation controllers
```dart
class _ComplexAnimationState extends State<ComplexAnimation> with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;

  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(vsync: this, duration: Duration(seconds: 1));
    _controller2 = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }
}
```

**Under the hood:**
When the widget is removed from the tree (`deactivate()`), the ticker automatically stops, preventing memory leaks and unnecessary work.

---

## 4. `AnimatedBuilder` vs `AnimatedWidget`

### Q4: When should you use `AnimatedBuilder` vs `AnimatedWidget`?
**Answer:**
Both rebuild only the necessary parts of the widget tree when the animation value changes.

**`AnimatedBuilder`** - More flexible, preferred for most cases
```dart
AnimatedBuilder(
  animation: _controller,
  builder: (context, child) {
    return Transform.rotate(
      angle: _controller.value * 2 * pi,
      child: child, // This child is NOT rebuilt every frame
    );
  },
  child: ExpensiveWidget(), // Built once, reused
)
```

**`AnimatedWidget`** - Cleaner for reusable animated components
```dart
class SpinningLogo extends AnimatedWidget {
  const SpinningLogo({Key? key, required Animation<double> animation})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Transform.rotate(
      angle: animation.value * 2 * pi,
      child: FlutterLogo(size: 100),
    );
  }
}

// Usage
SpinningLogo(animation: _controller)
```

**When to use which:**
- **Use `AnimatedBuilder`**: General-purpose animations, inline animations
- **Use `AnimatedWidget`**: Creating reusable animated components

---

## 5. Implicit Animations (`AnimatedContainer`, `AnimatedOpacity`)

### Q5: What are Implicit Animations and when should you use them?
**Answer:**
**Implicit animations** automatically animate property changes without requiring an `AnimationController`. Perfect for simple UI transitions.

**Common Implicit Animation Widgets:**

**`AnimatedContainer`** - Animates size, color, padding, decoration changes
```dart
class _ToggleBoxState extends State<ToggleBox> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _isExpanded = !_isExpanded),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        width: _isExpanded ? 200 : 100,
        height: _isExpanded ? 200 : 100,
        color: _isExpanded ? Colors.blue : Colors.red,
        child: Center(child: Text('Tap me')),
      ),
    );
  }
}
```

**`AnimatedOpacity`** - Fade in/out transitions
```dart
AnimatedOpacity(
  opacity: _isVisible ? 1.0 : 0.0,
  duration: Duration(milliseconds: 500),
  child: Text('Fading text'),
)
```

**`AnimatedPositioned`** - Must be inside a `Stack`
```dart
Stack(
  children: [
    AnimatedPositioned(
      duration: Duration(seconds: 1),
      left: _isMoved ? 100 : 0,
      top: _isMoved ? 100 : 0,
      child: Container(width: 50, height: 50, color: Colors.green),
    ),
  ],
)
```

**Other Implicit Animations:**
- `AnimatedAlign`
- `AnimatedPadding`
- `AnimatedRotation`
- `AnimatedScale`
- `AnimatedDefaultTextStyle`

**When to use:**
- Simple property transitions triggered by `setState()`
- No need for precise control over animation playback
- Cleaner code for basic UI state changes

---

## 6. `AnimatedSwitcher` & `Hero` Animations

### Q6: Explain `AnimatedSwitcher` and `Hero` animations.
**Answer:**

**`AnimatedSwitcher`** - Animates between different child widgets
```dart
class _CounterState extends State<Counter> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedSwitcher(
          duration: Duration(milliseconds: 300),
          transitionBuilder: (child, animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: Text(
            '$_count',
            key: ValueKey<int>(_count), // KEY IS CRITICAL!
            style: TextStyle(fontSize: 48),
          ),
        ),
        ElevatedButton(
          onPressed: () => setState(() => _count++),
          child: Text('Increment'),
        ),
      ],
    );
  }
}
```

**`Hero` Animations** - Shared element transitions between screens
```dart
// Screen 1 (List)
Hero(
  tag: 'profile-pic-${user.id}', // Unique tag
  child: CircleAvatar(backgroundImage: NetworkImage(user.avatarUrl)),
)

// Screen 2 (Detail)
Hero(
  tag: 'profile-pic-${user.id}', // SAME tag
  child: Image.network(user.avatarUrl, width: 300, height: 300),
)
```

When navigating between screens, Flutter automatically animates the widget with matching `tag` from its position/size on screen 1 to its position/size on screen 2.

**Hero Requirements:**
- Both screens must have a `Hero` widget with identical `tag`
- Tags must be unique within a single screen
- Works automatically with `Navigator` push/pop

---

## 7. Custom Transitions & Page Route Animations

### Q7: How do you create custom page transition animations?
**Answer:**
Override the default page route transition using `PageRouteBuilder`.

```dart
// Custom slide transition
Navigator.push(
  context,
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => DetailPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0); // Slide from right
      const end = Offset.zero;
      const curve = Curves.easeInOut;

      final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      final offsetAnimation = animation.drive(tween);

      return SlideTransition(position: offsetAnimation, child: child);
    },
    transitionDuration: Duration(milliseconds: 400),
  ),
);
```

**Common Transitions:**

**Fade:**
```dart
FadeTransition(opacity: animation, child: child)
```

**Scale:**
```dart
ScaleTransition(scale: animation, child: child)
```

**Rotation:**
```dart
RotationTransition(turns: animation, child: child)
```

**Slide + Fade Combo:**
```dart
SlideTransition(
  position: Tween<Offset>(begin: Offset(0, 0.1), end: Offset.zero).animate(animation),
  child: FadeTransition(opacity: animation, child: child),
)
```

**With AutoRoute (Declarative):**
```dart
@CustomAutoRouter(
  transitionsBuilder: TransitionsBuilders.slideLeft,
  durationInMilliseconds: 400,
)
class $AppRouter {}
```

---

**Summary: Animation Decision Tree**

```
Need animation?
├─ Simple property change? → Use Implicit Animations (AnimatedContainer, AnimatedOpacity)
├─ Switch between widgets? → Use AnimatedSwitcher
├─ Navigate between screens? → Use Hero or Custom PageRouteBuilder
└─ Complex/precise control? → Use AnimationController + AnimatedBuilder
```
