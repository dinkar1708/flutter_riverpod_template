import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod_template/data/remote/api/providers/user/user_repository_provider.dart';
import 'package:flutter_riverpod_template/feature/repository_list/models/repository_list_model.dart';
import 'package:flutter_riverpod_template/feature/shared/providers/user_session_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repository_list_notifier_provider.g.dart';

@riverpod
class RepositoryListNotifier extends _$RepositoryListNotifier {
  String _currentUserName = 'google';
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  static const int pageSize = 10;

  String get currentUserName => _currentUserName;
  int get currentPage => _currentPage;
  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;

  @override
  Future<List<RepositoryListModel>> build() async {
    _currentPage = 1;
    _hasMore = true;
    _isLoadingMore = false;

    // Watch user session so it defaults to logged in user
    final userSession = await ref.watch(userSessionProvider.future);
    _currentUserName = userSession?.username ?? 'google';

    return await ref
        .read(userRepositoryProvider)
        .getRepositories(_currentUserName, _currentPage, pageSize);
  }

  /// Searches repositories for a specific GitHub username from the API
  Future<void> searchUser(String newUserName) async {
    final sessionUser = (await ref.read(userSessionProvider.future))?.username;
    final target = newUserName.trim().isEmpty
        ? (sessionUser ?? 'google')
        : newUserName.trim();

    _currentUserName = target;
    _currentPage = 1;
    _hasMore = true;
    _isLoadingMore = false;
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      return await ref
          .read(userRepositoryProvider)
          .getRepositories(_currentUserName, _currentPage, pageSize);
    });
  }

  /// Fetches the next page of repositories for the current user and appends to state
  Future<void> fetchNextPage() async {
    if (_isLoadingMore || !_hasMore) return;
    _isLoadingMore = true;

    // Trigger state notification so UI rebuilds and displays bottom loader
    final currentList = state.value ?? [];
    state = AsyncData(List<RepositoryListModel>.from(currentList));

    final nextPage = _currentPage + 1;

    try {
      final newItems = await ref
          .read(userRepositoryProvider)
          .getRepositories(_currentUserName, nextPage, pageSize);

      if (newItems.isEmpty || newItems.length < pageSize) {
        _hasMore = false;
      }

      _currentPage = nextPage;
      state = AsyncData([...currentList, ...newItems]);
      if (kDebugMode) {
        debugPrint(
          '📄 [Pagination] Loaded page $_currentPage for @$_currentUserName (${newItems.length} items)',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint(
          '⚠️ [Pagination] Error loading next page for @$_currentUserName: $e',
        );
      }
    } finally {
      _isLoadingMore = false;
      // Re-trigger state notification to hide bottom loader
      if (state.hasValue) {
        state = AsyncData(List<RepositoryListModel>.from(state.value ?? []));
      }
    }
  }
}
