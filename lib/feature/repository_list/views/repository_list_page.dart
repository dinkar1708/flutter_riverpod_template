import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_template/data/remote/api/providers/user/user_repository_provider.dart';
import 'package:flutter_riverpod_template/feature/repository_list/models/repository_list_model.dart';
import 'package:flutter_riverpod_template/feature/repository_list/views/widgets/sticky_search_header_delegate.dart';
import 'package:flutter_riverpod_template/feature/shared/providers/user_session_provider.dart';
import 'package:flutter_riverpod_template/feature/shared/utils/styles/app_color.dart';
import 'package:flutter_riverpod_template/feature/shared/utils/styles/app_text_style.dart';
import 'package:flutter_riverpod_template/feature/shared/widgets/error_view.dart';
import 'package:flutter_riverpod_template/feature/shared/widgets/shared_sliver_app_bar.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

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
  static const int _pageSize = 10;
  final TextEditingController _searchController = TextEditingController();
  String _currentUserName = 'google';

  late final PagingController<int, RepositoryListModel> _pagingController =
      PagingController(
    getNextPageKey: (state) {
      if (state.pages == null || state.pages!.isEmpty) return 1;
      final lastPage = state.pages!.last;
      if (lastPage.length < _pageSize) return null;
      return state.nextIntPageKey;
    },
    fetchPage: (pageKey) async {
      return await ref.read(userRepositoryProvider).getRepositories(
            _currentUserName,
            pageKey,
            _pageSize,
          );
    },
  );

  @override
  void initState() {
    super.initState();
    final initialUser =
        ref.read(userSessionProvider).value?.username ?? 'google';
    _currentUserName = initialUser;
    _searchController.text = initialUser;
  }

  void _searchUser(String newUserName) {
    final target = newUserName.trim().isEmpty
        ? (ref.read(userSessionProvider).value?.username ?? 'google')
        : newUserName.trim();

    if (_currentUserName != target) {
      setState(() {
        _currentUserName = target;
        _searchController.text = target;
      });
      _pagingController.refresh();
    }
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userSession = ref.watch(userSessionProvider);
    final sessionUsername = userSession.value?.username;
    if (sessionUsername != null &&
        (_searchController.text.isEmpty ||
            _searchController.text == 'google')) {
      _currentUserName = sessionUsername;
      _searchController.text = sessionUsername;
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => _pagingController.refresh(),
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SharedSliverAppBar(
              title: '${widget.title} (@$_currentUserName)',
            ),
            ValueListenableBuilder<PagingState<int, RepositoryListModel>>(
              valueListenable: _pagingController,
              builder: (context, state, _) {
                return SliverPersistentHeader(
                  pinned: true,
                  delegate: StickySearchHeaderDelegate(
                    searchController: _searchController,
                    currentUserName: _currentUserName,
                    totalCount: state.items?.length ?? 0,
                    onSubmitted: _searchUser,
                    onClearSearch: () {
                      _searchController.clear();
                      final defaultUser =
                          ref.read(userSessionProvider).value?.username ??
                              'google';
                      _searchUser(defaultUser);
                    },
                  ),
                );
              },
            ),
            PagingListener(
              controller: _pagingController,
              builder: (context, state, fetchNextPage) =>
                  PagedSliverList<int, RepositoryListModel>(
                state: state,
                fetchNextPage: fetchNextPage,
                builderDelegate:
                    PagedChildBuilderDelegate<RepositoryListModel>(
                  itemBuilder: (context, item, index) =>
                      _buildListRowView(item),
                  firstPageProgressIndicatorBuilder: (context) => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: CircularProgressIndicator.adaptive(),
                    ),
                  ),
                  newPageProgressIndicatorBuilder: (context) => SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator.adaptive(
                                strokeWidth: 2.2,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Loading more repositories...',
                              style: AppTextStyle.labelSmall.copyWith(
                                color: context.color.textSecondary,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  noItemsFoundIndicatorBuilder: (context) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.folder_off_outlined,
                            size: 64,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No repositories found',
                            style: AppTextStyle.labelLarge.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'No public repositories found for @$_currentUserName.',
                            style: AppTextStyle.bodySmall.copyWith(
                              color: context.color.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                  noMoreItemsIndicatorBuilder: (context) => SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Center(
                        child: Text(
                          'No more repositories to load',
                          style: AppTextStyle.labelSmall.copyWith(
                            color: context.color.textSecondary.withValues(
                              alpha: 0.6,
                            ),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  firstPageErrorIndicatorBuilder: (context) => ErrorView(
                    error: state.error ?? 'Unknown error occurred',
                    onRetry: () => _pagingController.refresh(),
                  ),
                  newPageErrorIndicatorBuilder: (context) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Center(
                      child: TextButton.icon(
                        onPressed: fetchNextPage,
                        icon: const Icon(Icons.refresh, size: 16),
                        label: const Text('Failed to load. Tap to retry'),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListRowView(RepositoryListModel model) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: () {
          // Navigate to repository details
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
