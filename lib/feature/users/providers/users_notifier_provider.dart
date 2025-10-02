import 'package:flutter_riverpod_template/feature/users/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod_template/feature/users/providers/users_filter_parameter_notifier.dart';
import 'package:riverpod/riverpod.dart';

part 'users_notifier_provider.g.dart';

@riverpod
class UsersNotifierProvider extends _$UsersNotifierProvider {
  @override
  Future<List<UserModel>> build() async {
    // TODO read from api later
    return Future.value([
      UserModel(id: 1, name: 'dinkar1708'),
      UserModel(id: 2, name: 'suji'),
    ]);
  }
}

/// Exposes the filtered users list based on filter parameter notifier
@riverpod
AsyncValue<List<UserModel>> filteredUsers(Ref ref) {
  final filter = ref.watch(usersFilterParameterNotifierProvider);
  final query = filter.query.trim().toLowerCase();
  final usersAsync = ref.watch(usersNotifierProviderProvider);

  if (query.isEmpty) return usersAsync;

  return usersAsync.whenData((list) {
    return list
        .where((u) => u.name.toLowerCase().contains(query))
        .toList(growable: false);
  });
}
