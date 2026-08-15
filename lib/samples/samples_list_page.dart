import 'package:flutter/material.dart';

// Beginner examples
import 'package:flutter_riverpod_template/samples/beginner/keys_example.dart';
import 'package:flutter_riverpod_template/samples/beginner/futurebuilder_example.dart';
import 'package:flutter_riverpod_template/samples/beginner/mediaquery_example.dart';
import 'package:flutter_riverpod_template/samples/beginner/lifecycle_methods_example.dart';
import 'package:flutter_riverpod_template/samples/beginner/textfield_common_mistakes_example.dart';
import 'package:flutter_riverpod_template/samples/beginner/expanded_listview_mistake_example.dart';

// Intermediate examples
import 'package:flutter_riverpod_template/samples/intermediate/animation_controller_example.dart';
import 'package:flutter_riverpod_template/samples/intermediate/memory_leak_example.dart';

// Advanced examples
import 'package:flutter_riverpod_template/samples/advanced/custom_painter_example.dart';
import 'package:flutter_riverpod_template/samples/advanced/isolates_example.dart';
import 'package:flutter_riverpod_template/samples/advanced/anr_example.dart';

// Existing codebase examples - cross-referenced
import 'package:flutter_riverpod_template/feature/counter/views/counter_page.dart';
import 'package:flutter_riverpod_template/feature/repository_list/views/repository_list_page.dart';
import 'package:flutter_riverpod_template/feature/users/views/users_page.dart';

class SamplesListPage extends StatelessWidget {
  const SamplesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter FAQ Examples'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Header
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.code,
                          color: Theme.of(context).colorScheme.primary,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Code Examples',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Interactive examples matching FAQ topics',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Beginner Section
          _buildSectionHeader(context, 'Beginner', Icons.school),
          const SizedBox(height: 12),

          _buildExampleCard(
            context,
            title: 'StatefulWidget Lifecycle',
            description: 'initState, dispose, build - with console logs',
            icon: Icons.autorenew,
            color: Colors.deepPurple,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const LifecycleMethodsExample()),
            ),
            codeReference: 'lib/samples/beginner/lifecycle_methods_example.dart',
          ),
          const SizedBox(height: 8),

          _buildExampleCard(
            context,
            title: 'Widget Keys',
            description: 'ValueKey, GlobalKey, UniqueKey - Preserve state',
            icon: Icons.key,
            color: Colors.blue,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const KeysExample()),
            ),
            codeReference: 'lib/samples/beginner/keys_example.dart',
          ),
          const SizedBox(height: 8),

          _buildExampleCard(
            context,
            title: 'FutureBuilder',
            description: 'Handle async data with loading & error states',
            icon: Icons.hourglass_bottom,
            color: Colors.green,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FutureBuilderExample()),
            ),
            codeReference: 'lib/samples/beginner/futurebuilder_example.dart',
          ),
          const SizedBox(height: 8),

          _buildExampleCard(
            context,
            title: 'MediaQuery',
            description: 'Responsive layouts for different screen sizes',
            icon: Icons.devices,
            color: Colors.purple,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MediaQueryExample()),
            ),
            codeReference: 'lib/samples/beginner/mediaquery_example.dart',
          ),
          const SizedBox(height: 8),

          _buildExampleCard(
            context,
            title: 'TextField Common Mistakes',
            description: 'Expanded in Row/Column, overflow issues & fixes',
            icon: Icons.error_outline,
            color: Colors.red,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const TextFieldCommonMistakesExample(),
              ),
            ),
            codeReference: 'lib/samples/beginner/textfield_common_mistakes_example.dart',
          ),
          const SizedBox(height: 8),

          _buildExampleCard(
            context,
            title: 'ListView Unbounded Height',
            description: 'ListView in Column/Expanded - Wrong vs Right way',
            icon: Icons.list_alt,
            color: Colors.deepOrange,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const ExpandedListViewMistakeExample(),
              ),
            ),
            codeReference: 'lib/samples/beginner/expanded_listview_mistake_example.dart',
          ),
          const SizedBox(height: 8),

          _buildExampleCard(
            context,
            title: 'Riverpod State Management',
            description: 'Counter with Riverpod Notifier pattern',
            icon: Icons.add_circle,
            color: Colors.teal,
            isFromCodebase: true,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const CounterPage(title: 'Counter Example'),
              ),
            ),
            codeReference: 'lib/feature/counter/views/counter_page.dart',
          ),

          const SizedBox(height: 24),

          // Intermediate Section
          _buildSectionHeader(context, 'Intermediate', Icons.trending_up),
          const SizedBox(height: 12),

          _buildExampleCard(
            context,
            title: 'Animation Controller',
            description: 'Tween, Curves, AnimatedBuilder with vsync',
            icon: Icons.animation,
            color: Colors.orange,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AnimationControllerExample(),
              ),
            ),
            codeReference: 'lib/samples/intermediate/animation_controller_example.dart',
          ),
          const SizedBox(height: 8),

          _buildExampleCard(
            context,
            title: 'Memory Leaks',
            description: 'Common memory leak patterns (dispose, timers, setState)',
            icon: Icons.memory,
            color: Colors.deepOrange,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const MemoryLeakExample(),
              ),
            ),
            codeReference: 'lib/samples/intermediate/memory_leak_example.dart',
          ),
          const SizedBox(height: 8),

          _buildExampleCard(
            context,
            title: 'Dio + Retrofit API',
            description: 'Real GitHub API with AsyncNotifier',
            icon: Icons.cloud,
            color: Colors.indigo,
            isFromCodebase: true,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const RepositoryListPage(title: 'API Example'),
              ),
            ),
            codeReference: 'lib/feature/repository_list/views/repository_list_page.dart',
          ),
          const SizedBox(height: 8),

          _buildExampleCard(
            context,
            title: 'Search & Filter',
            description: 'Real-time search with Riverpod state',
            icon: Icons.search,
            color: Colors.cyan,
            isFromCodebase: true,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const UsersPage(title: 'Search Example'),
              ),
            ),
            codeReference: 'lib/feature/users/views/users_page.dart',
          ),

          const SizedBox(height: 24),

          // Advanced Section
          _buildSectionHeader(context, 'Advanced', Icons.rocket_launch),
          const SizedBox(height: 12),

          _buildExampleCard(
            context,
            title: 'CustomPainter',
            description: 'Canvas drawing with animations',
            icon: Icons.brush,
            color: Colors.red,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CustomPainterExample()),
            ),
            codeReference: 'lib/samples/advanced/custom_painter_example.dart',
          ),
          const SizedBox(height: 8),

          _buildExampleCard(
            context,
            title: 'Isolates & Concurrency',
            description: 'compute() vs Isolate.spawn with message passing',
            icon: Icons.multitrack_audio,
            color: Colors.purple,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const IsolatesExample()),
            ),
            codeReference: 'lib/samples/advanced/isolates_example.dart',
          ),
          const SizedBox(height: 8),

          _buildExampleCard(
            context,
            title: 'ANR Prevention',
            description: 'Avoid Application Not Responding on Android',
            icon: Icons.warning_amber,
            color: Colors.amber,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AnrExample()),
            ),
            codeReference: 'lib/samples/advanced/anr_example.dart',
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildExampleCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required String codeReference,
    bool isFromCodebase = false,
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
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: color, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                            ),
                            if (isFromCodebase)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Codebase',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        color: Colors.green[700],
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest
                      .withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.code,
                      size: 12,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        codeReference,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              fontFamily: 'monospace',
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
