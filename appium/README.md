# Appium E2E Tests

End-to-end tests for the Flutter Riverpod Template app using [Appium](https://appium.io/) and Python.

## Prerequisites

1. **Appium Server 2.x** — install globally:
   ```bash
   npm install -g appium
   appium driver install uiautomator2   # Android
   appium driver install xcuitest       # iOS (macOS only)
   ```

2. **Python 3.10+**

3. **Built app on a device/emulator**
   - Android (dev flavor):
     ```bash
     flutter build apk --flavor dev -t lib/main.dart
     ```
   - iOS (dev flavor, macOS):
     ```bash
     flutter build ios --flavor dev -t lib/main.dart --simulator
     ```

4. Start an emulator/simulator and install the app, or set `APPIUM_APP_PATH` to the built `.apk` / `.app`.

## Setup

```bash
cd appium
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

## Run Tests

1. Start Appium in a separate terminal:
   ```bash
   appium
   ```

2. Run home screen tests:
   ```bash
   cd appium
   pytest tests/test_home_screen.py
   ```

### Environment variables

| Variable | Default | Description |
|----------|---------|-------------|
| `APPIUM_PLATFORM` | `android` | `android` or `ios` |
| `APPIUM_SERVER_URL` | `http://127.0.0.1:4723` | Appium server URL |
| `APPIUM_DEVICE_NAME` | `Android Emulator` | Device/simulator name |
| `APPIUM_APP_PACKAGE` | `com.example.flutter_rivperpod_template.dev` | Android app package |
| `APPIUM_APP_ACTIVITY` | `com.example.flutter_rivperpod_template.MainActivity` | Android launch activity |
| `APPIUM_BUNDLE_ID` | `dev.dinakar.flutter.rivperpod.template` | iOS bundle ID (dev) |
| `APPIUM_APP_PATH` | — | Optional path to `.apk` or `.app` |
| `APPIUM_IMPLICIT_WAIT` | `10` | Driver implicit wait (seconds) |
| `APPIUM_EXPLICIT_WAIT` | `15` | Page object explicit wait (seconds) |

### iOS example

```bash
export APPIUM_PLATFORM=ios
export APPIUM_DEVICE_NAME="iPhone 16"
export APPIUM_PLATFORM_VERSION="18.0"
pytest tests/test_home_screen.py
```

## Test Coverage

### Layout (`TestHomeScreenLayout`)
- Welcome card and subtitle are visible
- Features section header is visible
- All four feature cards are visible

### Navigation (`TestHomeScreenNavigation`)
- Settings button opens Settings
- API Integration → Repositories
- Search & Filter → Search Users
- State Management → Counter
- Auto Route Navigation → Navigation

### Bottom tabs (`TestHomeBottomNavigation`)
- Explore tab shows Explore screen
- Profile tab shows Profile screen
- Home tab returns to home content

## Accessibility IDs

Home screen widgets expose `Semantics.identifier` values for stable Appium locators:

| Element | Accessibility ID |
|---------|------------------|
| Welcome card | `home_welcome_card` |
| Features header | `home_features_header` |
| Settings button | `home_settings_button` |
| API Integration card | `home_feature_api_integration` |
| Search & Filter card | `home_feature_search_filter` |
| State Management card | `home_feature_state_management` |
| Auto Route card | `home_feature_auto_route_navigation` |
