# Maestro E2E Tests

End-to-end tests for the Flutter Riverpod Template app using [Maestro](https://maestro.mobile.dev/).

## Prerequisites

1. **Maestro CLI** — install:
   ```bash
   curl -Ls "https://get.maestro.mobile.dev" | bash
   ```

2. **Built app on a device/emulator**
   - Android (dev flavor):
     ```bash
     flutter build apk --flavor dev -t lib/main.dart
     flutter install --flavor dev -t lib/main.dart
     ```
   - iOS (dev flavor, macOS):
     ```bash
     flutter build ios --flavor dev -t lib/main.dart --simulator
     flutter run --flavor dev -t lib/main.dart
     ```

3. Start an emulator/simulator with the dev app installed.

## Run Tests

From the project root:

```bash
# Launch app smoke test
maestro test maestro/launch_app.yaml

# Home bottom tab navigation
maestro test maestro/home_bottom_tabs.yaml

# Run all flows
maestro test maestro/
```

### iOS

Update `appId` in each flow to `dev.dinakar.flutter.rivperpod.template`, or run with:

```bash
maestro test --app-id dev.dinakar.flutter.rivperpod.template maestro/
```

## Flows

| Flow | Description |
|------|-------------|
| `launch_app.yaml` | Launches app, waits for splash, asserts login screen |
| `home_bottom_tabs.yaml` | Guest login, taps Home / Explore / Profile tabs |
| `subflows/login_as_guest.yaml` | Reusable guest login helper |

## App IDs

| Platform | Dev flavor |
|----------|------------|
| Android | `com.example.flutter_rivperpod_template.dev` |
| iOS | `dev.dinakar.flutter.rivperpod.template` |

Flows default to the Android dev `appId`. Use `--app-id` to override for iOS.
