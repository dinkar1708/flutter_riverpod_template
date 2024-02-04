import 'package:flutter_riverpod_template/data/api/providers/api_client_provider.dart';
import 'package:flutter_riverpod_template/data/api/providers/user/user_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_repository_provider.g.dart';

@riverpod
UserRepository userRepository(UserRepositoryRef ref) => UserRepository(
      apiClient: ref.watch(apiClientProvider),
    );
