import 'package:flutter_riverpod_template/data/remote/api/providers/user/user_repository_provider.dart';
import 'package:flutter_riverpod_template/feature/repository_list/models/repository_list_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repository_list_notifier_provider.g.dart';

@riverpod
class RepositoryListNotifier extends _$RepositoryListNotifier {
  final userName = 'dinkar1708';
  final pageSize = 5;

  @override
  Future<List<RepositoryListModel>> build() async => await ref
      .read(userRepositoryProvider)
      .getRepositories(userName, pageSize);
}
