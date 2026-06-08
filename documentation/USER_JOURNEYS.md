# User Journeys

Canonical E2E user flows for the Flutter Riverpod Template app.  
Automated tests implement these journeys in two runners:

- **Maestro:** `maestro/journeys/*.yaml` (one flow per journey)
- **Appium:** `appium/tests/test_user_journeys.py` via `appium/journey_specs.py`

**When you change a journey:** update the matching doc file, `journey_specs.py`, the Appium test class, and the Maestro flow in the same change.

## Journey index

| # | Journey | Documentation | Spec ID | Maestro flow | Appium test |
|---|---------|---------------|---------|--------------|-------------|
| 1 | Guest onboarding | [01-guest-onboarding.md](journeys/01-guest-onboarding.md) | `guest_onboarding` | `maestro/journeys/01-guest-onboarding.yaml` | `TestGuestOnboardingJourney` |
| 2 | Home features tour | [02-home-features-tour.md](journeys/02-home-features-tour.md) | `home_features_tour` | `maestro/journeys/02-home-features-tour.yaml` | `TestHomeFeaturesJourney` |
| 3 | Bottom tabs | [03-bottom-tabs.md](journeys/03-bottom-tabs.md) | `bottom_tabs` | `maestro/journeys/03-bottom-tabs.yaml` | `TestBottomTabsJourney` |
| 4 | Explore discovery | [04-explore-discovery.md](journeys/04-explore-discovery.md) | `explore_discovery` | `maestro/journeys/04-explore-discovery.yaml` | `TestExploreDiscoveryJourney` |
| 5 | Profile & settings | [05-profile-settings.md](journeys/05-profile-settings.md) | `profile_settings` | `maestro/journeys/05-profile-settings.yaml` | `TestProfileAndSettingsJourney` |

## Run automated journeys

### Maestro

```bash
maestro test maestro/                                          # all journeys
maestro test maestro/journeys/03-bottom-tabs.yaml              # one journey
maestro test maestro/run_all_journeys.yaml                     # full suite in order
```

See [maestro/README.md](../maestro/README.md) for device setup.

### Appium

```bash
# Start Appium, then:
cd appium
source .venv/bin/activate
pytest tests/test_user_journeys.py -v
```

Run a single journey:

```bash
pytest tests/test_user_journeys.py::TestBottomTabsJourney -v
```

See [appium/README.md](../appium/README.md) for device setup and environment variables.

## AI / manual testing

Each journey file includes:

- Preconditions
- Numbered steps
- Verification checklist
- UI labels and accessibility selectors
- Link to the automated test

Prompt example for AI tools:

> Execute the steps in `documentation/journeys/03-bottom-tabs.md` and verify against `appium/journey_specs.py` and `maestro/journeys/03-bottom-tabs.yaml`.
