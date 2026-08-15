# Future vs Stream

## Quick Comparison

| Feature | Future | Stream |
|---------|--------|--------|
| Returns | Single value | Multiple values |
| When | One time | Over time |
| Completes | Once | Can be continuous |
| Widget | FutureBuilder | StreamBuilder |
| Use case | API call, file read | Chat messages, sensor data |

---

## Future - Single Value

### What is it?
A Future represents a single value that will be available at some point in the future.

### Example Use Cases:
- API calls (one response)
- Reading a file (one result)
- Database query (one-time fetch)
- Authentication (login once)

### Creating a Future:
```dart
Future<String> fetchUserName() async {
  await Future.delayed(Duration(seconds: 2));
  return 'John Doe';
}
```

### Using FutureBuilder:
```dart
FutureBuilder<String>(
  future: fetchUserName(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }

    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    }

    if (snapshot.hasData) {
      return Text('User: ${snapshot.data}');
    }

    return Text('No data');
  },
)
```

---

## Stream - Multiple Values

### What is it?
A Stream represents a sequence of values that arrive over time.

### Example Use Cases:
- Chat messages (continuous updates)
- Real-time data (stock prices, sensor readings)
- Timer/countdown (multiple tick events)
- WebSocket connections
- User input events

### Creating a Stream:
```dart
Stream<int> countStream() async* {
  for (int i = 1; i <= 5; i++) {
    await Future.delayed(Duration(seconds: 1));
    yield i; // emit value
  }
}
```

### Using StreamBuilder:
```dart
StreamBuilder<int>(
  stream: countStream(),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Text('Waiting...');
    }

    if (snapshot.connectionState == ConnectionState.active) {
      return Text('Count: ${snapshot.data}');
    }

    if (snapshot.connectionState == ConnectionState.done) {
      return Text('Completed!');
    }

    if (snapshot.hasError) {
      return Text('Error: ${snapshot.error}');
    }

    return Text('No data');
  },
)
```

---

## Converting Future to Stream

Sometimes you need to convert a Future to a Stream:

```dart
Future<String> fetchData() async {
  await Future.delayed(Duration(seconds: 2));
  return 'Data';
}

// Convert to Stream
Stream<String> dataStream() {
  return Stream.fromFuture(fetchData());
}
```

---

## Stream Types

### 1. Single-subscription Stream
- Can only be listened to once
- Most common type
- Example: File reading, HTTP request

```dart
Stream<int> singleStream() async* {
  yield 1;
  yield 2;
}

final stream = singleStream();
stream.listen((value) => print(value)); // OK
stream.listen((value) => print(value)); // ERROR: Already listened
```

### 2. Broadcast Stream
- Can be listened to multiple times
- Use for events that multiple listeners need

```dart
final controller = StreamController<int>.broadcast();

controller.stream.listen((value) => print('Listener 1: $value')); //
controller.stream.listen((value) => print('Listener 2: $value')); //

controller.add(1); // Both listeners receive 1
controller.add(2); // Both listeners receive 2
```

---

## StreamController

Manual control over streams:

```dart
final controller = StreamController<String>();

// Add data
controller.add('Message 1');
controller.add('Message 2');

// Listen to stream
controller.stream.listen((message) {
  print(message);
});

// Close when done
controller.close();
```

---

## Common Patterns

### Pattern 1: API Call (Future)
```dart
Future<User> fetchUser(int id) async {
  final response = await http.get('api/users/$id');
  return User.fromJson(response.data);
}

// In widget
FutureBuilder<User>(
  future: fetchUser(1),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return Text(snapshot.data!.name);
    }
    return CircularProgressIndicator();
  },
)
```

### Pattern 2: Real-time Chat (Stream)
```dart
Stream<List<Message>> chatStream() {
  return FirebaseFirestore.instance
    .collection('messages')
    .snapshots()
    .map((snapshot) =>
      snapshot.docs.map((doc) => Message.fromDoc(doc)).toList()
    );
}

// In widget
StreamBuilder<List<Message>>(
  stream: chatStream(),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return ListView.builder(
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          return MessageTile(snapshot.data![index]);
        },
      );
    }
    return CircularProgressIndicator();
  },
)
```

### Pattern 3: Countdown Timer (Stream)
```dart
Stream<int> countdown(int seconds) async* {
  for (int i = seconds; i > 0; i--) {
    await Future.delayed(Duration(seconds: 1));
    yield i;
  }
}

// In widget
StreamBuilder<int>(
  stream: countdown(10),
  builder: (context, snapshot) {
    return Text('Time left: ${snapshot.data ?? 10}');
  },
)
```

---

## Common Questions

**Q: When to use Future vs Stream?**
A: Use Future for single values (API call), Stream for multiple values over time (chat, sensor data).

**Q: Can a Future be converted to Stream?**
A: Yes, using `Stream.fromFuture(future)`.

**Q: Can a Stream be listened to multiple times?**
A: Only broadcast streams. Single-subscription streams can only be listened to once.

**Q: What's the difference between async and async*?**
A: `async` returns Future, `async*` returns Stream (generator function).

**Q: How do you emit values in a Stream?**
A: Use `yield` in async* function, or `controller.add()` with StreamController.

---

## Console Logs

When running the example:

**Future:**
```
[FUTURE] Starting to fetch data...
[FUTURE] Data fetched: "Hello from Future"
```

**Stream:**
```
[STREAM] Starting count stream...
[STREAM] Emitting value: 1
[STREAM] Emitting value: 2
[STREAM] Emitting value: 3
[STREAM] Emitting value: 4
[STREAM] Emitting value: 5
[STREAM] Stream completed
```

---

## Best Practices

1. **Close StreamControllers**: Always close controllers when done to prevent memory leaks
   ```dart
   @override
   void dispose() {
     _controller.close();
     super.dispose();
   }
   ```

2. **Handle errors**: Both Future and Stream should handle errors
   ```dart
   future.catchError((error) => handleError(error));
   stream.handleError((error) => handleError(error));
   ```

3. **Use FutureBuilder for one-time data**: Don't use StreamBuilder for Futures

4. **Use StreamBuilder for real-time data**: Don't repeatedly call Futures

---

## Code Reference

Live example: `lib/samples/intermediate/future_vs_stream_example.dart`
