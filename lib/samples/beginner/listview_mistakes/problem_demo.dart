import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/samples/beginner/listview_mistakes/wrong_example.dart';
import 'package:flutter_riverpod_template/samples/beginner/listview_mistakes/right_example.dart';

/// Problem Demo: ListView without constraints - Navigate to WRONG vs RIGHT
class ProblemDemo extends StatelessWidget {
  const ProblemDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Problem: Unbounded Height'),
        backgroundColor: Colors.orange,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Problem Explanation
          Card(
            color: Colors.orange.shade100,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info, color: Colors.orange),
                      SizedBox(width: 8),
                      Text(
                        'The Problem',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text('ListView in Column without height constraint causes:'),
                  SizedBox(height: 4),
                  Text(
                    '"Vertical viewport was given unbounded height"',
                    style: TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 12,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text('Compare WRONG vs RIGHT implementations below'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // WRONG Example Card
          _buildComparisonCard(
            context,
            title: 'WRONG - No Height Constraint',
            description: 'Using shrinkWrap (bad performance)',
            problems: [
              'Creates all items at once',
              'Bad for large lists',
              'No lazy loading',
            ],
            color: Colors.red,
            icon: Icons.error,
            onTap: () {
              debugPrint('🔴 [WRONG] Opening ListView without Expanded');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ListViewWrongExample(),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // RIGHT Example Card
          _buildComparisonCard(
            context,
            title: 'RIGHT - With Expanded',
            description: 'Recommended solution',
            problems: [
              'Constrains height properly',
              'Lazy loads items',
              'Efficient scrolling',
            ],
            color: Colors.green,
            icon: Icons.check_circle,
            onTap: () {
              debugPrint('✅ [RIGHT] Opening ListView with Expanded');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ListViewRightExample(),
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Code Comparison
          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.code, color: Colors.blue),
                      SizedBox(width: 8),
                      Text(
                        'Code Comparison',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildCodeSection(
                    'WRONG',
                    'Column(\n'
                        '  children: [\n'
                        '    Text("Header"),\n'
                        '    ListView.builder(  // ❌ ERROR!\n'
                        '      itemCount: 10,\n'
                        '      itemBuilder: ...,\n'
                        '    ),\n'
                        '  ],\n'
                        ')',
                    Colors.red,
                  ),
                  const SizedBox(height: 16),
                  _buildCodeSection(
                    'RIGHT',
                    'Column(\n'
                        '  children: [\n'
                        '    Text("Header"),\n'
                        '    Expanded(  // ✅ CORRECT!\n'
                        '      child: ListView.builder(\n'
                        '        itemCount: 10,\n'
                        '        itemBuilder: ...,\n'
                        '      ),\n'
                        '    ),\n'
                        '  ],\n'
                        ')',
                    Colors.green,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonCard(
    BuildContext context, {
    required String title,
    required String description,
    required List<String> problems,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  const SizedBox(width: 12),
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
                        Text(
                          description,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: color),
                ],
              ),
              const SizedBox(height: 12),
              ...problems.map((problem) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      children: [
                        Icon(
                          color == Colors.red ? Icons.close : Icons.check,
                          color: color,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            problem,
                            style: TextStyle(fontSize: 13, color: color.withValues(alpha: 0.8)),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCodeSection(String label, String code, Color color) {
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
            label,
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
            border: Border.all(color: color.withValues(alpha: 0.3)),
            borderRadius: BorderRadius.circular(8),
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
