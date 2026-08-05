# Test Journeys


## Overview

This document provides an index of all user journey specifications and their corresponding E2E tests. Each journey is documented separately with detailed steps, verification criteria, and test implementations.

---

## Available Journeys

### 1. Guest Onboarding
**Goal:** New user opens app and accesses content as guest

**Documentation:** [01-guest-onboarding.md](../journeys/01-guest-onboarding.md)

**Test Implementations:**
- **Maestro:** `maestro/journeys/01-guest-onboarding.yaml`
- **Appium:** `appium/tests/test_guest_onboarding_journey.py`

**Key Features Tested:**
- Login screen visibility
- Guest login button
- Home dashboard load
- Welcome card display

---

### 2. Home Features Tour
**Goal:** User explores all feature cards on home dashboard

**Documentation:** [02-home-features-tour.md](../journeys/02-home-features-tour.md)

**Test Implementations:**
- **Maestro:** `maestro/journeys/02-home-features-tour.yaml`
- **Appium:** `appium/tests/test_home_features_journey.py`

**Key Features Tested:**
- API Integration card → Repositories page
- Search & Filter card → Search users page
- State Management card → Counter demo
- Auto Route Navigation card → Navigation demo

---

### 3. Bottom Tabs Navigation
**Goal:** User navigates through all bottom tabs

**Documentation:** [03-bottom-tabs.md](../journeys/03-bottom-tabs.md)

**Test Implementations:**
- **Maestro:** `maestro/journeys/03-bottom-tabs.yaml`
- **Appium:** `appium/tests/test_bottom_tabs_journey.py`

**Key Features Tested:**
- Home tab active by default
- Explore tab switch
- Profile tab switch
- Tab state persistence

---

### 4. Explore Discovery
**Goal:** User discovers trending content in Explore tab

**Documentation:** [04-explore-discovery.md](../journeys/04-explore-discovery.md)

**Test Implementations:**
- **Maestro:** `maestro/journeys/04-explore-discovery.yaml`
- **Appium:** `appium/tests/test_explore_discovery_journey.py`

**Key Features Tested:**
- Explore tab content load
- Discovery feed display
- Trending items visible
- Content interaction

---

### 5. Profile & Settings
**Goal:** User views profile and modifies settings

**Documentation:** [05-profile-settings.md](../journeys/05-profile-settings.md)

**Test Implementations:**
- **Maestro:** `maestro/journeys/05-profile-settings.yaml`
- **Appium:** `appium/tests/test_profile_settings_journey.py`

**Key Features Tested:**
- Profile page load
- Account information display
- Settings menu navigation
- Appearance settings
- Dark mode toggle (if implemented)

---

## Running Journey Tests

### Run All Maestro Journeys
```bash
# Run all journeys sequentially
maestro test maestro/run_all_journeys.yaml

# Run individual journey
maestro test maestro/journeys/01-guest-onboarding.yaml
```

### Run All Appium Journeys
```bash
# Navigate to appium directory
cd appium

# Run all journey tests
pytest tests/test_*_journey.py -v

# Run specific journey
pytest tests/test_guest_onboarding_journey.py -v
```

### Capture Screenshots
```bash
# Generate screenshots for all journeys
maestro test maestro/screenshots/capture_app_screenshots.yaml

# Screenshots saved to: docs/screenshots/
```

---

## Journey Test Matrix

| Journey | Maestro | Appium | Status | Duration |
|---------|---------|--------|--------|----------|
| Guest Onboarding | Yes | Yes | Passing | 8s |
| Home Features Tour | Yes | Yes | Passing | 25s |
| Bottom Tabs | Yes | Yes | Passing | 10s |
| Explore Discovery | Yes | Yes | Passing | 12s |
| Profile Settings | Yes | Yes | Passing | 15s |

Total Coverage: 5 journeys, 10 test files (5 Maestro and 5 Appium)

---

## Test Environment

### Preconditions
All journeys assume:
- App is freshly installed or data cleared
- Device has internet connection
- Development build installed (`com.example.flutter_rivperpod_template.dev`)

### Test Data
- **Default username:** `dinkar1708` (for login)
- **API:** GitHub API (https://api.github.com/)
- **Environment:** Development (.env.dev)

---

## Journey Documentation Standards

Each journey document includes:
- **Spec ID** - Unique identifier
- **Summary** - Brief description
- **Actor** - User type (Guest/Authenticated)
- **Preconditions** - Required state before starting
- **Steps** - Detailed step-by-step actions
- **Verify** - Success criteria checklist
- **Selectors** - UI element locators
- **Success/Failure Criteria** - Pass/fail conditions

See [Journey Documentation Template](../journeys/01-guest-onboarding.md) for reference.

---

## Adding New Journeys

1. **Create journey specification**
   ```bash
   # Create new journey doc
   touch docs/journeys/06-new-journey.md
   ```

2. **Implement Maestro test**
   ```bash
   # Create Maestro flow
   touch maestro/journeys/06-new-journey.yaml
   ```

3. **Implement Appium test**
   ```bash
   # Create Appium test
   touch appium/tests/test_new_journey.py
   ```

4. **Update this index**
   - Add journey to "Available Journeys" section
   - Update test matrix
   - Update total coverage count

5. **Add screenshots**
   - Update `maestro/screenshots/capture_app_screenshots.yaml`
   - Run screenshot capture
   - Add images to `docs/screenshots/`

---

## Continuous Integration

Journey tests run automatically on:
- Pull Requests - All journeys must pass
- Main Branch - After merge
- Nightly - Full regression suite

**CI Configuration:** `.github/workflows/e2e-tests.yml`

---

## Related Documentation

- [E2E Testing Guide](E2E_TESTING_GUIDE.md) - Setup and tooling
- [Unit Testing Guide](UNIT_TESTING_GUIDE.md) - Unit test patterns
- [Widget Testing Guide](WIDGET_TESTING_GUIDE.md) - Widget tests
- [Feature Overview](../features/README.md) - All app features

