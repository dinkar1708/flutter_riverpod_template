import 'package:flutter/material.dart';

/// Solution 2: Use shrinkWrap (Not Recommended)
class ShrinkWrapSolution extends StatelessWidget {
  const ShrinkWrapSolution({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Solution 2: shrinkWrap'),
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Warning Card
            Card(
              color: Colors.orange.shade100,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning, color: Colors.orange),
                        SizedBox(width: 8),
                        Text(
                          'Not Recommended',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text('Only use for small lists - bad for performance'),
                    SizedBox(height: 8),
                    Text(
                      'Code:\n'
                      'ListView.builder(\n'
                      '  shrinkWrap: true,  // ⚠️ Bad for performance\n'
                      '  physics: NeverScrollableScrollPhysics(),\n'
                      '  itemCount: items.length,\n'
                      '  itemBuilder: ...,\n'
                      ')',
                      style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Problem: Creates all items at once (no lazy loading)',
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Live Demo Header
            const Text(
              'Live Demo (Small List):',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),

            // Working Example (small list only)
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.warning, color: Colors.orange, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Header',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 10, // Small list only!
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text('${index + 1}'),
                        ),
                        title: Text('Item ${index + 1}'),
                        subtitle: const Text('Non-scrollable (uses parent scroll)'),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
