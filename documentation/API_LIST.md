
**API Example Listing**
- APIs are listed with example values. Feel free to modify the values as needed.
<hr>

**User List API**
- **Doc:** https://docs.github.com/en/rest/search/search?apiVersion=2022-11-28#search-users
- **URL:** `https://api.github.com/search/users?q="dinkar1708"`( with pagination // https://api.github.com/search/users?q=dinkar1708&page=1&per_page=1
  )
- **Header:**
    - `"X-GitHub-Api-Version": "2022-11-28"`
- **Type:** GET
- **Response:**
  {
  "total_count": 2,
  "incomplete_results": false,
  "items": [
  {
  "login": "dinkar1708",
  "id": 14831652,
  "node_id": "MDQ6VXNlcjE0ODMxNjUy",
  "avatar_url": "https://avatars.githubusercontent.com/u/14831652?v=4",
  "gravatar_id": "",
  "url": "https://api.github.com/users/dinkar1708",
  "html_url": "https://github.com/dinkar1708",
  "followers_url": "https://api.github.com/users/dinkar1708/followers",
  "following_url": "https://api.github.com/users/dinkar1708/following{/other_user}",
  "gists_url": "https://api.github.com/users/dinkar1708/gists{/gist_id}",
  "starred_url": "https://api.github.com/users/dinkar1708/starred{/owner}{/repo}",
  "subscriptions_url": "https://api.github.com/users/dinkar1708/subscriptions",
  "organizations_url": "https://api.github.com/users/dinkar1708/orgs",
  "repos_url": "https://api.github.com/users/dinkar1708/repos",
  "events_url": "https://api.github.com/users/dinkar1708/events{/privacy}",
  "received_events_url": "https://api.github.com/users/dinkar1708/received_events",
  "type": "User",
  "site_admin": false,
  "score": 1.0
  },
  {
  "login": "dinkar1708-zz",
  "id": 28217318,
  "node_id": "MDQ6VXNlcjI4MjE3MzE4",
  "avatar_url": "https://avatars.githubusercontent.com/u/28217318?v=4",
  "gravatar_id": "",
  "url": "https://api.github.com/users/dinkar1708-zz",
  "html_url": "https://github.com/dinkar1708-zz",
  "followers_url": "https://api.github.com/users/dinkar1708-zz/followers",
  "following_url": "https://api.github.com/users/dinkar1708-zz/following{/other_user}",
  "gists_url": "https://api.github.com/users/dinkar1708-zz/gists{/gist_id}",
  "starred_url": "https://api.github.com/users/dinkar1708-zz/starred{/owner}{/repo}",
  "subscriptions_url": "https://api.github.com/users/dinkar1708-zz/subscriptions",
  "organizations_url": "https://api.github.com/users/dinkar1708-zz/orgs",
  "repos_url": "https://api.github.com/users/dinkar1708-zz/repos",
  "events_url": "https://api.github.com/users/dinkar1708-zz/events{/privacy}",
  "received_events_url": "https://api.github.com/users/dinkar1708-zz/received_events",
  "type": "User",
  "site_admin": false,
  "score": 1.0
  }
  ]
  }
<hr>

**User profile**
- **Doc:** https://docs.github.com/en/rest/users/users?apiVersion=2022-11-28#get-a-user
- **URL:** `https://api.github.com/users/dinkar1708`
- **Header:**
    - `"X-GitHub-Api-Version": "2022-11-28"`
- **Type:** GET
- **Response:**
  {
  "login": "dinkar1708",
  "id": 14831652,
  "node_id": "MDQ6VXNlcjE0ODMxNjUy",
  "avatar_url": "https://avatars.githubusercontent.com/u/14831652?v=4",
  "gravatar_id": "",
  "url": "https://api.github.com/users/dinkar1708",
  "html_url": "https://github.com/dinkar1708",
  "followers_url": "https://api.github.com/users/dinkar1708/followers",
  "following_url": "https://api.github.com/users/dinkar1708/following{/other_user}",
  "gists_url": "https://api.github.com/users/dinkar1708/gists{/gist_id}",
  "starred_url": "https://api.github.com/users/dinkar1708/starred{/owner}{/repo}",
  "subscriptions_url": "https://api.github.com/users/dinkar1708/subscriptions",
  "organizations_url": "https://api.github.com/users/dinkar1708/orgs",
  "repos_url": "https://api.github.com/users/dinkar1708/repos",
  "events_url": "https://api.github.com/users/dinkar1708/events{/privacy}",
  "received_events_url": "https://api.github.com/users/dinkar1708/received_events",
  "type": "User",
  "site_admin": false,
  "name": "Dinakar Maurya",
  "company": "Monstar Lab",
  "blog": "",
  "location": "Tokyo",
  "email": null,
  "hireable": true,
  "bio": "JLPT N2, Software Engineer Technical Lead @Monstarlab | Mobile App Development, Solution architecture, BugFixPro, RapidAdd, Android, iOS, Flutter, Swift, Kotlin",
  "twitter_username": null,
  "public_repos": 28,
  "public_gists": 0,
  "followers": 6,
  "following": 0,
  "created_at": "2015-09-25T03:59:27Z",
  "updated_at": "2024-05-10T04:30:35Z"
  }
