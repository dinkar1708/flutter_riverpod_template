import 'dart:async';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class IsolatesExample extends StatefulWidget {
  const IsolatesExample({super.key});

  @override
  State<IsolatesExample> createState() => _IsolatesExampleState();
}

class _IsolatesExampleState extends State<IsolatesExample> {
  String _computeResult = 'Not started';
  String _isolateResult = 'Not started';
  bool _isComputeRunning = false;
  Isolate? _persistentIsolate;
  SendPort? _isolateSendPort;
  ReceivePort? _mainReceivePort;

  @override
  void initState() {
    super.initState();
    debugPrint('📱 [IsolatesExample] Widget initialized');
  }

  @override
  void dispose() {
    debugPrint('🧹 [IsolatesExample] Cleaning up isolates...');
    _killPersistentIsolate();
    _mainReceivePort?.close();
    super.dispose();
  }

  // Example 1: Using compute() for one-time heavy computation
  Future<void> _runCompute() async {
    setState(() {
      _isComputeRunning = true;
      _computeResult = 'Computing...';
    });

    debugPrint('🔵 [Main Thread] Starting compute() for factorial calculation');
    final startTime = DateTime.now();

    try {
      // compute() creates an ephemeral isolate, runs the task, and destroys it
      final result = await compute(_heavyFactorialCalculation, 20);

      final duration = DateTime.now().difference(startTime).inMilliseconds;

      setState(() {
        _computeResult = 'Factorial(20) = $result\nCompleted in ${duration}ms';
        _isComputeRunning = false;
      });

      debugPrint('✅ [Main Thread] compute() completed in ${duration}ms');
      debugPrint('   Result: $result');
      debugPrint('   📌 Isolate was automatically destroyed after completion');
    } catch (e) {
      setState(() {
        _computeResult = 'Error: $e';
        _isComputeRunning = false;
      });
      debugPrint('❌ [Main Thread] compute() failed: $e');
    }
  }

  // Example 2: Using Isolate.spawn for persistent worker
  Future<void> _spawnPersistentIsolate() async {
    if (_persistentIsolate != null) {
      debugPrint('⚠️ [Main Thread] Isolate already running');
      return;
    }

    setState(() {
      _isolateResult = 'Spawning isolate...';
    });

    debugPrint('🟢 [Main Thread] Spawning persistent worker isolate...');

    try {
      // Create ReceivePort to get messages from isolate
      _mainReceivePort = ReceivePort();

      // Spawn the isolate with entry point function
      _persistentIsolate = await Isolate.spawn(
        _isolateWorkerEntryPoint,
        _mainReceivePort!.sendPort,
      );

      debugPrint('✅ [Main Thread] Isolate spawned successfully');

      // Listen for messages from the isolate
      _mainReceivePort!.listen((message) {
        if (message is SendPort) {
          // First message is the isolate's SendPort (handshake)
          _isolateSendPort = message;
          debugPrint('🤝 [Main Thread] Handshake complete - received SendPort from isolate');
          setState(() {
            _isolateResult = 'Worker ready. Send tasks using the button below.';
          });
        } else if (message is Map) {
          // Subsequent messages are computation results
          final result = message['result'];
          final duration = message['duration'];
          debugPrint('📬 [Main Thread] Received result from isolate: $result (${duration}ms)');

          setState(() {
            _isolateResult = 'Result: $result\nComputed in ${duration}ms';
          });
        }
      });
    } catch (e) {
      setState(() {
        _isolateResult = 'Error: $e';
      });
      debugPrint('❌ [Main Thread] Failed to spawn isolate: $e');
    }
  }

  void _sendTaskToIsolate() {
    if (_isolateSendPort == null) {
      debugPrint('⚠️ [Main Thread] Isolate not ready yet');
      return;
    }

    setState(() {
      _isolateResult = 'Processing...';
    });

    final number = 15 + (DateTime.now().millisecondsSinceEpoch % 10);
    debugPrint('📤 [Main Thread] Sending task to isolate: Factorial($number)');

    // Send message to persistent isolate
    _isolateSendPort!.send(number);
  }

