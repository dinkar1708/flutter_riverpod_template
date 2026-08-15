import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AnrExample extends StatefulWidget {
  const AnrExample({super.key});

  @override
  State<AnrExample> createState() => _AnrExampleState();
}

class _AnrExampleState extends State<AnrExample> {
  String _wrongResult = 'Tap button to block UI (ANR)';
  String _rightResult = 'Tap button for smooth background work';
  bool _isProcessing = false;

  // ❌ WRONG: Heavy computation on main thread causes ANR
  void _blockMainThread() {
    setState(() {
      _wrongResult = 'Processing... (UI will freeze!)';
      _isProcessing = true;
    });

    debugPrint('🔴 [WRONG] Starting heavy work on MAIN thread');
    debugPrint('⚠️ [WARNING] UI is BLOCKED - cannot tap buttons or scroll!');
    debugPrint('⚠️ [WARNING] On Android, if this takes >5 seconds, ANR dialog appears');

    final startTime = DateTime.now();

    // Simulate heavy computation (blocking the UI thread)
    int result = 0;
    for (int i = 0; i < 1000000000; i++) {
      result += i;

      // Try to scroll or tap during this loop - UI will be frozen!
      if (i % 100000000 == 0) {
        debugPrint('🔴 [MAIN THREAD BLOCKED] Progress: ${(i / 1000000000 * 100).toInt()}%');
      }
    }

    final duration = DateTime.now().difference(startTime).inSeconds;

    setState(() {
      _wrongResult = 'Completed in ${duration}s\nUI was frozen the entire time!';
      _isProcessing = false;
    });

    debugPrint('❌ [WRONG] Finished - UI was blocked for ${duration}s (result: $result)');
    debugPrint('   └─ User could not interact with app during this time');
    debugPrint('   └─ On Android, if >5s, ANR dialog would appear');
  }

  // ✅ RIGHT: Use compute() to run work in background isolate
  Future<void> _useBackgroundIsolate() async {
    setState(() {
      _rightResult = 'Processing in background... (UI stays responsive!)';
    });

    debugPrint('✅ [RIGHT] Starting heavy work in BACKGROUND isolate');
    debugPrint('✅ [UI RESPONSIVE] Try scrolling or tapping other buttons!');

    final startTime = DateTime.now();

    // Run computation in separate isolate - UI remains responsive
    final result = await compute(_heavyComputation, 1000000000);

    final duration = DateTime.now().difference(startTime).inSeconds;

    setState(() {
      _rightResult = 'Completed in ${duration}s\nUI stayed responsive!';
    });

    debugPrint('✅ [RIGHT] Finished - UI was never blocked (result: $result)');
    debugPrint('   └─ User could scroll, tap, and interact normally');
    debugPrint('   └─ No ANR risk!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ANR Prevention'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'ANR: Application Not Responding',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'On Android, blocking the UI thread for >5 seconds triggers ANR dialog',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 24),

            // Test scrolling indicator
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.touch_app, color: Colors.blue.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Try scrolling this page while examples are running',
                      style: TextStyle(color: Colors.blue.shade900),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Wrong Example
            _buildSectionHeader(
              context,
              '❌ WRONG: Blocking Main Thread',
              'Causes UI freeze and ANR risk',
              Colors.red,
            ),
            const SizedBox(height: 8),
            Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _wrongResult,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isProcessing ? null : _blockMainThread,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade700,
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.warning),
                        label: const Text('Run on Main Thread (BAD)'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'What happens:\n'
                      '• UI completely freezes\n'
                      '• Cannot scroll or tap buttons\n'
                      '• >5s = ANR dialog on Android\n'
                      '• Poor user experience',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.red.shade900,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Right Example
            _buildSectionHeader(
              context,
              '✅ RIGHT: Background Isolate',
              'UI stays responsive, no ANR risk',
              Colors.green,
            ),
            const SizedBox(height: 8),
            Card(
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _rightResult,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _useBackgroundIsolate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green.shade700,
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.check_circle),
                        label: const Text('Run in Background (GOOD)'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'What happens:\n'
                      '• UI remains responsive\n'
                      '• Can scroll and tap normally\n'
                      '• No ANR risk\n'
                      '• Great user experience',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.green.shade900,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Additional scrollable content to test responsiveness
            _buildTestContent(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    String subtitle,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
              ),
        ),
      ],
    );
  }

  Widget _buildTestContent(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Test UI Responsiveness',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'While the WRONG example runs, try to:\n'
              '• Scroll this page\n'
              '• Tap these buttons\n'
              '• Pull down the notification bar\n\n'
              'You will notice everything is frozen!\n\n'
              'With the RIGHT example, everything works smoothly.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(
                10,
                (index) => ElevatedButton(
                  onPressed: () {
                    debugPrint('✅ Button $index tapped - UI is responsive!');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Button $index tapped!'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  child: Text('Test $index'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Top-level function for compute()
int _heavyComputation(int iterations) {
  debugPrint('✅ [Background Isolate] Started computation');

  int result = 0;
  for (int i = 0; i < iterations; i++) {
    result += i;

    if (i % 100000000 == 0) {
      debugPrint('✅ [Background Isolate] Progress: ${(i / iterations * 100).toInt()}%');
    }
  }

  debugPrint('✅ [Background Isolate] Computation complete');
  return result;
}
