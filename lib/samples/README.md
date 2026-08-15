# Flutter FAQ Code Samples

This folder contains interactive code examples that correspond to topics covered in the Flutter FAQ documentation at `docs/technical/FAQ/`.

## Structure

```
lib/samples/
├── beginner/           # Beginner-level examples
├── intermediate/       # Intermediate-level examples
├── advanced/           # Advanced-level examples
└── samples_list_page.dart  # Main navigation page
```

## How It Works

1. Users click "Explore Code Samples" on the home page
2. Opens `samples_list_page.dart` with categorized list
3. Each example is a standalone widget (simple Navigator.push)
4. Console logs demonstrate lifecycle and execution flow

## Adding New Examples

### Step 1: Check Existing Codebase First

Before creating a new example file, check if the topic is already demonstrated:

**Existing Codebase Examples:**
- State Management: [counter_page.dart](../feature/counter/views/counter_page.dart)
- API Integration: [repository_list_page.dart](../feature/repository_list/views/repository_list_page.dart)
- Search & Filter: [users_page.dart](../feature/users/views/users_page.dart)

### Step 2: Create New Example (if not in codebase)

Create a new standalone widget in the appropriate category folder.

**File naming:** `topic_example.dart`

See existing examples:
- [keys_example.dart](beginner/keys_example.dart)
- [lifecycle_methods_example.dart](beginner/lifecycle_methods_example.dart)
- [animation_controller_example.dart](intermediate/animation_controller_example.dart)

### Step 3: Add to Samples List Page

Update [samples_list_page.dart](samples_list_page.dart):
- Import your example at the top
- Add a new `_buildExampleCard()` entry
- Include file path in `codeReference` parameter

Reference existing entries for the pattern.

### Step 4: Update FAQ Documentation

Add cross-reference in corresponding FAQ markdown file:

```markdown
**Live Example:** lib/samples/beginner/your_example.dart
**Production Usage:** lib/feature/xyz/file.dart:45
```

## Example Categories

### Beginner
- StatefulWidget Lifecycle (initState, dispose, build)
- Keys (ValueKey, GlobalKey, UniqueKey)
- FutureBuilder & StreamBuilder
- MediaQuery responsive layouts

### Intermediate
- Animation Controller
- Riverpod AsyncNotifier
- Dio + Retrofit API calls

### Advanced
- CustomPainter & Canvas
- Isolates & Concurrency
- Platform Channels

## Guidelines

1. **Fully Standalone** - Each example file can be copied and run independently
2. **No Custom Imports** - Only use standard Flutter packages (material.dart, dart:math)
3. **No @RoutePage** - Plain StatelessWidget or StatefulWidget
4. **Cross-reference first** - Use existing codebase examples when available
5. **Console logs** - Add debugPrint() statements for learning
6. **Interactive** - Include buttons/controls for user experimentation
7. **Clear structure** - Header card explaining the concept
8. **Badge marking** - Codebase examples get green "Codebase" badge

## Standalone Verification

All example files are **100% standalone**. You can:
- Copy any example file to a new Flutter project
- No dependencies on project-specific widgets or utilities
- Only imports: `package:flutter/material.dart` and `dart:math`

**How to test standalone:**
```bash
# Create new Flutter project
flutter create test_app
cd test_app

# Copy any example file
cp path/to/keys_example.dart lib/

# Update main.dart to use the example
# Replace home: MyHomePage() with home: KeysExample()

# Run
flutter run
```

## Verified & Tested

All examples have been tested and verified working on real devices.

**Quick verification:** See console logs in FAQ documentation for each example.

**Example: Lifecycle Methods Console Output**
```
📱 [LifecycleExample] createState() called
✅ [LifecycleExample] initState() - Called ONCE
🔄 [LifecycleExample] didChangeDependencies() - Call count: 1
🎨 [LifecycleExample] build() - Building UI (call #1)
🔵 [User Action] setState() called - Counter: 1
🎨 [LifecycleExample] build() - Building UI (call #2)
🟢 [ChildWidget] initState() called
🎨 [ChildWidget] build() called
⬅️ [ChildWidget] Popping back to parent
❌ [ChildWidget] dispose() - Child widget cleanup
⚠️ [LifecycleExample] deactivate() - Widget being removed
❌ [LifecycleExample] dispose() - CLEANUP TIME!
```

**Example: Keys Example Console Output**
```
🔄 Started reordering item at index 2
✅ Finished reordering
```

**Example: TextField/ListView Mistakes**
```
❌ [Mistake 1] TextField in Row without Expanded
   This will cause: BoxConstraints forces an infinite width
✅ [Fix 1] Wrap TextField with Expanded

❌ [Mistake 2] WRONG: Expanded + TextField in Column
   Error: TextField has unbounded height inside Expanded
✅ [Fix 2] RIGHT: Set maxLines constraint

✅ ListView is properly constrained with Expanded
```

## Key Files to Reference

- Sample widget structure: [lifecycle_methods_example.dart](beginner/lifecycle_methods_example.dart)
- List page pattern: [samples_list_page.dart](samples_list_page.dart)
- Home integration: [home_page.dart](../feature/home/home_page.dart)
