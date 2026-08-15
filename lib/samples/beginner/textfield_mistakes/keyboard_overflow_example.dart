import 'package:flutter/material.dart';

/// Mistake 4: TextField overflow when keyboard opens
class KeyboardOverflowExample extends StatelessWidget {
  const KeyboardOverflowExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mistake 4: Keyboard Overflow'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Problem Card
            Card(
              color: Colors.teal.shade100,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.error, color: Colors.teal),
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
                    Text('Fixed layout causes bottom overflow when keyboard appears'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // WRONG Example
            const Text(
              'WRONG - Fixed Column',
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
              'RIGHT - SingleChildScrollView',
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
                    Text('Wrap content in SingleChildScrollView to allow scrolling'),
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
    debugPrint('❌ [WRONG] Fixed layout - no scrolling');
    debugPrint('   Will overflow when keyboard appears');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('Fixed Column'),
        const Text('Cannot scroll'),
        const SizedBox(height: 8),
        TextField(
          decoration: const InputDecoration(
            hintText: 'Email',
            isDense: true,
            contentPadding: EdgeInsets.all(8),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Keyboard = Overflow!',
          style: TextStyle(fontSize: 9, color: Colors.red),
        ),
      ],
    );
  }
}

class _RightExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPrint('✅ [RIGHT] Wrapped in SingleChildScrollView');

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
