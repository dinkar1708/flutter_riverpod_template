# flutter_riverpod_template

A new Flutter project.

Using a Reactive Caching and Data-binding Framework Riverpod

## TODOs
-  fix comamnd line run -> flutter run --flavor development 
   - Target file "lib/main.dart" not found.
- run using android studio configurations
   - able to run using android studio
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

**Requirement: Fetch Data from Network**

**How to Use Riverpod in This Case:** User Future Provider

1. Define a future and perform a network call:

```dart
@riverpod
class RepositoryListNotifier extends _$RepositoryListNotifier {
  final userName = 'dinkar1708';
  final pageSize = 5;

  @override
  // see Future is used here for future provider
  Future<List<RepositoryListModel>> build() async => await ref
      .read(userRepositoryProvider)
      .getRepositories(userName, pageSize);
}
```

2. Utilize the notifier provider to access data and handle loading and error states:

```dart
final repositoryListAsync = ref.watch(repositoryListNotifierProvider);
repositoryListAsync.when(
  data: (data) => _buildListView(data),
  error: (error, stackTrace) {
    debugPrint(error.toString());
    debugPrint(stackTrace.toString());
    return Text('Error $error');
  },
  loading: () => const Center(child: Text('Loading...')),
);
```

![Screenshot_1709559854](https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/50aa9214-653f-4864-8c16-66388c0780f7)

## Feature Counter 

**Requirement: Maintain widget local state only without netowrk operation**

**How to Use Riverpod in This Case:** Use flutter hooks HookWidget widget

1. Extend HookWidget widget:

```dart
@RoutePage()
class CounterPage extends HookWidget {
```

2. Define state variable and use:

```dart
// define
    final counterState = useState(0);
// use
 Text(
              'Value ${counterState.value}',
              style: AppTextStyle.labelMedium
                  .copyWith(color: context.color.textPrimary),
            ),
// modify
 onPressed: () {
          counterState.value = counterState.value + 1;
        },
```
![Screenshot_1709559907](https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/27b2be2f-5577-42d6-94f2-50442450305b)

## Feature Navigation

- https://github.com/Milad-Akarie/auto_route_library?tab=readme-ov-file#tab-navigation
- ![Simulator Screenshot - iPhone 15 Pro - 2024-03-06 at 21 07 56](https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/6e3323c7-40da-4d77-bcc5-c372dd433083)

# Guide to inspect widget
**Start widget inspection**
<img width="525" alt="Screenshot 2024-05-04 at 12 17 35" src="https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/8e0d7e6d-2ff2-40ce-b969-165fe488a6a1">

**Select mode -> Click button 'Toggele select widget mode'**
<img width="239" alt="Screenshot 2024-05-04 at 11 13 49" src="https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/8d84eac2-fac1-4d33-a46e-bb0f75340ec1">

**Select widgets - Explore the widget tree to view details. Refer to the following information about the tree:"**
<img width="974" alt="Screenshot 2024-05-04 at 11 13 24" src="https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/f67a754b-9973-4246-9674-22b6dce165f3">

**End widget inspection**
<img width="525" alt="Screenshot 2024-05-04 at 12 17 21" src="https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/29707873-8ce6-4f0a-95cf-6f96c2aa7bdd">

# iOS Guide

# Flavors/ Run Configuration and Build Mode Guide

Reference flavors guide - [YouTube Video](https://www.youtube.com/watch?v=GwAnn1auo8o&t=198s)
### Only the "dev" and "prod" environments follow the same steps to create a staging environment if needed. Additionally, update the same code in the main folder. Here, too, in the app_config.dart, add a new variable named staging to the AppEnvironment

## A. iOS - Add Flavor (Schema) using Xcode

- **Add/Edit Schema:**
  ![Add/Edit Schema](https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/c8c1eeb4-107e-4d1a-a802-9215ad0756c6)

- **Change Schema Build Configuration etc.:**
  ![Change Schema Build Configuration](https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/57cb00e9-9f65-4dd4-8a16-635eebb9d548)

- **Manage Schema Page:**
  ![Manage Schema Page](https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/81fa6d71-e7c7-4ce1-84eb-a1988ae0b8ec)

- **Configuration:**
  In the image below, all build modes ([Debug, Profile, and Release](https://docs.flutter.dev/testing/build-modes)) have been shown for `dev` and `prod` flavors ([Flavors](https://docs.flutter.dev/deployment/flavors)).
  ![Configuration](https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/07db03af-5436-4b5f-84c4-d94c2bba6dbf)

- **Fix Main File Path:**
  Go to Runner -> Target -> Build Settings -> All, search for `flutter_target`, specify value for each main file.
  ![Fix Main File Path](https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/3f8cbad1-218b-4ac3-9ed2-48fd98ab7ce9)

- **Fix Display App Name:**
  Go to Runner -> Target -> Build Settings -> All, search for `product name`, specify value for each main file.
  ![Fix Display App Name](https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/4ddd59b5-a435-4378-b001-d4a789594d39)

- **Fix Bundle Identifier:**
  Go to Runner -> Signing & Capability -> Build Settings -> All.
  ![Fix Bundle Identifier](https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/9863da62-01e2-474f-81ab-70f7c2d0b903)
<br>

## B. Android - Add flavor (schema)

- Add in build.gradle (app)

  ![Add in build.gradle](https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/d7964b2a-a378-4d2e-8255-5d07d42c1f8b)

## C. Use flavor 

### Run Configuration Setting Using VS Code

Using "dev" and "prod" flavors as examples, with "Debug" and "Release" modes:

![Run configuration for dev and prod flavors](https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/a7d5bbba-c77d-4c9f-b6d1-ee74bdad93e6)

![Run configuration for dev and prod flavors](https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/4e0ca6c0-d373-4ed0-9ed1-14c5053412f8)
<br>
<br>

### Final after run app
- Test iOS device of all configurations dev and prod
<img width="427" alt="Screenshot 2024-03-06 at 22 47 48" src="https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/2591585f-224a-4f82-84ca-c372d3bcad51">
- Same Test for andrdoid device
<br>
<br>

# APIs
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
