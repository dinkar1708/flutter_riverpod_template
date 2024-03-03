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

## App navigation
- follow official documentation https://pub.dev/packages/auto_route

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

# DO/DON'T
1. Use hooks for storing widget local state
-  https://riverpod.dev/docs/essentials/do_dont
-  https://riverpod.dev/docs/concepts/about_hooks

# Features
## Home page
![Screenshot_1707316780](https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/c8023d87-4e5a-4e14-a543-c399e3782919)

## Feature user github repositoy list
![Screenshot_1707038579](https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/7395e57d-bce3-4690-b5d7-2226ceaa5ce7)

# TODOs
- github apis implement via diffrent riverpod library usages



# iOS Guide
1. iOS Build Configurations - https://developer.apple.com/documentation/xcode/adding-a-build-configuration-file-to-your-project
Debug
Release
Profile
<img width="733" alt="Screenshot 2024-02-08 at 0 11 20" src="https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/d19b7c4c-942f-4efc-a3e1-37d97c0ec22e">
<img width="261" alt="Screenshot 2024-02-08 at 0 11 26" src="https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/3d6e15c5-07c7-4e3d-bdf9-c5e5337215e2">

2. Xcode Run configuration - https://cocoacasts.com/tips-and-tricks-managing-build-configurations-in-xocde
Run Release, Debug, Profile configuration
ReleaseRunner - Test release build using xcode
Runner - Test debug build
ProfileRunner - Profile build test
<img width="376" alt="Screenshot 2024-02-08 at 0 11 00" src="https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/0f5df7c4-75da-4259-95fa-3b82e5c789db">

3. Test iOS device of all configurations Debug, Profile, Release on same device
Highlighted is the different name for apps
<img width="411" alt="image" src="https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/9ea058f4-0753-4006-afc4-1b03ba6db06f">

1. **Users:**
   - User Details: `https://api.github.com/users/:username`

2. **Repositories:**
   - Repository Details: `https://api.github.com/repos/:owner/:repo`
   - Repository Issues: `https://api.github.com/repos/:owner/:repo/issues`
   - Repository Commits: `https://api.github.com/repos/:owner/:repo/commits`

3. **Search:**
   - Search Repositories: `https://api.github.com/search/repositories?q=:query`
   - Search Users: `https://api.github.com/search/users?q=:query`(https://api.github.com/search/users?q=dinkar1708)

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
