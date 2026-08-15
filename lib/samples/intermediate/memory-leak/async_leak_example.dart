import 'package:flutter/material.dart';

// WRONG EXAMPLE: setState after dispose
class SetStateAfterDisposeExample extends StatefulWidget {
  const SetStateAfterDisposeExample({super.key});

  @override
  State<SetStateAfterDisposeExample> createState() =>
      _SetStateAfterDisposeExampleState();
}

class _SetStateAfterDisposeExampleState
    extends State<SetStateAfterDisposeExample> {
  String _message = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    debugPrint('🔴 [LEAK] Starting async task...');
    await Future.delayed(const Duration(seconds: 3));
    debugPrint('🔴 [LEAK] Async task done, calling setState (might be disposed!)');

    // ❌ ERROR: No mounted check - will crash if widget disposed
    try {
      setState(() {
        _message = 'Data loaded!';
      });
      debugPrint('✅ setState succeeded (widget still mounted)');
    } catch (e) {
      debugPrint('💀 [ERROR] setState FAILED! Widget was disposed!');
      debugPrint('💀 [ERROR] $e');
    }
  }

  @override
  void dispose() {
    debugPrint('⚠️ [LEAK] Widget disposed but async task is still running!');
    debugPrint('⚠️ [LEAK] When task completes, setState will be called on disposed widget!');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BAD: setState After Dispose'),
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
                            'DevTools: Console (NOT Memory Tab!)',
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
                        'Verify: See "setState after dispose" error in console',
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
                    '❌ WRONG: No mounted check!\n'
                    'Navigate back quickly (before 3 seconds).\n'
                    'Will try to call setState on disposed widget!',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Text(
                _message,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Press back NOW and check console!\n'
                  'Error will appear after 3 seconds.',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
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

// RIGHT EXAMPLE: Check mounted before setState
class MountedCheckExample extends StatefulWidget {
  const MountedCheckExample({super.key});

  @override
  State<MountedCheckExample> createState() => _MountedCheckExampleState();
}

class _MountedCheckExampleState extends State<MountedCheckExample> {
  String _message = 'Loading...';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    debugPrint('✅ [GOOD] Starting async task...');
    await Future.delayed(const Duration(seconds: 3));
    debugPrint('✅ [GOOD] Async task done, checking if mounted...');

    // ✅ CORRECT: Check mounted before setState
    if (!mounted) {
      debugPrint('✅ [GOOD] Widget disposed, skipping setState - Safe!');
      return;
    }

    debugPrint('✅ [GOOD] Widget still mounted, safe to call setState');
    setState(() {
      _message = 'Data loaded!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GOOD: mounted Check'),
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
                            'DevTools: Console (NOT Memory Tab!)',
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
                        'Verify: No error, safely skips setState when disposed',
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
                    '✅ CORRECT: Checks mounted!\n'
                    'Navigate back quickly (before 3 seconds).\n'
                    'setState will be safely skipped!',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Text(
                _message,
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Press back NOW and check console.\n'
                  'No error - safely handled!',
                  style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
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
