import 'package:flutter/material.dart';

// WRONG EXAMPLE: TextEditingController not disposed
class TextControllerLeakExample extends StatefulWidget {
  const TextControllerLeakExample({super.key});

  @override
  State<TextControllerLeakExample> createState() =>
      _TextControllerLeakExampleState();
}

class _TextControllerLeakExampleState extends State<TextControllerLeakExample> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    debugPrint('🔴 [LEAK] TextEditingController created - ID: ${_controller.hashCode}');
    debugPrint('⚠️ [LEAK] This controller will NEVER be disposed!');
  }

  // ❌ ERROR: No dispose() method - MEMORY LEAK!

  @override
  void deactivate() {
    super.deactivate();
    debugPrint('⚠️ [LEAK] Widget is being removed but controller is NOT disposed!');
    debugPrint('💀 [LEAK] Controller ${_controller.hashCode} will stay in memory FOREVER!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BAD: No Dispose'),
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
                      'Verify: Take snapshot, open this, go back, GC, snapshot again, diff, search "TextEditingController"',
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
                  '❌ WRONG: Controller is NOT disposed!\n'
                  'This causes MEMORY LEAK.\n'
                  'Check console when you navigate back.',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Type something',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Navigate back and check console.\n'
              'Controller remains in memory!',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// RIGHT EXAMPLE: TextEditingController properly disposed
class TextControllerGoodExample extends StatefulWidget {
  const TextControllerGoodExample({super.key});

  @override
  State<TextControllerGoodExample> createState() =>
      _TextControllerGoodExampleState();
}

class _TextControllerGoodExampleState extends State<TextControllerGoodExample> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    debugPrint('✅ [GOOD] TextEditingController created - ID: ${_controller.hashCode}');
  }

  @override
  void dispose() {
    debugPrint('✅ [GOOD] Disposing TextEditingController - ID: ${_controller.hashCode}');
    _controller.dispose(); // ✅ PROPERLY DISPOSED
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GOOD: With Dispose'),
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
                      'Verify: Instances should be 0 after GC (properly freed)',
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
                  '✅ CORRECT: Controller is properly disposed!\n'
                  'No memory leak.\n'
                  'Check console when you navigate back.',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Type something',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Navigate back and check console.\n'
              'Controller is properly cleaned up!',
              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
