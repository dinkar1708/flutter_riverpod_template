import 'package:flutter/material.dart';

/// Mistake 2: TextField in Expanded inside Column
class ExpandedMistakeExample extends StatelessWidget {
  const ExpandedMistakeExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mistake 2: TextField in Expanded'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Problem Card
            Card(
              color: Colors.orange.shade100,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.error, color: Colors.orange),
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
                    Text('TextField in Expanded has unbounded height → causes crash'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // WRONG Example
            const Text(
              'WRONG - Single Line Only',
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
              'RIGHT - Set maxLines & expands',
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
                    Text('Set maxLines: null and expands: true to allow expansion'),
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
    debugPrint('❌ [WRONG] TextField in Expanded without maxLines');
    debugPrint('   Single line only - no expansion');

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Header',
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        TextField(
          decoration: const InputDecoration(
            hintText: 'Single line only',
            isDense: true,
            contentPadding: EdgeInsets.all(8),
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'No expansion!',
          style: TextStyle(fontSize: 9, color: Colors.red),
        ),
      ],
    );
  }
}

class _RightExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    debugPrint('✅ [RIGHT] TextField with maxLines: null, expands: true');

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
