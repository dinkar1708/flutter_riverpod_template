import 'package:flutter_riverpod_template/feature/users/models/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'users_notifier_provider.g.dart';

@riverpod
class UsersNotifierProvider extends _$UsersNotifierProvider {
  @override
  Future<List<UserModel>> build() async {
    // TODO read from api later
    return Future.value(
        [UserModel(id: 1, name: 'dinkar1708'), UserModel(id: 2, name: 'suji')]);
  }
}
