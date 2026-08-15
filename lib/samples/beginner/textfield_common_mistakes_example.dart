import 'package:flutter/material.dart';

class TextFieldCommonMistakesExample extends StatelessWidget {
  const TextFieldCommonMistakesExample({super.key});

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

          // Mistake 1: TextField in Row without Expanded
          _buildMistakeSection(
            context,
            mistakeNumber: '1',
            title: 'TextField in Row without Expanded',
            problem: 'TextField has unbounded width in Row',
            solution: 'Wrap TextField with Expanded or set fixed width',
            wrongExample: const WrongExample1(),
            rightExample: const RightExample1(),
          ),

          const SizedBox(height: 16),

          // Mistake 2: Expanded TextField in Column
          _buildMistakeSection(
            context,
            mistakeNumber: '2',
            title: 'TextField in Expanded inside Column',
            problem: 'TextField has unbounded height, causes layout error',
            solution: 'Set maxLines: null and expands: true, or wrap in SizedBox',
            wrongExample: const WrongExample2(),
            rightExample: const RightExample2(),
          ),

          const SizedBox(height: 16),

          // Mistake 3: Multiple Expanded without flex
          _buildMistakeSection(
            context,
            mistakeNumber: '3',
            title: 'Multiple Expanded fields without flex',
            problem: 'Fields have equal width, might not be desired',
            solution: 'Use flex parameter to control proportions',
            wrongExample: const WrongExample3(),
            rightExample: const RightExample3(),
          ),

          const SizedBox(height: 16),

          // Mistake 4: TextField overflow with keyboard
          _buildMistakeSection(
            context,
            mistakeNumber: '4',
            title: 'TextField overflow when keyboard opens',
            problem: 'Bottom overflow when keyboard appears',
            solution: 'Use SingleChildScrollView or resizeToAvoidBottomInset',
            wrongExample: const WrongExample4(),
            rightExample: const RightExample4(),
          ),

          const SizedBox(height: 16),

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

  Widget _buildMistakeSection(
    BuildContext context, {
    required String mistakeNumber,
    required String title,
    required String problem,
    required String solution,
    required Widget wrongExample,
    required Widget rightExample,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      mistakeNumber,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Problem
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Problem: $problem',
                    style: TextStyle(color: Colors.red[700]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Solution
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle_outline, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Solution: $solution',
                    style: TextStyle(color: Colors.green[700]),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Examples
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'WRONG',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: wrongExample,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'RIGHT',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: rightExample,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
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

// MISTAKE 1: TextField in Row without Expanded
class WrongExample1 extends StatelessWidget {
  const WrongExample1({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('❌ [Mistake 1] TextField in Row without Expanded');
    debugPrint('   This will cause: BoxConstraints forces an infinite width');

    // This would cause an error, so we show a placeholder
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '// Row(\n'
          '//   children: [\n'
          '//     TextField(), ❌\n'
          '//     Icon(Icons.send),\n'
          '//   ],\n'
          '// )',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 11,
            color: Colors.red,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Error: Unbounded width',
          style: TextStyle(fontSize: 10, color: Colors.red),
        ),
      ],
    );
  }
}

class RightExample1 extends StatelessWidget {
  const RightExample1({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('✅ [Fix 1] Wrap TextField with Expanded');

    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Message',
              isDense: true,
              contentPadding: EdgeInsets.all(8),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Icon(Icons.send, size: 20),
      ],
    );
  }
}

// MISTAKE 2: Expanded TextField in Column without maxLines
class WrongExample2 extends StatelessWidget {
  const WrongExample2({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('❌ [Mistake 2] WRONG: Expanded + TextField in Column');
    debugPrint('   Column(');
    debugPrint('     children: [');
    debugPrint('       Text("Header"),');
    debugPrint('       Expanded(');
    debugPrint('         child: TextField(), // ❌ ERROR!');
    debugPrint('       ),');
    debugPrint('     ],');
    debugPrint('   )');
    debugPrint('   Error: TextField has unbounded height inside Expanded');

    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Column(\n'
          '  children: [\n'
          '    Text("Header"),\n'
          '    Expanded(\n'
          '      child: TextField(),\n'
          '    ), // ❌ ERROR\n'
          '  ],\n'
          ')',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 10,
            color: Colors.red,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'RenderBox was not laid out',
          style: TextStyle(
            fontSize: 10,
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class RightExample2 extends StatelessWidget {
  const RightExample2({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('✅ [Fix 2] RIGHT: Set maxLines constraint');
    debugPrint('   Column(');
    debugPrint('     children: [');
    debugPrint('       Text("Header"),');
    debugPrint('       Expanded(');
    debugPrint('         child: TextField(');
    debugPrint('           maxLines: null, // ✅ Allows expansion');
    debugPrint('           expands: true,  // ✅ Fills available space');
    debugPrint('         ),');
    debugPrint('       ),');
    debugPrint('     ],');
    debugPrint('   )');

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Header',
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        SizedBox(
          height: 80,
          child: TextField(
            maxLines: null,
            expands: true,
            decoration: const InputDecoration(
              hintText: 'Expandable text',
              isDense: true,
              contentPadding: EdgeInsets.all(8),
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}

// MISTAKE 3: Multiple Expanded without flex
class WrongExample3 extends StatelessWidget {
  const WrongExample3({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('❌ [Mistake 3] Equal width might not be desired');

    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Long field name',
              isDense: true,
              contentPadding: EdgeInsets.all(8),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Zip',
              isDense: true,
              contentPadding: EdgeInsets.all(8),
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}

class RightExample3 extends StatelessWidget {
  const RightExample3({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('✅ [Fix 3] Use flex to control proportions');

    return Row(
      children: [
        Expanded(
          flex: 3,
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'City',
              isDense: true,
              contentPadding: EdgeInsets.all(8),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 4),
        Expanded(
          flex: 1,
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Zip',
              isDense: true,
              contentPadding: EdgeInsets.all(8),
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
  }
}

// MISTAKE 4: TextField overflow with keyboard
class WrongExample4 extends StatelessWidget {
  const WrongExample4({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('❌ [Mistake 4] No scrolling = overflow');

    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '// Scaffold(\n'
          '//   body: Column(\n'
          '//     children: [\n'
          '//       ...many widgets,\n'
          '//       TextField(), ❌\n'
          '//     ],\n'
          '//   ),\n'
          '// )',
          style: TextStyle(
            fontFamily: 'monospace',
            fontSize: 11,
            color: Colors.red,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Error: Bottom overflow',
          style: TextStyle(fontSize: 10, color: Colors.red),
        ),
      ],
    );
  }
}

class RightExample4 extends StatelessWidget {
  const RightExample4({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('✅ [Fix 4] Wrap in SingleChildScrollView');

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Form scrolls when'),
          const Text('keyboard opens'),
          const SizedBox(height: 8),
          TextField(
            decoration: const InputDecoration(
              hintText: 'Email',
              isDense: true,
              contentPadding: EdgeInsets.all(8),
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
