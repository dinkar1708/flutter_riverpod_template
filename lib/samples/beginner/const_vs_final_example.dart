import 'package:flutter/material.dart';

/// Const vs Final Example - Understand the difference
class ConstVsFinalExample extends StatefulWidget {
  const ConstVsFinalExample({super.key});

  @override
  State<ConstVsFinalExample> createState() => _ConstVsFinalExampleState();
}

class _ConstVsFinalExampleState extends State<ConstVsFinalExample> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    debugPrint('🔄 [BUILD] Main build called - counter: $_counter');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Const vs Final'),
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Explanation Card
          Card(
            color: Colors.teal.shade50,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info, color: Colors.teal),
                      SizedBox(width: 8),
                      Text(
                        'Const vs Final',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text('final - Runtime constant (assigned once)'),
                  Text('const - Compile-time constant (immutable)'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Counter Button
          ElevatedButton(
            onPressed: () {
              setState(() {
                _counter++;
              });
            },
            child: Text('Increment Counter: $_counter'),
          ),
          const SizedBox(height: 16),

          // Without const - Rebuilds every time
          Card(
            color: Colors.red.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.close, color: Colors.red),
                      SizedBox(width: 8),
                      Text(
                        'Without const',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  _NonConstWidget(), // ❌ Rebuilds on every setState
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // With const - Does NOT rebuild
          Card(
            color: Colors.green.shade50,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.check, color: Colors.green),
                      SizedBox(width: 8),
                      Text(
                        'With const',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  _ConstWidget(), // ✅ Does NOT rebuild!
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Examples Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Code Examples',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 12),
                  _buildCodeExample(
                    'final',
                    'final name = "John";\n'
                        'final now = DateTime.now();\n'
                        '// Can be set at runtime',
                    Colors.blue,
                  ),
                  const SizedBox(height: 12),
                  _buildCodeExample(
                    'const',
                    'const pi = 3.14;\n'
                        'const widget = Text("Hi");\n'
                        '// Must be known at compile-time',
                    Colors.purple,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Performance Card
          Card(
            color: Colors.orange.shade50,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.speed, color: Colors.orange),
                      SizedBox(width: 8),
                      Text(
                        'Performance Tip',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text('Use const widgets to prevent rebuilds'),
                  Text('Saves memory and improves performance'),
                  SizedBox(height: 8),
                  Text(
                    'Tap counter above and check console logs',
                    style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeExample(String title, String code, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(
            code,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 11,
            ),
          ),
        ),
      ],
    );
  }
}

// Without const - rebuilds every time
class _NonConstWidget extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _NonConstWidget(); // No const constructor (intentionally non-const for demo)

  @override
  Widget build(BuildContext context) {
    debugPrint('❌ [REBUILD] _NonConstWidget rebuilt!');
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'I rebuild every time (check console)',
        style: TextStyle(fontSize: 12),
      ),
    );
  }
}

// With const - does NOT rebuild
class _ConstWidget extends StatelessWidget {
  const _ConstWidget(); // const constructor

  @override
  Widget build(BuildContext context) {
    debugPrint('✅ [NO REBUILD] _ConstWidget - only builds once!');
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Text(
        'I do NOT rebuild (check console)',
        style: TextStyle(fontSize: 12),
      ),
    );
  }
}
