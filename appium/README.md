# Appium E2E Tests

End-to-end tests driven by documented user journeys.

## Documentation (source of truth)

| Resource | Purpose |
|----------|---------|
| [documentation/USER_JOURNEYS.md](../documentation/USER_JOURNEYS.md) | Journey index |
| [documentation/journeys/](../documentation/journeys/) | One markdown file per journey |
| [journey_specs.py](journey_specs.py) | Machine-readable spec used by tests |

**Keep docs, specs, and tests in sync** when changing a flow.

## Architecture

```
documentation/journeys/*.md   ← human + AI readable steps
journey_specs.py              ← expected text, selectors, test mapping
pages/                        ← Page Object Model
tests/test_user_journeys.py   ← 5 journey tests
```

## Prerequisites

1. **Appium Server 3.x**
   ```bash
   npm install -g appium
   appium driver install uiautomator2
   ```

2. **Python 3.10+**

3. **Built app (dev flavor)**
   ```bash
   flutter build apk --flavor dev -t lib/main/main_dev.dart
   ```

## Setup

```bash
cd appium
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

## Run

```bash
appium   # separate terminal

cd appium
pytest tests/test_user_journeys.py -v
```

Run one journey (see doc for mapping):

```bash
pytest tests/test_user_journeys.py::TestBottomTabsJourney -v
pytest -m "journey(bottom_tabs)" -v
```

## Journeys

| Spec ID | Doc | Maestro flow | Test class |
|---------|-----|--------------|------------|
| `guest_onboarding` | [01-guest-onboarding.md](../documentation/journeys/01-guest-onboarding.md) | `maestro/journeys/01-guest-onboarding.yaml` | `TestGuestOnboardingJourney` |
| `home_features_tour` | [02-home-features-tour.md](../documentation/journeys/02-home-features-tour.md) | `maestro/journeys/02-home-features-tour.yaml` | `TestHomeFeaturesJourney` |
| `bottom_tabs` | [03-bottom-tabs.md](../documentation/journeys/03-bottom-tabs.md) | `maestro/journeys/03-bottom-tabs.yaml` | `TestBottomTabsJourney` |
| `explore_discovery` | [04-explore-discovery.md](../documentation/journeys/04-explore-discovery.md) | `maestro/journeys/04-explore-discovery.yaml` | `TestExploreDiscoveryJourney` |
| `profile_settings` | [05-profile-settings.md](../documentation/journeys/05-profile-settings.md) | `maestro/journeys/05-profile-settings.yaml` | `TestProfileAndSettingsJourney` |

Maestro equivalent: `maestro test maestro/` — see [maestro/README.md](../maestro/README.md).

## Environment variables

| Variable | Default |
|----------|---------|
| `APPIUM_PLATFORM` | `android` |
| `APPIUM_SERVER_URL` | `http://127.0.0.1:4723` |
| `APPIUM_APP_PACKAGE` | `com.example.flutter_rivperpod_template.dev` |
| `APPIUM_APP_ACTIVITY` | `com.example.flutter_rivperpod_template.MainActivity` |
| `APPIUM_NO_RESET` | `true` |
| `APPIUM_EXPLICIT_WAIT` | `15` |
