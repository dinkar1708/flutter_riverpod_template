import 'dart:async';
import 'package:flutter/material.dart';

// WRONG EXAMPLE: StreamSubscription not cancelled
class StreamLeakExample extends StatefulWidget {
  const StreamLeakExample({super.key});

  @override
  State<StreamLeakExample> createState() => _StreamLeakExampleState();
}

class _StreamLeakExampleState extends State<StreamLeakExample> {
  // ignore: unused_field
  late StreamSubscription<int> _subscription;
  int _lastValue = 0;

  @override
  void initState() {
    super.initState();
    debugPrint('🔴 [LEAK] Creating stream subscription');

    final stream = Stream<int>.periodic(const Duration(seconds: 1), (count) => count);

    _subscription = stream.listen((value) {
      debugPrint('🔴 [LEAK] Stream event received: $value (Widget might be disposed!)');
      if (mounted) {
        setState(() {
          _lastValue = value;
        });
      }
    });

    debugPrint('⚠️ [LEAK] Subscription created but will NEVER be cancelled!');
  }

  @override
  void deactivate() {
    super.deactivate();
    debugPrint('⚠️ [LEAK] Widget is being removed but stream is STILL LISTENING!');
    debugPrint('💀 [LEAK] Stream will continue processing events FOREVER!');
  }

  // ❌ ERROR: Subscription not cancelled - MEMORY LEAK!

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BAD: Stream Not Cancelled'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // DevTools Hint Card
            Card(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.tertiary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'DevTools: Memory Tab',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Verify: Search "StreamSubscription", check console for continuous events',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Card(
              color: Colors.red,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  '❌ WRONG: Stream subscription NOT cancelled!\n'
                  'Navigate back and watch console.\n'
                  'Stream continues processing events!',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Stream Value: $_lastValue',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Navigate back and check console.\n'
              'Stream keeps emitting events!',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// RIGHT EXAMPLE: StreamSubscription properly cancelled
class StreamGoodExample extends StatefulWidget {
  const StreamGoodExample({super.key});

  @override
  State<StreamGoodExample> createState() => _StreamGoodExampleState();
}

class _StreamGoodExampleState extends State<StreamGoodExample> {
  late StreamSubscription<int> _subscription;
  int _lastValue = 0;

  @override
  void initState() {
    super.initState();
    debugPrint('✅ [GOOD] Creating stream subscription (will be cancelled)');

    final stream = Stream<int>.periodic(const Duration(seconds: 1), (count) => count);

    _subscription = stream.listen((value) {
      debugPrint('✅ [GOOD] Stream event received: $value');
      setState(() {
        _lastValue = value;
      });
    });
  }

  @override
  void dispose() {
    debugPrint('✅ [GOOD] Cancelling stream subscription!');
    _subscription.cancel(); // ✅ PROPERLY CANCELLED
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GOOD: Stream Cancelled'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // DevTools Hint Card
            Card(
              color: Theme.of(context).colorScheme.tertiaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.tertiary,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'DevTools: Memory Tab',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Verify: Stream stops immediately, no more events in console',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Card(
              color: Colors.green,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  '✅ CORRECT: Stream subscription cancelled!\n'
                  'Navigate back and watch console.\n'
                  'Stream stops immediately!',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Stream Value: $_lastValue',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Navigate back and check console.\n'
              'Stream stops cleanly!',
              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
