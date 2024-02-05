# flutter_riverpod_template

A new Flutter project.

## Getting Started

This Flutter project utilizes the following packages:

- [Riverpod](https://riverpod.dev/docs/introduction/getting_started) - State management
- Retrofit - API call
- Dio - HTTP client
- Build Runner - Code generation
- Freezed - Code generation for models
- Freezed Annotations - Annotations for code generation

## Generating Code
To generate the necessary code, use the following commands:

One-time generation:
```bash
dart run build_runner build --delete-conflicting-outputs
```

Continuous watch:
```bash
dart run build_runner watch --delete-conflicting-outputs
```

## Why
To resolve compile errors, follow these steps:
1. Ensure that generator dependencies are added to `pubspec.yaml` (retrofit_generator, riverpod_generator).
2. Manually delete generated files (`.g` and `.freezed.dart`) before running the build runner commands.
3. Fix compile issues (except for generated syntax) before running build runner commands again.

## API
GitHub API:
- Base URL: `https://api.github.com/`

### Repositories by User Name
1. **User:**
   - URL: `https://api.github.com/users/octocat`
   - Replace `octocat` with the desired GitHub username.
1. **Users:**
   - User Details: `https://api.github.com/users/:username`
   - User Repositories: `https://api.github.com/users/:username/repos`
- Endpoint: `users/dinkar1708/repos?per_page=3`


# Features
## Home page
![Screenshot_1707041827](https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/3d2aab2a-5868-477d-b0cd-69ba7d7edc2c)

## Feature user github repositoy list
![Screenshot_1707038579](https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/7395e57d-bce3-4690-b5d7-2226ceaa5ce7)

# TODOs
- github apis implement via diffrent riverpod library usages

1. **Users:**
   - User Details: `https://api.github.com/users/:username`

2. **Repositories:**
   - Repository Details: `https://api.github.com/repos/:owner/:repo`
   - Repository Issues: `https://api.github.com/repos/:owner/:repo/issues`
   - Repository Commits: `https://api.github.com/repos/:owner/:repo/commits`

3. **Search:**
   - Search Repositories: `https://api.github.com/search/repositories?q=:query`
   - Search Users: `https://api.github.com/search/users?q=:query`

4. **Events:**
   - Public Events: `https://api.github.com/events`

5. **Gists:**
   - Gists by User: `https://api.github.com/users/:username/gists`

6. **Organizations:**
   - Organization Repositories: `https://api.github.com/orgs/:org/repos`

7. **Languages:**
   - List of Languages: `https://api.github.com/languages`

8. **Miscellaneous:**
   - Zen: `https://api.github.com/zen`
   - Rate Limit: `https://api.github.com/rate_limit`

## Example of Apis


2. **User Repositories:**
   - URL: `https://api.github.com/users/octocat/repos`
   - Replace `octocat` with the desired GitHub username.

3. **Repository Details:**
   - URL: `https://api.github.com/repos/octocat/hello-world`
   - Replace `octocat` with the owner's GitHub username and `hello-world` with the repository name.

4. **Repository Issues:**
   - URL: `https://api.github.com/repos/octocat/hello-world/issues`
   - Replace `octocat` with the owner's GitHub username and `hello-world` with the repository name.

5. **Repository Commits:**
   - URL: `https://api.github.com/repos/octocat/hello-world/commits`
   - Replace `octocat` with the owner's GitHub username and `hello-world` with the repository name.

6. **Search Repositories:**
   - URL: `https://api.github.com/search/repositories?q=topic:android`
   - This example searches for repositories related to the Android topic.

7. **Search Users:**
   - URL: `https://api.github.com/search/users?q=name:john`
   - This example searches for users with the name "john."

8. **Public Events:**
   - URL: `https://api.github.com/events`
   - Retrieves a list of public GitHub events.

9. **Gists by User:**
   - URL: `https://api.github.com/users/octocat/gists`
   - Replace `octocat` with the desired GitHub username.

10. **Organization Repositories:**
    - URL: `https://api.github.com/orgs/github/repos`
    - Replace `github` with the desired organization name.

11. **List of Languages:**
    - URL: `https://api.github.com/languages`
    - Retrieves a list of programming languages used in GitHub repositories.

12. **Zen:**
    - URL: `https://api.github.com/zen`
    - Retrieves a random Zen message.

13. **Rate Limit:**
    - URL: `https://api.github.com/rate_limit`
    - Retrieves the current rate limit status for your GitHub API token.
