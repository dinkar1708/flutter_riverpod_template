import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/feature/repository_list/models/repository_list_model.dart';
import 'package:flutter_riverpod_template/feature/repository_list/providers/repository_list_notifier_provider.dart';
import 'package:flutter_riverpod_template/feature/shared/providers/user_session_provider.dart';
import 'package:flutter_riverpod_template/feature/shared/utils/styles/app_color.dart';
import 'package:flutter_riverpod_template/feature/shared/utils/styles/app_text_style.dart';
import 'package:flutter_riverpod_template/feature/shared/widgets/error_view.dart';
import 'package:flutter_riverpod_template/feature/shared/widgets/shared_sliver_app_bar.dart';

@RoutePage()
class RepositoryListPage extends ConsumerStatefulWidget {
  final String title;

  const RepositoryListPage({
    required this.title,
    super.key,
  });

  @override
  ConsumerState<RepositoryListPage> createState() => _RepositoryListPageState();
}

class _RepositoryListPageState extends ConsumerState<RepositoryListPage> {
  @override
  Widget build(BuildContext context) {
    final userSession = ref.watch(userSessionProvider);
    final userName = userSession?.username ?? 'google';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SharedSliverAppBar(
            title: '${widget.title} ($userName)',
          ),
          _buildListRootView(),
        ],
      ),
    );
  }

  Widget _buildListRootView() {
    // keep watching, contininouse changes observation
    final repositoryListAsync = ref.watch(repositoryListProvider);
    return switch (repositoryListAsync) {
      AsyncError(:final error) => SliverFillRemaining(
          child: ErrorView(
            error: error,
            onRetry: () => ref.invalidate(repositoryListProvider),
          ),
        ),
      AsyncData(:final value) => _buildListView(value),
      _ => const SliverToBoxAdapter(child: Center(child: Text('Loading...'))),
    };
  }

  Widget _buildListView(List<RepositoryListModel> modelList) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          final entry = modelList[index];
          return _buildListRowView(entry);
        },
        childCount: modelList.length,
      ),
    );
  }

  Widget _buildListRowView(RepositoryListModel model) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to repository details
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Repository Name with Icon
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.folder_rounded,
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      model.name,
                      style: AppTextStyle.labelLarge.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              // Description
              if (model.description != null &&
                  model.description!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  model.description!,
                  style: AppTextStyle.bodySmall.copyWith(
                    color: context.color.textPrimary.withValues(alpha: 0.7),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              const SizedBox(height: 12),

              // Stats Row
              Row(
                children: [
                  // Stars
                  _buildStat(
                    context,
                    Icons.star_outline,
                    model.stargazersCount?.toString() ?? '0',
                    Colors.amber,
                  ),
                  const SizedBox(width: 16),

                  // Forks
                  _buildStat(
                    context,
                    Icons.fork_right,
                    model.forksCount?.toString() ?? '0',
                    Colors.blue,
                  ),
                  const SizedBox(width: 16),

                  // Language
                  if (model.language != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        model.language!,
                        style: AppTextStyle.bodySmall.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],

                  const Spacer(),

                  // Arrow Icon
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: context.color.textSecondary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(
    BuildContext context,
    IconData icon,
    String count,
    Color color,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          count,
          style: AppTextStyle.bodySmall.copyWith(
            color: context.color.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
