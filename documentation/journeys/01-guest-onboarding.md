# Journey 1: Guest onboarding

**Spec ID:** `guest_onboarding`  
**Doc file:** `documentation/journeys/01-guest-onboarding.md`  
**Maestro flow:** `maestro/journeys/01-guest-onboarding.yaml`  
**Appium test:** `TestGuestOnboardingJourney::test_guest_user_sees_home_dashboard`

## Summary

A new user opens the app, skips login with guest access, and lands on the home dashboard.

## Actor

Guest user (demo mode)

## Preconditions

- App is freshly launched (splash screen completes)
- Login screen is visible
- Android dev package: `com.example.flutter_rivperpod_template.dev`

## Steps

1. Wait for the login screen.
2. Tap **Continue as Guest**.
3. Wait for the home screen to load.

## Verify

- [ ] Welcome card is visible (`home_welcome_card`)
- [ ] Subtitle text: `Ready to explore? Check out the features below`
- [ ] Features section header is visible (`home_features_header`)
- [ ] All four feature cards are visible:
  - API Integration (`home_feature_api_integration`)
  - Search & Filter (`home_feature_search_filter`)
  - State Management (`home_feature_state_management`)
  - Auto Route Navigation (`home_feature_auto_route_navigation`)

## Selectors

| Element | Label / ID | Android locator |
|---------|------------|-----------------|
| Continue as Guest | `Continue as Guest` | accessibility id |
| Welcome card | `home_welcome_card` | `UiSelector().resourceId("home_welcome_card")` |
| Features header | `home_features_header` | `UiSelector().resourceId("home_features_header")` |

## Success criteria

- User is on the **Home** bottom tab
- No error dialogs or crash

## Failure criteria

- Login screen does not appear within timeout
- Home dashboard elements are missing after guest login
