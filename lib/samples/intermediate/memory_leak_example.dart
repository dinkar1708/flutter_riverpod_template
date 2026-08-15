import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/samples/intermediate/memory-leak/controller_leak_example.dart';
import 'package:flutter_riverpod_template/samples/intermediate/memory-leak/timer_leak_example.dart';
import 'package:flutter_riverpod_template/samples/intermediate/memory-leak/async_leak_example.dart';
import 'package:flutter_riverpod_template/samples/intermediate/memory-leak/stream_leak_example.dart';
import 'package:flutter_riverpod_template/samples/intermediate/memory-leak/listener_leak_example.dart';
import 'package:flutter_riverpod_template/samples/intermediate/memory-leak/focusnode_leak_example.dart';

class MemoryLeakExample extends StatelessWidget {
  const MemoryLeakExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Memory Leak Examples')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          Card(
            color: Theme.of(context).colorScheme.errorContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.memory,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Common Memory Leaks',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Check console to see memory leak detection logs.\n\n'
                    'Use Flutter DevTools Memory tab to:\n'
                    '- View memory snapshots before/after navigation\n'
                    '- Compare heap allocations to find undisposed objects\n'
                    '- Track growing memory usage over time',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Example 1: TextEditingController not disposed
          _buildExampleCard(
            context,
            title: '1. TextEditingController Not Disposed',
            description: 'Forgetting to dispose controllers causes memory leaks',
            buttonText: 'Open BAD Example (Memory Leak)',
            onTap: () {
              debugPrint('🔴 Opening WRONG example - will cause memory leak');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TextControllerLeakExample(),
                ),
              );
            },
            isWrong: true,
          ),

          const SizedBox(height: 12),

          _buildExampleCard(
            context,
            title: '1. TextEditingController Properly Disposed',
            description: 'Always dispose controllers in dispose() method',
            buttonText: 'Open GOOD Example (No Leak)',
            onTap: () {
              debugPrint('✅ Opening RIGHT example - properly disposes');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TextControllerGoodExample(),
                ),
              );
            },
            isWrong: false,
          ),

          const SizedBox(height: 24),

          // Example 2: Timer not cancelled
          _buildExampleCard(
            context,
            title: '2. Timer/Stream Not Cancelled',
            description: 'Timers keep running even after widget is disposed',
            buttonText: 'Open BAD Example (Timer Leak)',
            onTap: () {
              debugPrint('🔴 Opening WRONG example - timer never stops');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TimerLeakExample(),
                ),
              );
            },
            isWrong: true,
          ),

          const SizedBox(height: 12),

          _buildExampleCard(
            context,
            title: '2. Timer Properly Cancelled',
            description: 'Cancel timers in dispose() method',
            buttonText: 'Open GOOD Example (Timer Cancelled)',
            onTap: () {
              debugPrint('✅ Opening RIGHT example - cancels timer');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TimerGoodExample(),
                ),
              );
            },
            isWrong: false,
          ),

          const SizedBox(height: 24),

          // Example 3: setState after dispose
          _buildExampleCard(
            context,
            title: '3. setState() After dispose()',
            description: 'Calling setState on disposed widget causes errors',
            buttonText: 'Open BAD Example (setState Error)',
            onTap: () {
              debugPrint('🔴 Opening WRONG example - setState after dispose');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SetStateAfterDisposeExample(),
                ),
              );
            },
            isWrong: true,
          ),

          const SizedBox(height: 12),

          _buildExampleCard(
            context,
            title: '3. Check mounted Before setState()',
            description: 'Always check mounted before async setState',
            buttonText: 'Open GOOD Example (mounted Check)',
            onTap: () {
              debugPrint('✅ Opening RIGHT example - checks mounted');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MountedCheckExample(),
                ),
              );
            },
            isWrong: false,
          ),

          const SizedBox(height: 24),

          // Example 4: StreamSubscription not cancelled
          _buildExampleCard(
            context,
            title: '4. StreamSubscription Not Cancelled',
            description: 'Stream keeps listening even after widget disposal',
            buttonText: 'Open BAD Example (Stream Leak)',
            onTap: () {
              debugPrint('🔴 Opening WRONG example - stream never cancelled');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const StreamLeakExample(),
                ),
              );
            },
            isWrong: true,
          ),

          const SizedBox(height: 12),

          _buildExampleCard(
            context,
            title: '4. StreamSubscription Properly Cancelled',
            description: 'Cancel stream subscriptions in dispose()',
            buttonText: 'Open GOOD Example (Stream Cancelled)',
            onTap: () {
              debugPrint('✅ Opening RIGHT example - cancels stream');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const StreamGoodExample(),
                ),
              );
            },
            isWrong: false,
          ),

          const SizedBox(height: 24),

          // Example 5: Listener not removed
          _buildExampleCard(
            context,
            title: '5. Listener Not Removed',
            description: 'addListener() without removeListener() causes leaks',
            buttonText: 'Open BAD Example (Listener Leak)',
            onTap: () {
              debugPrint('🔴 Opening WRONG example - listener not removed');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ListenerLeakExample(),
                ),
              );
            },
            isWrong: true,
          ),

          const SizedBox(height: 12),

          _buildExampleCard(
            context,
            title: '5. Listener Properly Removed',
            description: 'Always removeListener() before dispose()',
            buttonText: 'Open GOOD Example (Listener Removed)',
            onTap: () {
              debugPrint('✅ Opening RIGHT example - removes listener');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ListenerGoodExample(),
                ),
              );
            },
            isWrong: false,
          ),

          const SizedBox(height: 24),

          // Example 6: FocusNode not disposed
          _buildExampleCard(
            context,
            title: '6. FocusNode Not Disposed',
            description: 'FocusNode must be disposed like controllers',
            buttonText: 'Open BAD Example (FocusNode Leak)',
            onTap: () {
              debugPrint('🔴 Opening WRONG example - FocusNode not disposed');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FocusNodeLeakExample(),
                ),
              );
            },
            isWrong: true,
          ),

          const SizedBox(height: 12),

          _buildExampleCard(
            context,
            title: '6. FocusNode Properly Disposed',
            description: 'Dispose FocusNode in dispose() method',
            buttonText: 'Open GOOD Example (FocusNode Disposed)',
            onTap: () {
              debugPrint('✅ Opening RIGHT example - disposes FocusNode');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FocusNodeGoodExample(),
                ),
              );
            },
            isWrong: false,
          ),

          const SizedBox(height: 24),

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
                        Icons.lightbulb,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'How to Detect Memory Leaks',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInfoItem('1. Check console logs for warnings'),
                  _buildInfoItem('2. Use Flutter DevTools Memory tab'),
                  _buildInfoItem('3. Take heap snapshots before/after navigation'),
                  _buildInfoItem('4. Look for increasing instance counts'),
                  _buildInfoItem('5. Always dispose in dispose() method'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExampleCard(
    BuildContext context, {
    required String title,
    required String description,
    required String buttonText,
    required VoidCallback onTap,
    required bool isWrong,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isWrong ? Icons.error : Icons.check_circle,
                  color: isWrong ? Colors.red : Colors.green,
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
            const SizedBox(height: 8),
            Text(description, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isWrong ? Colors.red : Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: Text(buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.arrow_right, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }
}
