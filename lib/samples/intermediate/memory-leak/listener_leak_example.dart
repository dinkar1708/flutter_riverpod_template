import 'package:flutter/material.dart';

// WRONG EXAMPLE: Listener not removed
class ListenerLeakExample extends StatefulWidget {
  const ListenerLeakExample({super.key});

  @override
  State<ListenerLeakExample> createState() => _ListenerLeakExampleState();
}

class _ListenerLeakExampleState extends State<ListenerLeakExample> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    debugPrint('🔴 [LEAK] TextEditingController created - ID: ${_controller.hashCode}');
    debugPrint('🔴 [LEAK] Adding listener to controller...');

    _controller.addListener(_onTextChanged);

    debugPrint('⚠️ [LEAK] Listener added but will NEVER be removed!');
  }

  void _onTextChanged() {
    debugPrint('🔴 [LEAK] Listener triggered - Text: "${_controller.text}"');
  }

  @override
  void deactivate() {
    super.deactivate();
    debugPrint('⚠️ [LEAK] Widget is being removed but listener is STILL ATTACHED!');
    debugPrint('💀 [LEAK] Listener will keep the State object in memory FOREVER!');
  }

  // ❌ ERROR: Listener not removed AND controller not disposed - MEMORY LEAK!

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BAD: Listener Not Removed'),
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
                      'Verify: Check Retaining Path showing listener chain',
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
                  '❌ WRONG: Listener NOT removed!\n'
                  'Type something, then navigate back.\n'
                  'Listener keeps State object in memory!',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Type to trigger listener',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Type something, then navigate back.\n'
              'Check console - listener not removed!',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// RIGHT EXAMPLE: Listener properly removed
class ListenerGoodExample extends StatefulWidget {
  const ListenerGoodExample({super.key});

  @override
  State<ListenerGoodExample> createState() => _ListenerGoodExampleState();
}

class _ListenerGoodExampleState extends State<ListenerGoodExample> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    debugPrint('✅ [GOOD] TextEditingController created - ID: ${_controller.hashCode}');
    debugPrint('✅ [GOOD] Adding listener (will be removed in dispose)');

    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    debugPrint('✅ [GOOD] Listener triggered - Text: "${_controller.text}"');
  }

  @override
  void dispose() {
    debugPrint('✅ [GOOD] Removing listener from controller');
    _controller.removeListener(_onTextChanged); // ✅ LISTENER REMOVED

    debugPrint('✅ [GOOD] Disposing controller - ID: ${_controller.hashCode}');
    _controller.dispose(); // ✅ CONTROLLER DISPOSED
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GOOD: Listener Removed'),
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
                      'Verify: Listener removed, controller freed properly',
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
                  '✅ CORRECT: Listener properly removed!\n'
                  'Type something, then navigate back.\n'
                  'Everything cleaned up correctly!',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Type to trigger listener',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Type something, then navigate back.\n'
              'Check console - clean disposal!',
              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
