# TextEditingController

## Purpose

TextEditingController manages the state of TextField widgets programmatically. It allows reading, modifying, and clearing text from code.

---

## Basic Usage

```dart
class _MyPageState extends State<MyPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();  // Important: prevent memory leak
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
    );
  }
}
```

---

## Common Operations

### 1. Read Text
```dart
String text = _controller.text;
print('Current text: $text');
```

### 2. Set Text
```dart
_controller.text = 'New text';
```

### 3. Clear Text
```dart
_controller.clear();
```

### 4. Listen to Changes
```dart
@override
void initState() {
  super.initState();
  _controller.addListener(() {
    print('Text changed: ${_controller.text}');
  });
}
```

---

## Complete Example

```dart
class MyForm extends StatefulWidget {
  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submitForm() {
    String name = _nameController.text;
    String email = _emailController.text;

    if (name.isEmpty || email.isEmpty) {
      print('Please fill all fields');
      return;
    }

    print('Name: $name, Email: $email');

    // Clear after submit
    _nameController.clear();
    _emailController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _nameController,
          decoration: InputDecoration(labelText: 'Name'),
        ),
        TextField(
          controller: _emailController,
          decoration: InputDecoration(labelText: 'Email'),
        ),
        ElevatedButton(
          onPressed: _submitForm,
          child: Text('Submit'),
        ),
      ],
    );
  }
}
```

---

## With Initial Value

```dart
final _controller = TextEditingController(text: 'Initial value');

// Or set later
@override
void initState() {
  super.initState();
  _controller.text = 'Initial value';
}
```

---

## Selection and Cursor

### Get Selection
```dart
TextSelection selection = _controller.selection;
print('Start: ${selection.start}, End: ${selection.end}');
```

### Set Selection
```dart
_controller.selection = TextSelection(
  baseOffset: 0,
  extentOffset: _controller.text.length,  // Select all
);
```

### Move Cursor
```dart
_controller.selection = TextSelection.fromPosition(
  TextPosition(offset: _controller.text.length),  // Move to end
);
```

---

## Listening to Changes

### Method 1: addListener
```dart
@override
void initState() {
  super.initState();
  _controller.addListener(_onTextChanged);
}

void _onTextChanged() {
  print('Text: ${_controller.text}');
}

@override
void dispose() {
  _controller.removeListener(_onTextChanged);
  _controller.dispose();
  super.dispose();
}
```

### Method 2: onChange in TextField
```dart
TextField(
  controller: _controller,
  onChanged: (text) {
    print('Changed: $text');
  },
)
```

---

## Multiple Controllers

```dart
class _FormState extends State<FormPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // Use controllers in build...
}
```

---

## Common Patterns

### Pattern 1: Form Submission
```dart
void _submit() {
  final username = _usernameController.text.trim();
  final password = _passwordController.text;

  if (username.isEmpty || password.isEmpty) {
    showError('Fill all fields');
    return;
  }

  // Submit...
}
```

### Pattern 2: Real-time Validation
```dart
@override
void initState() {
  super.initState();
  _emailController.addListener(() {
    if (_emailController.text.contains('@')) {
      setState(() {
        _isValidEmail = true;
      });
    }
  });
}
```

### Pattern 3: Search Field
```dart
TextField(
  controller: _searchController,
  onChanged: (query) {
    _performSearch(query);
  },
)
```

---

## Memory Management

**Always dispose controllers**:
```dart
@override
void dispose() {
  _controller.dispose();  // Required
  super.dispose();
}
```

**What happens if you don't dispose**:
- Memory leak
- Listeners stay in memory
- Can cause performance issues

---

## Common Questions

**Q: When should I use TextEditingController?**
A: When you need to programmatically read, set, or clear text field values.

**Q: Do I always need a controller?**
A: No, use onChanged if you only need to react to changes without programmatic control.

**Q: What happens if I forget to dispose?**
A: Memory leak - the controller stays in memory even after widget is removed.

**Q: Can I share one controller between multiple TextFields?**
A: Technically yes, but not recommended - they would show the same text.

---

## Without Controller (Alternative)

If you only need the value on submit:

```dart
String? _username;
String? _password;

TextField(
  onChanged: (value) {
    _username = value;
  },
)

TextField(
  onChanged: (value) {
    _password = value;
  },
)

// Submit
ElevatedButton(
  onPressed: () {
    print('Username: $_username, Password: $_password');
  },
)
```

---

## Code Reference

Live example: `lib/samples/beginner/texteditingcontroller_example.dart`
