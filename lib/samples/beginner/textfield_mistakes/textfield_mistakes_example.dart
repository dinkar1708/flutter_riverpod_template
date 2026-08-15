import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/samples/beginner/textfield_mistakes/row_mistake_example.dart';
import 'package:flutter_riverpod_template/samples/beginner/textfield_mistakes/expanded_mistake_example.dart';
import 'package:flutter_riverpod_template/samples/beginner/textfield_mistakes/flex_mistake_example.dart';
import 'package:flutter_riverpod_template/samples/beginner/textfield_mistakes/keyboard_overflow_example.dart';

class TextFieldMistakesExample extends StatelessWidget {
  const TextFieldMistakesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TextField Common Mistakes')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header Card
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
                        Icons.warning_amber_rounded,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Common TextField Mistakes',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Learn what NOT to do and how to fix it',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Mistake 1: TextField in Row
          _buildMistakeCard(
            context,
            number: '1',
            title: 'TextField in Row',
            problem: 'Unbounded width → crash',
            solution: 'Wrap with Expanded',
            color: Colors.red,
            onTap: () {
              debugPrint('🔴 [MISTAKE 1] Opening TextField in Row example');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const RowMistakeExample(),
                ),
              );
            },
          ),
          const SizedBox(height: 12),

          // Mistake 2: TextField in Expanded
          _buildMistakeCard(
            context,
            number: '2',
            title: 'TextField in Expanded',
            problem: 'Unbounded height → crash',
            solution: 'Set maxLines: null, expands: true',
            color: Colors.orange,
            onTap: () {
              debugPrint('🔴 [MISTAKE 2] Opening TextField in Expanded example');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ExpandedMistakeExample(),
                ),
              );
            },
          ),
          const SizedBox(height: 12),

          // Mistake 3: Multiple Expanded
          _buildMistakeCard(
            context,
            number: '3',
            title: 'Multiple Expanded',
            problem: 'Equal width (not ideal)',
            solution: 'Use flex for proportions',
            color: Colors.purple,
            onTap: () {
              debugPrint('🔴 [MISTAKE 3] Opening Multiple Expanded example');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const FlexMistakeExample(),
                ),
              );
            },
          ),
          const SizedBox(height: 12),

          // Mistake 4: Keyboard Overflow
          _buildMistakeCard(
            context,
            number: '4',
            title: 'Keyboard Overflow',
            problem: 'Fixed layout → overflow',
            solution: 'Wrap in SingleChildScrollView',
            color: Colors.teal,
            onTap: () {
              debugPrint('🔴 [MISTAKE 4] Opening Keyboard Overflow example');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const KeyboardOverflowExample(),
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // Best Practices Card
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
                        Icons.check_circle,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Best Practices',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildBestPractice('Always constrain TextField dimensions'),
                  _buildBestPractice('Use Expanded in Row, maxLines in Column'),
                  _buildBestPractice('Set appropriate flex values'),
                  _buildBestPractice('Wrap forms in SingleChildScrollView'),
                  _buildBestPractice('Use TextEditingController and dispose it'),
                  _buildBestPractice('Check mounted before setState after async'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMistakeCard(
    BuildContext context, {
    required String number,
    required String title,
    required String problem,
    required String solution,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    number,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 16),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            problem,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.red[700],
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.check_circle_outline, color: Colors.green, size: 16),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            solution,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Colors.green[700],
                                ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: color),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBestPractice(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.arrow_right, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
