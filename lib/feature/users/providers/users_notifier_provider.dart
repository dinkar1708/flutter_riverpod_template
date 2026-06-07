import 'package:flutter_riverpod_template/feature/shared/providers/user_session_provider.dart';
import 'package:flutter_riverpod_template/feature/users/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod_template/feature/users/providers/users_filter_parameter_notifier.dart';

part 'users_notifier_provider.g.dart';

@riverpod
class UsersNotifierProvider extends _$UsersNotifierProvider {
  @override
  Future<List<UserModel>> build() async {
    // Watch user session so it refreshes when user logs in/out
    final userSession = ref.watch(userSessionProvider);
    final loggedInUser = userSession?.username ?? 'google';

    // TODO read from api later
    return Future.value([
      UserModel(id: 1, name: loggedInUser),
      UserModel(id: 2, name: 'Demo User'),
    ]);
  }
}

/// Exposes the filtered users list based on filter parameter notifier
@riverpod
AsyncValue<List<UserModel>> filteredUsers(Ref ref) {
  final filter = ref.watch(usersFilterParameterProvider);
  final query = filter.query.trim().toLowerCase();
  final usersAsync = ref.watch(usersNotifierProviderProvider);

  if (query.isEmpty) return usersAsync;

  return usersAsync.whenData((list) {
    return list
        .where((u) => u.name.toLowerCase().contains(query))
        .toList(growable: false);
  });
}
