# CI/CD and Automation in Flutter

> **Official Flutter Documentation:**
> - [Flutter Docs: Continuous Delivery & Deployment](https://docs.flutter.dev/deployment/cd)
> - [GitHub Actions Documentation](https://docs.github.com/en/actions)

---

## Overview

Continuous Integration and Continuous Delivery (CI/CD) automates static analysis, unit/widget tests, code generation, and app building.

This template uses GitHub Actions configured in:
📄 **[.github/workflows/build.yml](file:///.github/workflows/build.yml)**

---

## Core CI/CD Interview & Architecture Questions

### Q1: How do you manage multi-environment secrets (`.env.dev`, `.env.prod`) securely in CI/CD?
**Answer:**
* **Rule:** Never check `.env` files into source control.
* **Mechanism:** Add secrets to GitHub Repository Secrets (`DEV_API_KEY`, `PROD_API_KEY`, `MAPS_API_KEY`).
* **In Workflow:** Construct `.env` files dynamically in a dedicated CI step before `build_runner` or Gradle executes:
```yaml
- name: Create environment files
  run: |
    cat > .env.dev <<EOF
    API_BASE_URL=https://api.github.com/
    API_KEY=${{ secrets.DEV_API_KEY }}
    ENVIRONMENT=dev
    GOOGLE_MAPS_API_KEY=${{ secrets.DEV_MAPS_API_KEY }}
    EOF
```

---

### Q2: Why is `build_runner` required during CI builds?
**Answer:**
1. Code-generation packages (`envied_generator`, `retrofit_generator`, `riverpod_generator`, `freezed`, `auto_route_generator`) generate Dart code that is required for compilation and tests.
2. Generating code on CI ensures that obfuscated keys in `env.g.dart` reflect the CI environment secrets.
3. It prevents stale or missing generated code from failing the build.

```yaml
- name: Generate code
  run: dart run build_runner build --delete-conflicting-outputs
```

---

### Q3: How do you structure a robust Flutter CI pipeline?
**Answer:**
A standard enterprise pipeline follows these sequential stages:
1. **Lint / Analyze:** `dart analyze` or `flutter analyze --fatal-infos`
2. **Test:** `flutter test --coverage`
3. **Build:**
   - Android: `flutter build apk --flavor dev -t lib/main/main_dev.dart`
   - iOS: `flutter build ipa --export-options-plist=ios/ExportOptions.plist`
4. **Deploy / Distribute:** Upload to Firebase App Distribution, TestFlight, or Google Play Internal Track.

---

### Q4: How do you reduce Flutter CI/CD build times?
**Answer:**
1. **Cache Pub Dependencies:** Cache `~/.pub-cache` between runs using `actions/cache@v4`.
2. **Cache Gradle / CocoaPods:** Cache `~/.gradle/caches` and `ios/Pods`.
3. **Split Jobs (Parallelization):** Run Analysis and Unit Tests concurrently across parallel runner instances.
4. **Host OS Choice:** Use Linux (`ubuntu-latest`) for analysis, testing, and Android builds (faster startup and cheaper than macOS runners).

---

## Related Documentation
- Comprehensive Guide: [CI/CD Pipeline Guide](../../CI_CD_PIPELINE.md)
- Workflow File: [.github/workflows/build.yml](file:///.github/workflows/build.yml)
- [Environment Setup](../../ENVIRONMENT_SETUP.md)
