import 'package:flutter/material.dart';
import 'package:flutter_riverpod_template/samples/beginner/listview_mistakes/problem_demo.dart';
import 'package:flutter_riverpod_template/samples/beginner/listview_mistakes/expanded_solution.dart';
import 'package:flutter_riverpod_template/samples/beginner/listview_mistakes/shrinkwrap_solution.dart';
import 'package:flutter_riverpod_template/samples/beginner/listview_mistakes/sizedbox_solution.dart';

class ListViewMistakesExample extends StatelessWidget {
  const ListViewMistakesExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ListView Unbounded Height')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Problem Card
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
                    'Problem: ListView inside Column/Expanded needs height constraint',
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Problem Demo
          _buildProblemCard(
            context,
            title: 'See the Problem (Error Demo)',
            description: 'Visual demonstration of unbounded height error',
            color: Colors.red,
            onTap: () {
              debugPrint('🔴 [PROBLEM] Opening error demonstration');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ProblemDemo(),
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Solutions Header
          Text(
            'Solutions:',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),

          // Solution 1: Expanded
          _buildSolutionCard(
            context,
            number: '1',
            title: 'Use Expanded (Recommended)',
            description: 'Constraints height, efficient scrolling',
            color: Colors.green,
            onTap: () {
              debugPrint('✅ [SOLUTION 1] Opening Expanded solution');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ExpandedSolution(),
                ),
              );
            },
          ),
          const SizedBox(height: 12),

          // Solution 2: ShrinkWrap
          _buildSolutionCard(
            context,
            number: '2',
            title: 'Use shrinkWrap (Not Recommended)',
            description: 'Bad for performance - creates all items at once',
            color: Colors.orange,
            onTap: () {
              debugPrint('⚠️ [SOLUTION 2] Opening ShrinkWrap solution');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ShrinkWrapSolution(),
                ),
              );
            },
          ),
          const SizedBox(height: 12),

          // Solution 3: SizedBox
          _buildSolutionCard(
            context,
            number: '3',
            title: 'Use SizedBox with Fixed Height',
            description: 'Good when you know the exact height needed',
            color: Colors.blue,
            onTap: () {
              debugPrint('✅ [SOLUTION 3] Opening SizedBox solution');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SizedBoxSolution(),
                ),
              );
            },
          ),

          const SizedBox(height: 24),

          // Recommendation Card
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
                        Icons.lightbulb,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Best Practice',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildBestPractice('Use Expanded when ListView is part of a layout'),
                  _buildBestPractice('Avoid shrinkWrap for large lists (performance)'),
                  _buildBestPractice('Use SizedBox when you know the exact height'),
                  _buildBestPractice('Always constrain ListView in Column/Row'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSolutionCard(
    BuildContext context, {
    required String number,
    required String title,
    required String description,
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
        ),
      ),
    );
  }

  Widget _buildProblemCard(
    BuildContext context, {
    required String title,
    required String description,
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
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.error_outline, color: color, size: 30),
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