<hr>

**User repositories**
- **Doc:** - https://docs.github.com/en/rest/repos/repos?apiVersion=2022-11-28#list-repositories-for-a-user
- **URL:** `https://api.github.com/users/dinkar1708/repos?q=page=1&per_page=2`
- **Header:**
    - `"X-GitHub-Api-Version": "2022-11-28"`
- **Type:** GET
- **Response:**
  [
  {
  "id": 177565650,
  "node_id": "MDEwOlJlcG9zaXRvcnkxNzc1NjU2NTA=",
  "name": "AndroidMVP",
  "full_name": "dinkar1708/AndroidMVP",
  "private": false,
  "owner": {
  "login": "dinkar1708",
  "id": 14831652,
  "node_id": "MDQ6VXNlcjE0ODMxNjUy",
  "avatar_url": "https://avatars.githubusercontent.com/u/14831652?v=4",
  "gravatar_id": "",
  "url": "https://api.github.com/users/dinkar1708",
  "html_url": "https://github.com/dinkar1708",
  "followers_url": "https://api.github.com/users/dinkar1708/followers",
  "following_url": "https://api.github.com/users/dinkar1708/following{/other_user}",
  "gists_url": "https://api.github.com/users/dinkar1708/gists{/gist_id}",
  "starred_url": "https://api.github.com/users/dinkar1708/starred{/owner}{/repo}",
  "subscriptions_url": "https://api.github.com/users/dinkar1708/subscriptions",
  "organizations_url": "https://api.github.com/users/dinkar1708/orgs",
  "repos_url": "https://api.github.com/users/dinkar1708/repos",
  "events_url": "https://api.github.com/users/dinkar1708/events{/privacy}",
  "received_events_url": "https://api.github.com/users/dinkar1708/received_events",
  "type": "User",
  "site_admin": false
  },
  "html_url": "https://github.com/dinkar1708/AndroidMVP",
  "description": "Android model view presenter demonstration.",
  "fork": true,
  "url": "https://api.github.com/repos/dinkar1708/AndroidMVP",
  "forks_url": "https://api.github.com/repos/dinkar1708/AndroidMVP/forks",
  "keys_url": "https://api.github.com/repos/dinkar1708/AndroidMVP/keys{/key_id}",
  "collaborators_url": "https://api.github.com/repos/dinkar1708/AndroidMVP/collaborators{/collaborator}",
  "teams_url": "https://api.github.com/repos/dinkar1708/AndroidMVP/teams",
  "hooks_url": "https://api.github.com/repos/dinkar1708/AndroidMVP/hooks",
  "issue_events_url": "https://api.github.com/repos/dinkar1708/AndroidMVP/issues/events{/number}",
  "events_url": "https://api.github.com/repos/dinkar1708/AndroidMVP/events",
  "assignees_url": "https://api.github.com/repos/dinkar1708/AndroidMVP/assignees{/user}",
  "branches_url": "https://api.github.com/repos/dinkar1708/AndroidMVP/branches{/branch}",
  "tags_url": "https://api.github.com/repos/dinkar1708/AndroidMVP/tags",
  "blobs_url": "https://api.github.com/repos/dinkar1708/AndroidMVP/git/blobs{/sha}",
  "git_tags_url": "https://api.github.com/repos/dinkar1708/AndroidMVP/git/tags{/sha}",
  "git_refs_url": "https://api.github.com/repos/dinkar1708/AndroidMVP/git/refs{/sha}",
  "trees_url": "https://api.github.com/repos/dinkar1708/AndroidMVP/git/trees{/sha}",
  "statuses_url": "https://api.github.com/repos/dinkar1708/AndroidMVP/statuses/{sha}",
  "languages_url": "https://api.github.com/repos/dinkar1708/AndroidMVP/languages",
  "stargazers_url": "https://api.github.com/repos/dinkar1708/AndroidMVP/stargazers",
  "contributors_url": "https://api.github.com/repos/dinkar1708/AndroidMVP/contributors",
  "subscribers_url": "https://api.github.com/repos/dinkar1708/AndroidMVP/subscribers",
  "subscription_url": "https://api.github.com/repos/dinkar1708/AndroidMVP/subscription",
  "commits_url": "https://api.github.com/repos/dinkar1708/AndroidMVP/commits{/sha}",
  "git_commits_url": "https://api.github.com/repos/dinkar1708/AndroidMVP/git/commits{/sha}",
  "comments_url": "https://api.github.com/repos/dinkar1708/AndroidMVP/comments{/number}",
  "issue_comment_url": "https://api.github.com/repos/dinkar1708/AndroidMVP/issues/comments{/number}",
  "contents_url": "https://api.github.com/repos/dinkar1708/AndroidMVP/contents/{+path}",
  "compare_url": "https://api.github.com/repos/dinkar1708/AndroidMVP/compare/{base}...{head}",
  "merges_url": "https://api.github.com/repos/dinkar1708/AndroidMVP/merges",
  "archive_url": "https://api.github.com/repos/dinkar1708/AndroidMVP/{archive_format}{/ref}",
  "downloads_url": "https://api.github.com/repos/dinkar1708/AndroidMVP/downloads",
  "issues_url": "https://api.github.com/repos/dinkar1708/AndroidMVP/issues{/number}",
  "pulls_url": "https://api.github.com/repos/dinkar1708/AndroidMVP/pulls{/number}",
  "milestones_url": "https://api.github.com/repos/dinkar1708/AndroidMVP/milestones{/number}",
  "notifications_url": "https://api.github.com/repos/dinkar1708/AndroidMVP/notifications{?since,all,participating}",
  "labels_url": "https://api.github.com/repos/dinkar1708/AndroidMVP/labels{/name}",
  "releases_url": "https://api.github.com/repos/dinkar1708/AndroidMVP/releases{/id}",
  "deployments_url": "https://api.github.com/repos/dinkar1708/AndroidMVP/deployments",
  "created_at": "2019-03-25T10:37:46Z",
  "updated_at": "2019-03-25T10:37:48Z",
  "pushed_at": "2018-01-28T11:00:38Z",
  "git_url": "git://github.com/dinkar1708/AndroidMVP.git",
  "ssh_url": "git@github.com:dinkar1708/AndroidMVP.git",
  "clone_url": "https://github.com/dinkar1708/AndroidMVP.git",
  "svn_url": "https://github.com/dinkar1708/AndroidMVP",
  "homepage": "",
  "size": 128,
  "stargazers_count": 0,
  "watchers_count": 0,
  "language": "Java",
  "has_issues": false,
  "has_projects": true,
  "has_downloads": true,
  "has_wiki": true,
  "has_pages": false,
  "has_discussions": false,
  "forks_count": 0,
  "mirror_url": null,
  "archived": false,
  "disabled": false,
  "open_issues_count": 0,
  "license": null,
  "allow_forking": true,
  "is_template": false,
  "web_commit_signoff_required": false,
  "topics": [

  ],
  "visibility": "public",
  "forks": 0,
  "open_issues": 0,
  "watchers": 0,
  "default_branch": "master"
  }
  ]
