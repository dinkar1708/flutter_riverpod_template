# Maestro E2E Tests

End-to-end tests driven by documented user journeys in `documentation/journeys/`.

**Keep docs, Appium specs (`appium/journey_specs.py`), and these flows in sync** when changing a journey.

## Documentation (source of truth)

| Resource | Purpose |
|----------|---------|
| [documentation/USER_JOURNEYS.md](../documentation/USER_JOURNEYS.md) | Journey index |
| [documentation/journeys/](../documentation/journeys/) | One markdown file per journey |
| [appium/journey_specs.py](../appium/journey_specs.py) | Expected text & selectors (Appium) |

## Architecture

```
documentation/journeys/*.md     ← human + AI readable steps
maestro/journeys/*.yaml       ← one Maestro flow per journey (1:1)
maestro/subflows/             ← shared login precondition
appium/journey_specs.py       ← shared verification targets
```

## Prerequisites

1. **Maestro CLI**
   ```bash
   curl -Ls "https://get.maestro.mobile.dev" | bash
   ```

2. **Built app (dev flavor)**
   ```bash
   flutter build apk --release --flavor dev -t lib/main/main_dev.dart --target-platform android-arm64
   adb install build/app/outputs/flutter-apk/app-dev-release.apk
   ```

3. Emulator/simulator running with the dev app installed.

## Run

```bash
# All journeys (run sequentially — avoids parallel device conflicts)
for f in maestro/journeys/0*.yaml; do maestro test "$f"; done

# Single journey (by spec ID)
maestro test maestro/journeys/01-guest-onboarding.yaml
maestro test maestro/journeys/03-bottom-tabs.yaml

# Chained suite
maestro test maestro/run_all_journeys.yaml

# Regenerate README screenshots (saved to documentation/screenshots/)
maestro test maestro/screenshots/capture_app_screenshots.yaml
```

**Note:** Maestro uses `Semantics.identifier` values and coordinate taps for bottom tabs (`50%, 94%` Explore, `83%, 94%` Profile, `17%, 94%` Home).

### iOS

```bash
maestro test --app-id dev.dinakar.flutter.rivperpod.template maestro/
```

## Journeys

| Spec ID | Doc | Maestro flow | Appium test |
|---------|-----|--------------|-------------|
| `guest_onboarding` | [01-guest-onboarding.md](../documentation/journeys/01-guest-onboarding.md) | `journeys/01-guest-onboarding.yaml` | `TestGuestOnboardingJourney` |
| `home_features_tour` | [02-home-features-tour.md](../documentation/journeys/02-home-features-tour.md) | `journeys/02-home-features-tour.yaml` | `TestHomeFeaturesJourney` |
| `bottom_tabs` | [03-bottom-tabs.md](../documentation/journeys/03-bottom-tabs.md) | `journeys/03-bottom-tabs.yaml` | `TestBottomTabsJourney` |
| `explore_discovery` | [04-explore-discovery.md](../documentation/journeys/04-explore-discovery.md) | `journeys/04-explore-discovery.yaml` | `TestExploreDiscoveryJourney` |
| `profile_settings` | [05-profile-settings.md](../documentation/journeys/05-profile-settings.md) | `journeys/05-profile-settings.yaml` | `TestProfileAndSettingsJourney` |

## App IDs

| Platform | Dev flavor |
|----------|------------|
| Android | `com.example.flutter_rivperpod_template.dev` |
| iOS | `dev.dinakar.flutter.rivperpod.template` |
