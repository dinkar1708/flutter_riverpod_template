import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Heavy computation function (runs for ~2 seconds)
int _expensiveCalculation(int iterations) {
  int result = 0;
  for (int i = 0; i < iterations; i++) {
    result += i;
    // Simulate complex calculation
    if (i % 1000000 == 0) {
      // This helps make it actually take time
    }
  }
  return result;
}

class UiThreadBlockingExample extends StatelessWidget {
  const UiThreadBlockingExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('UI Thread Blocking')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Info Card
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.speed,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'UI Thread Performance',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Problem: Heavy work on UI thread freezes the app.\n'
                    'Solution: Use compute() to run on separate isolate.',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // BAD Example
          _buildExampleCard(
            context,
            title: 'BAD: Blocks UI Thread',
            description: 'Heavy computation freezes UI for 2 seconds',
            color: Colors.red,
            onTap: () {
              debugPrint('🔴 [WRONG] Opening UI blocking BAD example');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const UiThreadBlockingBadExample(),
                ),
              );
            },
          ),
          const SizedBox(height: 12),

          // GOOD Example
          _buildExampleCard(
            context,
            title: 'GOOD: Uses Isolate',
            description: 'Work runs on separate thread, UI stays smooth',
            color: Colors.green,
            onTap: () {
              debugPrint('✅ [GOOD] Opening isolate GOOD example');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const UiThreadBlockingGoodExample(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildExampleCard(
    BuildContext context, {
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    color == Colors.red ? Icons.error : Icons.check_circle,
                    color: color,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Text(description, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: Icon(Icons.chevron_right, color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// BAD EXAMPLE: Blocks UI thread with heavy computation
class UiThreadBlockingBadExample extends StatefulWidget {
  const UiThreadBlockingBadExample({super.key});

  @override
  State<UiThreadBlockingBadExample> createState() =>
      _UiThreadBlockingBadExampleState();
}

class _UiThreadBlockingBadExampleState
    extends State<UiThreadBlockingBadExample> {
  int? _result;
  bool _isCalculating = false;

  void _runHeavyTask() {
    debugPrint('🔴 [WRONG] Starting heavy task on UI thread...');
    debugPrint('🔴 [WRONG] UI will FREEZE for ~2 seconds!');

    setState(() {
      _isCalculating = true;
      _result = null;
    });

    final startTime = DateTime.now();

    // ❌ WRONG: Runs on UI thread - blocks everything!
    final result = _expensiveCalculation(100000000);

    final duration = DateTime.now().difference(startTime);

    debugPrint('🔴 [WRONG] Task completed in ${duration.inMilliseconds}ms');
    debugPrint('🔴 [WRONG] UI was FROZEN during this time!');
    debugPrint('💀 [WRONG] User could not interact with app!');

    setState(() {
      _result = result;
      _isCalculating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BAD: UI Blocking'),
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
                          'DevTools: Performance Tab',
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
                      'Verify: Open Performance tab, tap button, see red bars (jank)',
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
                  '❌ WRONG: Heavy work on UI thread!\n'
                  'Watch the spinner below - it will FREEZE.\n'
                  'Try tapping buttons - they won\'t respond!',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Spinner to show UI blocking
            const SizedBox(
              height: 100,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            const Text(
              'This spinner should spin smoothly.\n'
              'It will freeze when you tap the button below!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _isCalculating ? null : _runHeavyTask,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(_isCalculating ? 'Calculating...' : 'Run Heavy Task (UI Freezes!)'),
            ),

            if (_result != null) ...[
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        'Result:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('$_result'),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// GOOD EXAMPLE: Uses isolate to keep UI responsive
class UiThreadBlockingGoodExample extends StatefulWidget {
  const UiThreadBlockingGoodExample({super.key});

  @override
  State<UiThreadBlockingGoodExample> createState() =>
      _UiThreadBlockingGoodExampleState();
}

class _UiThreadBlockingGoodExampleState
    extends State<UiThreadBlockingGoodExample> {
  int? _result;
  bool _isCalculating = false;

  Future<void> _runHeavyTaskOnIsolate() async {
    debugPrint('✅ [GOOD] Starting heavy task on separate isolate...');
    debugPrint('✅ [GOOD] UI will stay RESPONSIVE!');

    setState(() {
      _isCalculating = true;
      _result = null;
    });

    final startTime = DateTime.now();

    // ✅ GOOD: Runs on separate isolate - UI stays smooth!
    final result = await compute(_expensiveCalculation, 100000000);

    final duration = DateTime.now().difference(startTime);

    debugPrint('✅ [GOOD] Task completed in ${duration.inMilliseconds}ms');
    debugPrint('✅ [GOOD] UI remained SMOOTH during calculation!');
    debugPrint('✅ [GOOD] User could still interact with app!');

    if (!mounted) return;

    setState(() {
      _result = result;
      _isCalculating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GOOD: Using Isolate'),
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
                          'DevTools: Performance Tab',
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
                      'Verify: Open Performance tab, tap button, see green bars (smooth)',
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
                  '✅ CORRECT: Work runs on isolate!\n'
                  'Watch the spinner - it keeps spinning.\n'
                  'Try tapping buttons - everything works!',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Spinner to show UI stays responsive
            const SizedBox(
              height: 100,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            const Text(
              'This spinner keeps spinning smoothly!\n'
              'Even during heavy computation!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _isCalculating ? null : _runHeavyTaskOnIsolate,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: Text(_isCalculating
                  ? 'Calculating on Isolate...'
                  : 'Run Heavy Task (UI Stays Smooth!)'),
            ),

            if (_result != null) ...[
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        'Result:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text('$_result'),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
