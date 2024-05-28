# flutter_riverpod_template

A new Flutter template project using the Riverpod library for state management.

## Table of Contents
1. [Setup](#setup)
2. [Guide to Run Code](#guide-to-run-code)
3. [API Used](#api-used-in-the-project)
4. [Features](#features)
5. [Run Configuration Guide](#run-configuration-guide)
6. [Coding Guide](#coding-guide)
7. [Release Guide](#release-guide)
8. [APIs](#apis)
9. [Riverpod Library Guide](#riverpod-library-guide)
10. [FAQ](#faq)
11. [DO/DON'T](#dodont)
12. [TODOs](#todos)


## Setup

### Prerequisites
- Flutter SDK installed - Current tested flutter SDK 3.19.6
- Android Studio / VS Code installed
- Emulator / Simulator / Physical device for testing

### Installation
- Clone project
- Run `flutter pub get`
- Generating Code - To generate the necessary code, use the following commands:

***One-time generation:***
```bash
dart run build_runner build --delete-conflicting-outputs
```

***Continuous watch:***
```bash
dart run build_runner watch --delete-conflicting-outputs
```

## Guide to Run Code

### Run configuration configuration using .launch.json file
### Mock data
- Guide: [Mocking Providers](https://riverpod.dev/docs/essentials/testing#mocking-providers)
- Use mock run configuration to use mock/hard-coded data TODO
- Use actual configuration run actual API data

## Final after running the app
- Test iOS device of all configurations dev and prod
- <img width="400" alt="iOS Test" src="https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/2591585f-224a-4f82-84ca-c372d3bcad51">

- Same as iOS Test for Android device

## API Used in the project

### GitHub API:
- Base URL: `https://api.github.com/`

#### Repositories by User Name
1. **Users:**
   - User Repositories: `https://api.github.com/users/:username/repos`
- Endpoint: `users/dinkar1708/repos?per_page=3`

## Features

### Home Page
- Navigation to feature pages
- <img width="400" alt="Home Page" src="https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/c1cd0232-ce33-43f9-809a-2b30dc6a5c2a">


### Feature: Navigation
- [Auto Route](https://github.com/Milad-Akarie/auto_route_library?tab=readme-ov-file#tab-navigation)
- <img width="400" alt="Navigation Feature" src="https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/42f49745-0871-45f0-a38b-5cdc86669ba6">

### Feature: Counter without API

**API-TYPE: No API**

**Requirement: Maintain widget local state only without network operation**

**How to Use Riverpod in This Case:** Use flutter hooks HookWidget widget

1. Define parent class:

```dart
// see parent class

@RoutePage()
class CounterPage extends HookWidget {
```

2. Use notifier provider on UI

```dart
// define
    final counterState = useState(0);
// use variable
 Text(
              'Value ${counterState.value}',
              style: AppTextStyle.labelMedium
                  .copyWith(color: context.color.textPrimary),
            ),
// modify variable
 onPressed: () {
          counterState.value = counterState.value + 1;
        },
```
- <img width="400" alt="Counter Feature" src="https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/7393ac62-fda3-4dfb-9f6c-4694f75c8b98">


### Feature: User GitHub Repository List

**API-TYPE: GET**

**Requirement: Fetch Data from Network**

**How to Use Riverpod in This Case:** User Future Provider - https://riverpod.dev/docs/providers/future_provider

1. Define a future and perform a network call:

```dart
@riverpod
class RepositoryListNotifier extends _$RepositoryListNotifier {
// below is the future provider
  @override
  Future<List<RepositoryListModel>> build() async => await ref
      .read(userRepositoryProvider)
      .getRepositories(userName, pageSize);
}
```

2. Define parent class:

```dart
// see parent class 
class RepositoryListPage extends ConsumerStatefulWidget {
````

3. Use notifier provider on UI

```dart
final repositoryListAsync = ref.watch(repositoryListNotifierProvider);
return switch (repositoryListAsync) {
  AsyncError(:final error) =>
    SliverToBoxAdapter(child: Text('Error $error')),
  AsyncData(:final value) => _buildListView(value),
  _ => const SliverToBoxAdapter(child: Center(child: Text('Loading...'))),
};
```
- <img width="400" alt="Repository List" src="https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/501741e0-1509-4533-bbf6-16be30fdc1a3">


### Feature: Search Users and Handle widget local state

**API-TYPE: GET**

**Requirement: Fetch Data from Network and handle widget local state(clear button in search box)**

**How to Use Riverpod in This Case:** User Future Provider with hooks - https://riverpod.dev/docs/essentials/side_effects#going-further-showing-a-spinner--error-handling

1. Define a future and perform a network call:

```dart
// TODO later
```

2. Define parent class:

```dart
// see parent class is StatefulHookConsumerWidget which is special using via 'hooks_riverpod' library
// task 1 can use useState     final isSearchingNotifier = useState(false);

// task 2 can do read and watch -     final usersListAsync = ref.watch(usersNotifierProviderProvider);

class UsersPage extends StatefulHookConsumerWidget {
````

3. Use notifier provider on UI

// use widget local state variable
```dart
final isSearchingNotifier = useState(false);
// Change the value
        onChanged: (value) {
          isSearchingNotifier.value = true;
        },
```

```dart
// load user list data
    final usersListAsync = ref.watch(usersNotifierProviderProvider);
    return switch (usersListAsync) {
      AsyncError(:final error) => SliverToBoxAdapter(
          child: SliverToBoxAdapter(child: Text('Error $error'))),
      AsyncData(:final value) => _buildListView(value),
      _ => const SliverToBoxAdapter(child: Center(child: Text('Loading...'))),
    };
```
- <img width="400" alt="Search Users" src="https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/545b38ce-4e9f-4085-9f2b-9e338cfbcb35">


### Feature: Login

**API-TYPE: POST**

**Requirement: Send data to network**

**How to Use Riverpod in This Case:**

To use the Flutter Future Notifier Provider, we can follow the guidelines provided in the Riverpod documentation. For a more comprehensive guide on handling side effects, such as showing a spinner and error handling, refer to [this section](https://riverpod.dev/docs/essentials/side_effects#going-further-showing-a-spinner--error-handling) of the Riverpod documentation. 
However, for simplicity and to maintain clean code, you can handle error messages and loading states using the [FutureProvider](https://riverpod.dev/docs/providers/future_provider) in Riverpod.

1. Define a future and perform a network call:

```dart
@riverpod
class LoginNotifier extends _$LoginNotifier {
  @override
  Future<LoginStateModel> build() async {
    debugPrint('login initial state....');
    return Future.value(const LoginStateModel());
  }
```

2. Define parent class:

```dart
// see parent class 
class LoginPage extends ConsumerStatefulWidget {

````

3. Use notifier provider on UI
// use to handle progress indicator
```dart
    // watch all the times
    final loginState = ref.watch(loginNotifierProvider);
    // use on UI with condition
          child: loginState.value?.apiResultState == APIResultState.loading
          ? const CircularProgressIndicator()
          : const Text('Login'),
```

// use to show error message
```dart
      // use error message on UI
        const SizedBox(
          height: 100,
        ),
        if (loginState.value?.errorMessage != null)
          Text(loginState.value!.errorMessage),
```

// use to do network request
```dart
// call api and handle error such as snack bar or alert etc.
         loginNotifier.login(loginRequestModel).then((loginStateModel) => {
              if (loginStateModel.apiResultState == APIResultState.result &&
                  loginStateModel.loginResponseModel != null)
                {
                  showSnackBar(context,
                      'Login success ${loginStateModel.loginResponseModel!.userName}'),
                  context.router.replaceAll([HomeRoute(title: 'Home')]),
                }
              else
                {
                  // show error message as snack bar or dailog anything
                  showSnackBar(
                      context, 'Login failed ${loginStateModel.errorMessage}'),
                }
            });

```

**Loading State after the button is clicked**
- <img width="400" alt="Loading State" src="https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/b1f458c6-b040-469e-8f8f-2a13d330f06c">

**Loaded State after the API call is done**
- <img width="400" alt="Loaded State" src="https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/046e5e38-78b4-4968-b6f2-0b2398c3b746">


### Feature TODO: Complex Widget local state

**API-TYPE: No api**

**Requirement: Manage complext widget local state**

**How to Use Riverpod in This Case:** State notifier provider https://riverpod.dev/docs/providers/state_notifier_provider
1. Define state model class
StateModel {

}

2. Define a state notifier and define initial state:

```dart
@riverpod
class ABCNotifier extends _$ABCNotifier {
  @override
  // note here not using future
  StateModel build() async {
    return StateModel();
  }
```

3. Use notifier provider on UI

```dart
//
```

### Feature TODO: Combination of POST, GET, or Widget Local State

Define the parent `StatefulHookConsumerWidget`, which allows you to use `useState` and `ref` to access the provider in the desired manner.

**Examples:**

- **POST + Local State:** Follow the login example, but define the parent `StatefulHookConsumerWidget` to use `useState`.
  
- **POST + GET:** Follow the login example and the repository list example.
  
- **POST + GET + Widget Local State:** Follow the login example, the repository list example, and define the parent as `StatefulHookConsumerWidget` to use `useState`.

# Run Configuration Guide

## Guide link
This section provides guidance on setting up flavors, run configurations, and build modes for iOS.
- [Build Modes](https://docs.flutter.dev/testing/build-modes)
- [Flavors](https://docs.flutter.dev/deployment/flavors)

## Flavors/ Run Configuration and Build Mode Guide
Reference flavors guide - [YouTube Video](https://www.youtube.com/watch?v=GwAnn1auo8o&t=198s)
***Only the "dev" and "prod" environments follow the same steps to create a staging environment if needed. Additionally, update the same code in the main folder. Here, too, in the app_config.dart, add a new variable named staging to the AppEnvironment***

## A. iOS - Add Flavor (Schema) using Xcode

- **Add/Edit Schema:

**
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

## B. Android - Add Flavor (Schema)

- Add in build.gradle (app)
  ![Add in build.gradle](https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/d7964b2a-a378-4d2e-8255-5d07d42c1f8b)

## C. Use Flavor 

### Run Configuration Setting Using VS Code

Using "dev" and "prod" flavors as examples, with "Debug" and "Release" modes:

![Run configuration for dev and prod flavors](https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/a7d5bbba-c77d-4c9f-b6d1-ee74bdad93e6)

![Run configuration for dev and prod flavors](https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/4e0ca6c0-d373-4ed0-9ed1-14c5053412f8)

# Coding Guide
## Riverpod Guide

For detailed information on how Riverpod is used in this project, please refer to the [Features](#features) section, where each feature is accompanied by a guide based on Riverpod's functionality and requirements.

## App navigation
- follow official documentation [Auto Route](https://pub.dev/packages/auto_route)
- must run Generating Code to generate route

## Package used
**This Flutter project utilizes the following packages:**
- [Riverpod](https://riverpod.dev/docs/introduction/getting_started) - State management
- Retrofit - API call
- Dio - HTTP client
- Build Runner - Code generation
- Freezed - Code generation for models
- Freezed Annotations - Annotations for code generation

## Guide to inspect widget
**Start widget inspection. See below picture**

![Start widget inspection](https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/8e0d7e6d-2ff2-40ce-b969-165fe488a6a1)

**Select mode -> Click button 'Toggle select widget mode'. See below picture**

![Toggle select widget mode](https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/8d84eac2-fac1-4d33-a46e-bb0f75340ec1)

**Select widgets - Explore the widget tree to view details. Refer to the following information about the tree:. See below picture**

![Select widgets](https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/f67a754b-9973-4246-9674-22b6dce165f3)

**End widget inspection. See below picture**

![End widget inspection](https://github.com/dinkar1708/flutter_riverpod_template/assets/14831652/29707873-8ce6-4f0a-95cf-6f96c2aa7bdd)

# Release Guide
**Guide CI/CD For detailed guidance**
refer to: [GitHub Actions Quickstart](https://docs.github.com/en/actions/quickstart)

**Github Actions (CI/CD)**

### First-time User? Follow these steps:

1. Visit [flutter-actions/setup-flutter](https://github.com/flutter-actions/setup-flutter) and copy the provided basic version. Paste it into any file, give it a name, commit, push, and create a pull request. This action will automatically begin running.

2. If you have an extra step, add it to the .yml file:

   ```yaml
   - name: Generate code
     run: dart run build_runner build --delete-conflicting-outputs
   ```

3. Now, check if the automatic CI running has passed.

### How to Use This Repository's .yml File:
- Simply copy and paste the `build.yml` file into your repository under `.github/workflows/build.yml`, ensuring to specify the correct version of the Flutter SDK, and it will automatically start building.

# Riverpod Library Guide
- Main library
```
  flutter_riverpod: ^2.2.0
  riverpod_annotation: ^2.3.3
```

- Use flutter hooks to manage state of variables
```
flutter_hooks
```

- StatefulHookConsumerWidget which offers HookWidget and ConsumerStatefulWidget both features.
```
hooks_riverpod
```

# APIs
For example API usage, refer to the list below:
For example API usage, refer to the [API List](documentation/API_LIST.md).

# FAQ
- Can use the `hooks_riverpod` package, StatefulHookConsumerWidget which offers HookWidget and ConsumerStatefulWidget both features.
- All pages must be suffixed by 'Page' to generate auto router automatically
Example 
Correct - HomePage  // at the end must add Page
Wrong - HomeView, HomeWidget, HomeStatefullWidget

- To resolve compile errors, follow these steps:
1. Ensure that generator dependencies are added to `pubspec.yaml` (retrofit_generator, riverpod_generator).
2. Manually delete generated files (`.g` and `.freezed.dart`) before running the build runner commands.
3. Fix compile issues (except for generated syntax) before running build runner commands again.

# DO/DON'T
1. Use hooks for storing widget local state
-  [Essential Do/Don't](https://riverpod.dev/docs/essentials/do_dont)
-  [About Hooks](https://riverpod.dev/docs/concepts/about_hooks)

# TODOs
- Fix command line run -> `flutter run --flavor development` 
   - Target file "lib/main.dart" not found.
- Run using Android Studio configurations
   - Able to run using Android Studio
- Implement GitHub APIs using different Riverpod library usages