<hr>

# APIs
For example API usage, refer to the list below:

1. **User Repositories:**
   - URL: `https://api.github.com/users/octocat/repos`

2. **Repository Details:**
   - URL: `https://api.github.com/repos/octocat/hello-world`

3. **Repository Issues:**
   - URL: `https://api.github.com/repos/octocat/hello-world/issues`

4. **Repository Commits:**
   - URL: `https://api.github.com/repos/octocat/hello-world/commits`

5. **Search Repositories:**
   - URL: `https://api.github.com/search/repositories?q=topic:android`

6. **Search Users:**
   - URL: `https://api.github.com/search/users?q=name:john`

7. **Public Events:**
   - URL: `https://api.github.com/events`

8. **Gists by User:**
   - URL: `https://api.github.com/users/octocat

/gists`

9. **Organization Repositories:**
    - URL: `https://api.github.com/orgs/github/repos`

10. **List of Languages:**
    - URL: `https://api.github.com/languages`

11. **Miscellaneous:**
    - Zen: `https://api.github.com/zen`
    - Rate Limit: `https://api.github.com/rate_limit`

## Example APIs

- **User Repositories:**
   - URL: `https://api.github.com/users/octocat/repos`
   - Replace `octocat` with the desired GitHub username.

- **Repository Details:**
   - URL: `https://api.github.com/repos/octocat/hello-world`
   - Replace `octocat` with the owner's GitHub username and `hello-world` with the repository name.

- **Repository Issues:**
   - URL: `https://api.github.com/repos/octocat/hello-world/issues`
   - Replace `octocat` with the owner's GitHub username and `hello-world` with the repository name.

- **Repository Commits:**
   - URL: `https://api.github.com/repos/octocat/hello-world/commits`
   - Replace `octocat` with the owner's GitHub username and `hello-world` with the repository name.

- **Search Repositories:**
   - URL: `https://api.github.com/search/repositories?q=topic:android`
   - This example searches for repositories related to the Android topic.

- **Search Users:**
   - URL: `https://api.github.com/search/users?q=name:john`
   - This example searches for users with the name "john."

- **Public Events:**
   - URL: `https://api.github.com/events`
   - Retrieves a list of public GitHub events.

- **Gists by User:**
   - URL: `https://api.github.com/users/octocat/gists`
   - Replace `octocat` with the desired GitHub username.

- **Organization Repositories:**
    - URL: `https://api.github.com/orgs/github/repos`
    - Replace `github` with the desired organization name.

- **List of Languages:**
    - URL: `https://api.github.com/languages`
    - Retrieves a list of programming languages used in GitHub repositories.

- **Zen:**
    - URL: `https://api.github.com/zen`
    - Retrieves a random Zen message.

- **Rate Limit:**
    - URL: `https://api.github.com/rate_limit`
    - Retrieves the current rate limit status for your GitHub API token.
