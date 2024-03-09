import 'package:freezed_annotation/freezed_annotation.dart';

part 'repository_list_model.freezed.dart';
part 'repository_list_model.g.dart';

@freezed
class RepositoryListModel with _$RepositoryListModel {
  factory RepositoryListModel({
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'node_id') required String nodeId,
    @JsonKey(name: 'name') required String name,
    @JsonKey(name: 'full_name') required String fullName,
    @JsonKey(name: 'private') required bool isPrivate,
    @JsonKey(name: 'owner') required Owner owner,
    @JsonKey(name: 'html_url') required String htmlUrl,
    @JsonKey(name: 'description') required String? description,
    @JsonKey(name: 'fork') required bool isFork,
    @JsonKey(name: 'url') required String? url,
    // Add other fields as needed
  }) = _RepositoryListModel;

  factory RepositoryListModel.fromJson(Map<String, dynamic> json) =>
      _$RepositoryListModelFromJson(json);
}

@freezed
class Owner with _$Owner {
  factory Owner({
    @JsonKey(name: 'login') required String login,
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'node_id') required String nodeId,
    @JsonKey(name: 'avatar_url') required String avatarUrl,
    @JsonKey(name: 'html_url') required String htmlUrl,
    @JsonKey(name: 'followers_url') required String followersUrl,
    @JsonKey(name: 'following_url') required String followingUrl,
    @JsonKey(name: 'gists_url') required String gistsUrl,
    @JsonKey(name: 'starred_url') required String starredUrl,
    @JsonKey(name: 'subscriptions_url') required String subscriptionsUrl,
    @JsonKey(name: 'organizations_url') required String organizationsUrl,
    @JsonKey(name: 'repos_url') required String reposUrl,
    @JsonKey(name: 'events_url') required String eventsUrl,
    @JsonKey(name: 'received_events_url') required String receivedEventsUrl,
    @JsonKey(name: 'type') required String type,
    @JsonKey(name: 'site_admin') required bool isSiteAdmin,
  }) = _Owner;

  factory Owner.fromJson(Map<String, dynamic> json) => _$OwnerFromJson(json);
}
