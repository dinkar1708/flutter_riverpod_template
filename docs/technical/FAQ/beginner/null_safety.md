# Null Safety Operators

## Overview

Dart's null safety prevents null reference errors at compile time. Understanding null safety operators is essential for writing safe Dart code.

---

## The Four Main Operators

| Operator | Name | Purpose | Example |
|----------|------|---------|---------|
| ? | Nullable | Allow null values | String? name |
| ?. | Null-aware access | Safe property access | name?.length |
| ?? | Null coalescing | Default value | name ?? 'Guest' |
| ! | Null assertion | Force unwrap | name! |

---

## 1. ? - Nullable Type

**Purpose**: Declare that a variable can be null.

**Syntax**:
```dart
String? name;  // Can be null or String
int? age;      // Can be null or int
```

**Without ?**:
```dart
String name;   // Must be String, cannot be null
name = null;   // ERROR
```

**With ?**:
```dart
String? name;  // Can be String or null
name = null;   // OK
name = 'John'; // OK
```

---

## 2. ?. - Null-aware Access

**Purpose**: Safely access properties/methods when object might be null.

**Syntax**:
```dart
String? name;
int? length = name?.length;  // Returns null if name is null
```

**Without ?.**:
```dart
String? name;
int length = name.length;  // ERROR if name is null
```

**With ?.**:
```dart
String? name;
int? length = name?.length;  // Returns null safely

name = 'John';
length = name?.length;  // Returns 4
```

**Chaining**:
```dart
user?.profile?.name?.toUpperCase()  // Safe chain
```

---

## 3. ?? - Null Coalescing

**Purpose**: Provide default value when variable is null.

**Syntax**:
```dart
String? name;
String display = name ?? 'Guest';  // Use 'Guest' if name is null
```

**Examples**:
```dart
String? name;
print(name ?? 'No name');  // Output: No name

name = 'John';
print(name ?? 'No name');  // Output: John
```

**With assignment**:
```dart
String? name;
name ??= 'Default';  // Assign only if null
print(name);  // Output: Default

name ??= 'Another';  // Does nothing, name already has value
print(name);  // Output: Default (unchanged)
```

---

## 4. ! - Null Assertion (Force Unwrap)

**Purpose**: Tell compiler "I know this is not null".

**DANGER**: Crashes if variable is actually null.

**Syntax**:
```dart
String? name = 'John';
String nonNull = name!;  // OK - name is not null
```

**Crash example**:
```dart
String? name;
String nonNull = name!;  // CRASH - name is null
```

**When to use**:
- Only when 100% certain value is not null
- After explicit null check
- Use sparingly - prefer ?. or ??

**Safe usage**:
```dart
String? name;
if (name != null) {
  String nonNull = name!;  // Safe - checked above
}
```

---

## Combining Operators

### Example 1: ?. with ??
```dart
String? name;
int length = name?.length ?? 0;  // Returns 0 if name is null
```

### Example 2: Multiple ?.
```dart
String? result = user?.profile?.address?.street;
```

### Example 3: ?? with assignment
```dart
String? name;
name ??= fetchDefaultName();  // Only calls function if name is null
```

---

## Late Keyword

**Purpose**: Initialize variable later (not at declaration).

**Usage**:
```dart
late String name;  // Will be initialized before use

void initData() {
  name = 'John';  // Initialize later
}

void printName() {
  print(name);  // OK if initData() was called first
}
```

**Crash if not initialized**:
```dart
late String name;
print(name);  // CRASH - not initialized yet
```

**Use cases**:
- Expensive initialization
- Circular dependencies
- Non-nullable but can't initialize at declaration

---

## Common Patterns

### Pattern 1: Safe property access with default
```dart
String? name;
String display = name?.toUpperCase() ?? 'GUEST';
```

### Pattern 2: Safe method call
```dart
List<int>? numbers;
numbers?.forEach((n) => print(n));  // Does nothing if numbers is null
```

### Pattern 3: Lazy initialization
```dart
String? _cachedData;
String getData() => _cachedData ??= fetchData();
```

---

## Migration from Old Code

**Before (Dart 2.x)**:
```dart
String name;  // Could be null
if (name != null) {
  print(name.length);
}
```

**After (Dart 3.x with null safety)**:
```dart
String? name;  // Explicitly nullable
if (name != null) {
  print(name.length);  // Smart cast - name is String here
}

// Or
print(name?.length ?? 0);
```

---

## Common Questions

**Q: What's the difference between ? and !?**
A: ? makes type nullable (safe), ! forces unwrap (dangerous, can crash).

**Q: When should I use !?**
A: Only when 100% certain value is not null. Prefer ?. or ??.

**Q: What does late mean?**
A: Variable will be initialized before first use, but not at declaration.

**Q: Can I use ?? with non-nullable types?**
A: Yes, but only makes sense with nullable types.

---

## Best Practices

1. Prefer nullable types over late when possible
2. Use ?. instead of manual null checks
3. Avoid ! - use it as last resort
4. Provide defaults with ?? instead of !
5. Use late only when truly needed

---

## Code Reference

Live example: `lib/samples/beginner/null_safety_example.dart`
