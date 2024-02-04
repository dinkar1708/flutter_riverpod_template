import 'package:dio/dio.dart';
import 'package:flutter_riverpod_template/data/remote/api/cient/api_constants.dart';
import 'package:flutter_riverpod_template/feature/repository_list/models/repository_list_model.dart';
import 'package:retrofit/retrofit.dart';

part 'api_client.g.dart';


@RestApi()
abstract class ApiClient {
  factory ApiClient(
    Dio dio, {
    String baseUrl,
  }) = _ApiClient;

  @GET("${ApiPath.users}/{username}/repos")
  Future<List<RepositoryListModel>> getRepositories(
    @Path("username") String username,
    @Query("per_page") int pageSize,
  );
}
