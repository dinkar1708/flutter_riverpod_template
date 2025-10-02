import 'package:flutter_riverpod_template/feature/users/models/users_filter_parameter_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'users_filter_parameter_notifier.g.dart';

@riverpod
class UsersFilterParameterNotifier extends _$UsersFilterParameterNotifier {
  @override
  UsersFilterParameterModel build() => const UsersFilterParameterModel();

  void setQuery(String value) => state = state.copyWith(query: value);
  void clear() => state = const UsersFilterParameterModel();
}


