import 'package:flutter_riverpod_template/data/remote/api/providers/user/user_repository_provider.dart';
import 'package:flutter_riverpod_template/feature/repository_list/models/repository_list_model.dart';
import 'package:flutter_riverpod_template/feature/shared/providers/user_session_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repository_list_notifier_provider.g.dart';

@riverpod
class RepositoryListNotifier extends _$RepositoryListNotifier {
  final pageSize = 5;

  @override
  Future<List<RepositoryListModel>> build() async {
    // Watch user session so it refreshes when user logs in/out
    final userSession = ref.watch(userSessionProvider);
    final userName = userSession?.username ?? 'google'; // Default to 'google' if not logged in

    return await ref
        .read(userRepositoryProvider)
        .getRepositories(userName, pageSize);
  }
}