  void _killPersistentIsolate() {
    if (_persistentIsolate != null) {
      debugPrint('🔴 [Main Thread] Killing persistent isolate...');
      _persistentIsolate!.kill(priority: Isolate.immediate);
      _persistentIsolate = null;
      _isolateSendPort = null;
      debugPrint('✅ [Main Thread] Isolate terminated');

      setState(() {
        _isolateResult = 'Isolate terminated';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Isolates Example'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Dart Isolates: Concurrent Computation',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Isolates have separate memory heaps and communicate via message passing',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 24),

            // Example 1: compute()
            _buildSectionHeader(
              context,
              '1. compute() - Ephemeral Isolate',
              'One-time computation, auto-destroyed after completion',
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _computeResult,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _isComputeRunning ? null : _runCompute,
                        icon: _isComputeRunning
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.calculate),
                        label: Text(_isComputeRunning ? 'Computing...' : 'Run compute()'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Example 2: Isolate.spawn
            _buildSectionHeader(
              context,
              '2. Isolate.spawn - Persistent Worker',
              'Long-lived isolate for multiple tasks',
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isolateResult,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _persistentIsolate == null ? _spawnPersistentIsolate : null,
                            icon: const Icon(Icons.play_arrow),
                            label: const Text('Spawn Isolate'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _isolateSendPort != null ? _sendTaskToIsolate : null,
                            icon: const Icon(Icons.send),
                            label: const Text('Send Task'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _persistentIsolate != null ? _killPersistentIsolate : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade100,
                          foregroundColor: Colors.red.shade900,
                        ),
                        icon: const Icon(Icons.stop),
                        label: const Text('Kill Isolate'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Comparison
            _buildSectionHeader(
              context,
              'When to Use Which?',
              '',
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildComparisonRow(
                      '✅ compute()',
                      'One-time tasks (parsing JSON, image processing)',
                    ),
                    const Divider(),
                    _buildComparisonRow(
                      '✅ Isolate.spawn',
                      'Long-running workers (audio processing, continuous computation)',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Console output note
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.terminal, color: Colors.blue.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Check console output for detailed execution flow',
                      style: TextStyle(color: Colors.blue.shade900),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        if (subtitle.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
        ],
      ],
    );
  }

  Widget _buildComparisonRow(String label, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(description),
          ),
        ],
      ),
    );
  }
}

// Top-level function for compute()
// Must be top-level or static method
int _heavyFactorialCalculation(int n) {
  debugPrint('🔵 [Isolate - compute] Starting factorial calculation for $n');
  final startTime = DateTime.now();

  int result = 1;
  for (int i = 1; i <= n; i++) {
    result *= i;
  }

  final duration = DateTime.now().difference(startTime).inMilliseconds;
  debugPrint('🔵 [Isolate - compute] Calculation complete in ${duration}ms');

  return result;
}

// Entry point for persistent isolate worker
// Must be top-level or static method
void _isolateWorkerEntryPoint(SendPort mainSendPort) {
  debugPrint('🟢 [Worker Isolate] Started! Creating ReceivePort...');

  // Create a ReceivePort in the isolate to receive messages
  final workerReceivePort = ReceivePort();

  // Send our SendPort to the main isolate (handshake)
  mainSendPort.send(workerReceivePort.sendPort);
  debugPrint('🟢 [Worker Isolate] Sent SendPort to main thread (handshake)');

  // Listen for tasks from main isolate
  workerReceivePort.listen((message) {
    debugPrint('🟢 [Worker Isolate] Received task: Calculate factorial($message)');

    final startTime = DateTime.now();

    // Perform heavy computation
    int result = 1;
    for (int i = 1; i <= message; i++) {
      result *= i;
    }

    final duration = DateTime.now().difference(startTime).inMilliseconds;
    debugPrint('🟢 [Worker Isolate] Computation complete: $result (${duration}ms)');

    // Send result back to main isolate
    mainSendPort.send({
      'result': result,
      'duration': duration,
    });
    debugPrint('🟢 [Worker Isolate] Result sent back to main thread');
  });

  debugPrint('🟢 [Worker Isolate] Listening for tasks...');
}
