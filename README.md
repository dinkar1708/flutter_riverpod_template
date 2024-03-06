# flutter_riverpod_template

A new Flutter project.

## TODOs
-  fix comamnd line run -> flutter run --flavor development 
- ios run configurations
- github apis implement via diffrent riverpod library usages


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
- must run Generating Code to generate route

## NOTE POINTS
- All pages must be suffixed by 'Page' to generate auto router automatically
Exmple 
Correct - HomePage  // at the end must add Page
Wrong - HomeView, HomeWidget, HomeStatefullWidget

- To resolve compile errors, follow these steps:
1. Ensure that generator dependencies are added to `pubspec.yaml` (retrofit_generator, riverpod_generator).
2. Manually delete generated files (`.g` and `.freezed.dart`) before running the build runner commands.
3. Fix compile issues (except for generated syntax) before running build runner commands again.

# Guide to run code
## Run configuration configuration using .launch.json file
## Mock data
- Guide https://riverpod.dev/docs/essentials/testing#mocking-providers
- Use mock run configuration to use mock/hard coded data TODO
- Use actual configuration run actual api data

## Run configuration guide
- https://docs.flutter.dev/testing/build-modes
- https://docs.flutter.dev/deployment/flavors
- run config <img width="319" alt="image" src="https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/82f11dca-ad35-40ff-af14-52eca34ad64a">

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
- navigation to features page
![Screenshot_1709559818](https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/82ac45d6-c00f-46a7-8f39-17bced9bf84e)

## Feature user github repositoy list
![Screenshot_1709559854](https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/50aa9214-653f-4864-8c16-66388c0780f7)

## Feature Counter 
![Screenshot_1709559907](https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/27b2be2f-5577-42d6-94f2-50442450305b)

## Feature Navigation

- https://github.com/Milad-Akarie/auto_route_library?tab=readme-ov-file#tab-navigation
- ![Simulator Screenshot - iPhone 15 Pro - 2024-03-06 at 21 07 56](https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/6e3323c7-40da-4d77-bcc5-c372dd433083)
# iOS Guide
# Run using xcode
## Fix main file path
Go to 
Runner -> Target -> All
search target specify value for each main files
<img width="1051" alt="image" src="https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/ff86e605-185c-4e24-9210-be1eff18a4fc">
<img width="1240" alt="Screenshot 2024-03-05 at 17 51 43" src="https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/2dd37a1b-ecd0-460a-ac1c-7167317b1abd">

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
3. Create mock schema
- Add mock run configuration
- <img width="1070" alt="Screenshot 2024-03-05 at 18 13 23" src="https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/4a7c3a7d-620f-4b5a-83fe-88901b5aca95">
- Add run target 
<img width="1096" alt="Screenshot 2024-03-05 at 18 12 54" src="https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/639b3dd9-25b7-4880-9546-6c6a57a30724">
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
