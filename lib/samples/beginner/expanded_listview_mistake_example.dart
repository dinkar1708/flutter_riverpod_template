import 'package:flutter/material.dart';

class ExpandedListViewMistakeExample extends StatelessWidget {
  const ExpandedListViewMistakeExample({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('❌ ListView in Column without Expanded causes:');
    debugPrint('   "Vertical viewport was given unbounded height"');
    debugPrint('');
    debugPrint('✅ ListView is properly constrained with Expanded');

    return Scaffold(
      appBar: AppBar(title: const Text('ListView in Expanded - Common Mistake')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                          Icons.warning_amber,
                          color: Theme.of(context).colorScheme.error,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'ListView Unbounded Height Error',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'ListView inside Column/Expanded needs height constraint',
                      style: TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Wrong Example
            Text(
              'WRONG - Causes Error:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                border: Border.all(color: Colors.red),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Column(\n'
                    '  children: [\n'
                    '    Text("Header"),\n'
                    '    ListView.builder(  // ❌ ERROR!\n'
                    '      itemCount: 20,\n'
                    '      itemBuilder: ...,\n'
                    '    ),\n'
                    '  ],\n'
                    ')',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.red.withValues(alpha: 0.2),
                    child: const Text(
                      'Error: Vertical viewport was given unbounded height',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Why? ListView tries to determine its height but Column '
                    'gives it infinite space',
                    style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Right Example
            Text(
              'RIGHT - 3 Solutions:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),

            // Solution 1
            _buildSolution(
              context,
              number: '1',
              title: 'Use Expanded',
              code: 'Column(\n'
                  '  children: [\n'
                  '    Text("Header"),\n'
                  '    Expanded(  // ✅ Constraints height\n'
                  '      child: ListView.builder(...),\n'
                  '    ),\n'
                  '  ],\n'
                  ')',
            ),

            const SizedBox(height: 12),

            // Solution 2
            _buildSolution(
              context,
              number: '2',
              title: 'Use shrinkWrap (Not Recommended)',
              code: 'ListView.builder(\n'
                  '  shrinkWrap: true,  // ⚠️ Bad for performance\n'
                  '  physics: NeverScrollableScrollPhysics(),\n'
                  '  itemCount: items.length,\n'
                  '  itemBuilder: ...,\n'
                  ')',
              warning: 'Only use for small lists. Creates all items at once.',
            ),

            const SizedBox(height: 12),

            // Solution 3
            _buildSolution(
              context,
              number: '3',
              title: 'Use SizedBox with Fixed Height',
              code: 'SizedBox(\n'
                  '  height: 300,  // ✅ Fixed height\n'
                  '  child: ListView.builder(...),\n'
                  ')',
            ),

            const SizedBox(height: 24),

            // Live Demo
            Text(
              'Live Demo - Working Solution:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),

            // Correct implementation - Demo with fixed height
            SizedBox(
              height: 350,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        border: Border(
                          bottom: BorderSide(color: Colors.green.withValues(alpha: 0.3)),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.list, color: Colors.green, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'List with Expanded (Scrollable)',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: 30,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            debugPrint('✅ ListView is properly constrained with Expanded');
                          }
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.green.withValues(alpha: 0.2),
                              child: Text('${index + 1}'),
                            ),
                            title: Text('Item ${index + 1}'),
                            subtitle: const Text('This list scrolls properly'),
                            dense: true,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSolution(
    BuildContext context, {
    required String number,
    required String title,
    required String code,
    String? warning,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: warning != null
            ? Colors.orange.withValues(alpha: 0.1)
            : Colors.green.withValues(alpha: 0.1),
        border: Border.all(
          color: warning != null ? Colors.orange : Colors.green,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: warning != null ? Colors.orange : Colors.green,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    number,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            code,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 11,
              color: Colors.black87,
            ),
          ),
          if (warning != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning, size: 16, color: Colors.orange),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      warning,
                      style: const TextStyle(fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
