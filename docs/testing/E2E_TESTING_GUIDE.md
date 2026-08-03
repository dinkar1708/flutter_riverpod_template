# End-to-End Testing Guide


## Overview

E2E tests verify complete user journeys across the application. This project uses Maestro and Appium for automated E2E testing.

## Maestro Testing

### Setup

Maestro is a mobile UI testing framework that uses YAML flows.

Location: `maestro/`

### Example Flow

File: `maestro/login_flow.yaml`

```yaml
appId: com.example.flutter_riverpod_template
---
- launchApp
- tapOn: "Continue as Guest"
- assertVisible: "Dashboard"
- tapOn:
    id: "settings_tab"
- assertVisible: "Settings"
- tapOn: "Logout"
- assertVisible: "Welcome Back"
```

### Running Maestro Tests

```bash
# Install Maestro
brew tap mobile-dev-inc/tap
brew install maestro

# Run single flow
maestro test maestro/login_flow.yaml

# Run all flows
maestro test maestro/
```

### Test Journeys

Available journeys in `maestro/`:
- Login flow (guest, email)
- User profile viewing
- Repository browsing
- Settings management
- Logout flow

## Appium Testing

### Setup

Appium uses Python for test automation.

Location: `appium/`

### Dependencies

```bash
cd appium
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

### Example Test

File: `appium/tests/test_login.py`

```python
def test_guest_login(driver):
    # Find and tap guest login button
    guest_button = driver.find_element(
        by=AppiumBy.ACCESSIBILITY_ID,
        value="continue_as_guest"
    )
    guest_button.click()

    # Wait for home screen
    WebDriverWait(driver, 10).until(
        EC.presence_of_element_located(
            (AppiumBy.ACCESSIBILITY_ID, "home_screen")
        )
    )

    # Verify navigation
    assert driver.find_element(
        by=AppiumBy.ACCESSIBILITY_ID,
        value="dashboard_title"
    ).text == "Dashboard"
```

### Running Appium Tests

```bash
# Start Appium server
appium

# Run tests (in another terminal)
cd appium
source .venv/bin/activate
pytest tests/ -v
```

## Test Coverage

Current E2E test coverage:

Journey 1: App Launch and Guest Login
Journey 2: User Login Flow
Journey 3: Profile Viewing
Journey 4: Repository List
Journey 5: Settings and Logout

See TEST_JOURNEYS.md for detailed scenarios.

## Best Practices

### Maestro
- Use semantic labels for elements
- Keep flows simple and focused
- Add assertions after each action
- Use variables for test data

### Appium
- Use explicit waits, not sleep
- Prefer accessibility IDs over XPath
- Clean up after each test
- Use Page Object pattern

## CI Integration

E2E tests run in GitHub Actions on every PR.

See `.github/workflows/e2e.yml` for configuration.

## Debugging

### Maestro
```bash
# Run with screenshots
maestro test --screenshot

# Interactive mode
maestro studio
```

### Appium
```bash
# Run with verbose logging
pytest tests/ -v -s

# Run specific test
pytest tests/test_login.py::test_guest_login
```

## References

- Maestro Documentation: https://maestro.mobile.dev/
- Appium Documentation: https://appium.io/
