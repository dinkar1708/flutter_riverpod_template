import 'dart:async';
import 'package:flutter/material.dart';

// WRONG EXAMPLE: Timer not cancelled
class TimerLeakExample extends StatefulWidget {
  const TimerLeakExample({super.key});

  @override
  State<TimerLeakExample> createState() => _TimerLeakExampleState();
}

class _TimerLeakExampleState extends State<TimerLeakExample> {
  int _counter = 0;
  // ignore: unused_field
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    debugPrint('🔴 [LEAK] Starting timer that will NEVER stop!');
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      debugPrint('🔴 [LEAK] Timer tick #${timer.tick} - Counter: $_counter (Widget might be disposed!)');
      if (mounted) {
        setState(() {
          _counter++;
        });
      }
    });
  }

  // ❌ ERROR: Timer not cancelled - MEMORY LEAK!

  @override
  void deactivate() {
    super.deactivate();
    debugPrint('⚠️ [LEAK] Widget is being removed but timer is STILL RUNNING!');
    debugPrint('💀 [LEAK] Timer will continue ticking in the background FOREVER!');
    debugPrint('💀 [LEAK] Watch the console - timer will keep printing even after this widget is gone!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BAD: Timer Not Cancelled'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // DevTools Hint Card
              Card(
                color: Theme.of(context).colorScheme.tertiaryContainer,
                margin: const EdgeInsets.all(16),
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
                        'Verify: Search "Timer" in diff, check console for continuous ticks',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
              const Card(
                color: Colors.red,
                margin: EdgeInsets.all(16),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    '❌ WRONG: Timer keeps running!\n'
                    'Navigate back and watch console.\n'
                    'Timer continues even after widget is gone!',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Text(
                'Counter: $_counter',
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Press back and watch console logs.\n'
                  'Timer continues indefinitely!',
                  style: TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// RIGHT EXAMPLE: Timer properly cancelled
class TimerGoodExample extends StatefulWidget {
  const TimerGoodExample({super.key});

  @override
  State<TimerGoodExample> createState() => _TimerGoodExampleState();
}

class _TimerGoodExampleState extends State<TimerGoodExample> {
  int _counter = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    debugPrint('✅ [GOOD] Starting timer (will be cancelled properly)');
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        debugPrint('✅ [GOOD] Timer tick #${timer.tick} - Counter: $_counter');
        setState(() {
          _counter++;
        });
      }
    });
  }

  @override
  void dispose() {
    debugPrint('✅ [GOOD] Cancelling timer - No more ticks after this!');
    _timer.cancel(); // ✅ PROPERLY CANCELLED
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GOOD: Timer Cancelled'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // DevTools Hint Card
              Card(
                color: Theme.of(context).colorScheme.tertiaryContainer,
                margin: const EdgeInsets.all(16),
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
                        'Verify: Timer stops immediately after navigation back',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
              const Card(
                color: Colors.green,
                margin: EdgeInsets.all(16),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    '✅ CORRECT: Timer is cancelled!\n'
                    'Navigate back and watch console.\n'
                    'Timer stops properly!',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Text(
                'Counter: $_counter',
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Press back and watch console.\n'
                  'Timer stops immediately!',
                  style: TextStyle(color: Colors.green),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
