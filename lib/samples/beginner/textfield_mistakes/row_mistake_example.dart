import 'package:flutter/material.dart';

/// Mistake 1: TextField in Row without Expanded
class RowMistakeExample extends StatelessWidget {
  const RowMistakeExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mistake 1: TextField in Row'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Problem Card
            Card(
              color: Colors.red.shade100,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.error, color: Colors.red),
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
                    Text('TextField in Row has unbounded width → causes crash'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // WRONG Example
            const Text(
              'WRONG - Fixed Width (Cramped)',
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
              'RIGHT - Wrap with Expanded',
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
                    Text('Wrap TextField with Expanded to take available space'),
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
    debugPrint('❌ [WRONG] TextField in Row without Expanded');
    debugPrint('   Fixed width = cramped UI');

    return Row(
      children: [
        SizedBox(
          width: 80, // Fixed width to avoid crash
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Msg',
              isDense: true,
              contentPadding: EdgeInsets.all(8),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Icon(Icons.send, size: 20),
        const SizedBox(width: 4),
        const Text('Cramped!', style: TextStyle(fontSize: 9, color: Colors.red)),
      ],
    );
  }
}

class _RightExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPrint('✅ [RIGHT] TextField wrapped with Expanded');

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
