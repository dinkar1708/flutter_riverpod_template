import 'package:flutter_riverpod_template/data/remote/api/cient/api_client.dart';
import 'package:flutter_riverpod_template/feature/repository_list/models/repository_list_model.dart';

class UserRepository {
  UserRepository({required this.apiClient});
  final ApiClient apiClient;

  Future<List<RepositoryListModel>> getRepositories(String userName, int pageSize) =>
      apiClient.getRepositories(userName, pageSize);
}
