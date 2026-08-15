# Named vs Positional Parameters

## Quick Comparison

| Feature | Positional | Named |
|---------|-----------|-------|
| Order | Matters | Flexible |
| Syntax | func(a, b) | func(a: 1, b: 2) |
| Optional | No | Yes |
| Readability | Less clear | More clear |
| Required | All required | Use `required` |

---

## Positional Parameters

**Definition**: Parameters passed in a specific order.

**Syntax**:
```dart
void greet(String name, int age) {
  print('Hello $name, age $age');
}

// Call - order matters
greet('John', 25); // Correct
greet(25, 'John'); // ERROR - wrong order
```

**Characteristics**:
- Must be provided in exact order
- All are required by default
- Less readable for many parameters

---

## Named Parameters

**Definition**: Parameters identified by name, order doesn't matter.

**Syntax**:
```dart
void greet({required String name, required int age}) {
  print('Hello $name, age $age');
}

// Call - order does not matter
greet(name: 'John', age: 25); // Works
greet(age: 25, name: 'John'); // Also works
```

**Characteristics**:
- Can be provided in any order
- More readable
- Optional by default (unless marked `required`)

---

## Required Named Parameters

Use `required` keyword to make named parameters mandatory:

```dart
void createUser({
  required String name,    // Must provide
  required int age,        // Must provide
  String? email,           // Optional
}) {
  print('User: $name, $age, $email');
}

// Usage
createUser(name: 'John', age: 25); // email is optional
createUser(name: 'John', age: 25, email: 'john@example.com');
```

---

## Optional Named Parameters

Named parameters are optional by default:

```dart
void greet({
  String name = 'Guest',  // Default value
  int? age,               // Nullable (optional)
}) {
  print('Hello $name, age: $age');
}

// Usage
greet(); // Hello Guest, age: null
greet(name: 'John'); // Hello John, age: null
greet(name: 'John', age: 25); // Hello John, age: 25
```

---

## Optional Positional Parameters

Use square brackets `[]` for optional positional parameters:

```dart
void greet(String name, [int? age]) {
  print('Hello $name, age: $age');
}

// Usage
greet('John'); // Hello John, age: null
greet('John', 25); // Hello John, age: 25
```

**With default values**:
```dart
void greet(String name, [int age = 18]) {
  print('Hello $name, age: $age');
}

// Usage
greet('John'); // Hello John, age: 18
greet('John', 25); // Hello John, age: 25
```

---

## Mixed Parameters

You can combine positional and named parameters:

```dart
void createUser(
  String name,              // Positional (required, comes first)
  {
    required int age,       // Named required
    String? email,          // Named optional
  }
) {
  print('User: $name, $age, $email');
}

// Usage
createUser('John', age: 25);
createUser('John', age: 25, email: 'john@example.com');
createUser('John', email: 'john@example.com', age: 25); // Order of named doesn't matter
```

**Rules**:
- Positional parameters must come first
- Named parameters must come after positional
- Cannot mix optional positional `[]` with named `{}`

---

## Flutter Widget Example

Most Flutter widgets use named parameters:

```dart
Container(
  width: 100,            // Named - order flexible
  height: 200,
  color: Colors.blue,
  padding: EdgeInsets.all(16),
  child: Text('Hello'),
)

// Same as (different order):
Container(
  child: Text('Hello'),
  color: Colors.blue,
  width: 100,
  padding: EdgeInsets.all(16),
  height: 200,
)
```

---

## When to Use Each

### Use Positional When:
- Few parameters (1-2)
- Order is logical and obvious
- Parameters are always required

```dart
Point(10, 20) // x, y - order is obvious
```

### Use Named When:
- Many parameters (3+)
- Some parameters are optional
- Parameter purpose not obvious from order

```dart
TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: Colors.blue,
) // Much clearer than positional
```

---

## Common Patterns

### Pattern 1: All required named
```dart
class User {
  final String name;
  final int age;

  User({required this.name, required this.age});
}

// Usage
User(name: 'John', age: 25);
```

### Pattern 2: Mix of required and optional
```dart
class User {
  final String name;
  final int age;
  final String? email;

  User({
    required this.name,
    required this.age,
    this.email,
  });
}

// Usage
User(name: 'John', age: 25);
User(name: 'John', age: 25, email: 'john@example.com');
```

### Pattern 3: With default values
```dart
void fetchData({
  String url = 'https://api.example.com',
  int timeout = 30,
}) {
  print('Fetching from $url with timeout $timeout');
}

// Usage
fetchData(); // Uses defaults
fetchData(url: 'https://other.com'); // Custom URL
```

---

## Common Questions

**Q: What's the difference between positional and named parameters?**
A: Positional parameters depend on order, named parameters use names and order doesn't matter.

**Q: Can I make named parameters required?**
A: Yes, use the `required` keyword before the parameter.

**Q: Can I mix positional and named parameters?**
A: Yes, but positional must come first, then named.

**Q: Why does Flutter use named parameters?**
A: Better readability and flexibility, especially for widgets with many optional parameters.

---

## Console Logs

When running the example:

```
[POSITIONAL] name: John, age: 25, job: Developer
[NAMED] name: Sarah, age: 30, job: Designer
[MIXED] name: Alex, age: 28, job: Manager
```

---

## Code Reference

Live example: `lib/samples/beginner/parameters_example.dart`
