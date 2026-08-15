import 'package:flutter/material.dart';

/// Mistake 3: Multiple Expanded without flex
class FlexMistakeExample extends StatelessWidget {
  const FlexMistakeExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mistake 3: Multiple Expanded'),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Problem Card
            Card(
              color: Colors.purple.shade100,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.error, color: Colors.purple),
                        SizedBox(width: 8),
                        Text(
                          'Problem',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text('Multiple Expanded with equal width - not ideal for UX'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // WRONG Example
            const Text(
              'WRONG - Equal Width (50/50)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _WrongExample(),
              ),
            ),
            const SizedBox(height: 24),

            // RIGHT Example
            const Text(
              'RIGHT - Use flex (75/25)',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _RightExample(),
              ),
            ),
            const SizedBox(height: 24),

            // Solution Card
            Card(
              color: Colors.green.shade100,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green),
                        SizedBox(width: 8),
                        Text(
                          'Solution',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text('Use flex parameter to control proportions (e.g., flex: 3 and flex: 1)'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WrongExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPrint('❌ [WRONG] Multiple Expanded without flex');
    debugPrint('   Equal width might not be desired');

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

class _RightExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPrint('✅ [RIGHT] Using flex to control proportions');

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
