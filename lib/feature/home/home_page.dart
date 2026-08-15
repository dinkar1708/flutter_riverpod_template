import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/feature/shared/navigation/app_router.gr.dart';
import 'package:flutter_riverpod_template/samples/samples_list_page.dart';

@RoutePage()
class HomePage extends ConsumerStatefulWidget {
  const HomePage({required this.title, super.key});
  final String title;

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          Semantics(
            identifier: 'home_settings_button',
            label: 'Settings',
            button: true,
            child: IconButton(
            onPressed: () => context.router.push(const SettingsRoute()),
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
          ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Welcome Card
          Semantics(
            identifier: 'home_welcome_card',
            label:
                'Welcome Back! Ready to explore? Check out the features below',
            explicitChildNodes: true,
            child: Card(
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
                          Icons.home_rounded,
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
                              'Welcome Back!',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            Semantics(
                              identifier: 'home_welcome_subtitle',
                              label:
                                  'Ready to explore? Check out the features below',
                              child: Text(
                                'Ready to explore? Check out the features below',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
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
          ),

          const SizedBox(height: 24),

          // Features Section Header
          Semantics(
            identifier: 'home_features_header',
            header: true,
            child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              'Features',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          ),
          const SizedBox(height: 12),

          // Explore Samples Card (Featured)
          _buildFeatureCard(
            context,
            semanticsId: 'home_feature_explore_samples',
            icon: Icons.lightbulb_outline_rounded,
            title: 'Explore Code Samples',
            description: 'Interactive examples from Flutter FAQ documentation',
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SamplesListPage()),
            ),
            isHighlighted: true,
          ),
          const SizedBox(height: 12),

          // Feature Cards
          _buildFeatureCard(
            context,
            semanticsId: 'home_feature_api_integration',
            icon: Icons.code_rounded,
            title: 'API Integration',
            description: 'Real-time GitHub API with Retrofit & Dio',
            onTap: () => context.router.push(
              RepositoryListRoute(title: 'Repositories'),
            ),
          ),
          const SizedBox(height: 12),

          _buildFeatureCard(
            context,
            semanticsId: 'home_feature_search_filter',
            icon: Icons.search_rounded,
            title: 'Search & Filter',
            description: 'Dynamic search with Riverpod state management',
            onTap: () => context.router.push(
              UsersRoute(title: 'Search Users'),
            ),
          ),
          const SizedBox(height: 12),

          _buildFeatureCard(
            context,
            semanticsId: 'home_feature_state_management',
            icon: Icons.add_circle_outline_rounded,
            title: 'State Management',
            description: 'Reactive state with Riverpod providers',
            onTap: () => context.router.push(
              CounterRoute(title: 'Counter'),
            ),
          ),
          const SizedBox(height: 12),

          _buildFeatureCard(
            context,
            semanticsId: 'home_feature_auto_route_navigation',
            icon: Icons.navigation_rounded,
            title: 'Auto Route Navigation',
            description: 'Type-safe routing with nested navigation',
            onTap: () => context.router.push(
              NavigationRoute(title: 'Navigation'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required String semanticsId,
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
    bool isHighlighted = false,
  }) {
    return Semantics(
      identifier: semanticsId,
      label: title,
      button: true,
      child: Card(
      elevation: isHighlighted ? 4 : null,
      color: isHighlighted
          ? Theme.of(context).colorScheme.primaryContainer
          : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isHighlighted
                      ? Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.2)
                      : Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
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
                            fontWeight: FontWeight.w600,
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
              Icon(
                Icons.chevron_right_rounded,
                color: Theme.of(context).colorScheme.secondary,
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }
}
