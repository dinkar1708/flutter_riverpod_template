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
- Endpoint: `users/dinkar1708/repos?per_page=3`

### Repositories by Repository Name
- Endpoint: `https://api.github.com/search/repositories?q=name:example`