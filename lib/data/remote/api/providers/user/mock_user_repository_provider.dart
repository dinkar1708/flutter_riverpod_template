import 'package:flutter_riverpod_template/data/remote/api/cient/mock_api_client.dart';
import 'package:flutter_riverpod_template/data/remote/api/providers/user/user_repository.dart';
import 'package:flutter_riverpod_template/feature/repository_list/models/repository_list_model.dart';

class MockUserRepository extends UserRepository {
  MockUserRepository() : super(apiClient: mockApiClient);

  @override
  Future<List<RepositoryListModel>> getRepositories(
      String userName, int pageSize) async {
    return hardCodedData;
  }
}

final hardCodedData = [
  RepositoryListModel(
    id: 1,
    nodeId: 'node1',
    name: 'Repo 1',
    fullName: 'Full Name 1',
    isPrivate: false,
    owner: Owner(
      login: 'owner1',
      id: 101,
      nodeId: 'ownerNode1',
      avatarUrl: 'owner_avatar_url1',
      htmlUrl: 'owner_html_url1',
      followersUrl: 'owner_followers_url1',
      followingUrl: 'owner_following_url1',
      gistsUrl: 'owner_gists_url1',
      starredUrl: 'owner_starred_url1',
      subscriptionsUrl: 'owner_subscriptions_url1',
      organizationsUrl: 'owner_organizations_url1',
      reposUrl: 'owner_repos_url1',
      eventsUrl: 'owner_events_url1',
      receivedEventsUrl: 'owner_received_events_url1',
      type: 'owner_type1',
      isSiteAdmin: false,
    ),
    htmlUrl: 'html_url1',
    description: 'Description 1',
    isFork: true,
    url: 'url1',
  ),
  RepositoryListModel(
    id: 2,
    nodeId: 'node2',
    name: 'Repo 2',
    fullName: 'Full Name 2',
    isPrivate: true,
    owner: Owner(
      login: 'owner2',
      id: 102,
      nodeId: 'ownerNode2',
      avatarUrl: 'owner_avatar_url2',
      htmlUrl: 'owner_html_url2',
      followersUrl: 'owner_followers_url2',
      followingUrl: 'owner_following_url2',
      gistsUrl: 'owner_gists_url2',
      starredUrl: 'owner_starred_url2',
      subscriptionsUrl: 'owner_subscriptions_url2',
      organizationsUrl: 'owner_organizations_url2',
      reposUrl: 'owner_repos_url2',
      eventsUrl: 'owner_events_url2',
      receivedEventsUrl: 'owner_received_events_url2',
      type: 'owner_type2',
      isSiteAdmin: true,
    ),
    htmlUrl: 'html_url2',
    description: 'Description 2',
    isFork: false,
    url: 'url2',
  ),
];
