# Testing Documentation


## Overview

This folder contains all testing documentation for the Flutter Riverpod Template project. We follow a comprehensive testing strategy covering unit, widget, and end-to-end tests.

---

## Testing Types

### Unit Tests
**Purpose:** Test business logic, providers, and repositories in isolation

**Coverage:** 44+ tests covering core functionality

**Location:** `test/unit/`

**Documentation:** [UNIT_TESTING_GUIDE.md](UNIT_TESTING_GUIDE.md)

**What We Test:**
- Riverpod providers
- Repository methods
- Data models and serialization
- State management logic
- Error handling

**Tools:**
- flutter_test
- mockito for mocking
- Riverpod testing utilities

**Run Tests:**
```bash
flutter test test/unit/
```

---

### Widget Tests
**Purpose:** Test UI components and user interactions

**Coverage:** Login page, navigation, and core widgets

**Location:** `test/widget/`

**Documentation:** [WIDGET_TESTING_GUIDE.md](WIDGET_TESTING_GUIDE.md)

**What We Test:**
- Widget rendering
- User interactions (taps, input)
- Provider integration in widgets
- Navigation flows
- Form validation

**Tools:**
- flutter_test
- ProviderScope for Riverpod testing
- Widget tester utilities

**Run Tests:**
```bash
flutter test test/widget/
```

---

### E2E Tests
**Purpose:** Test complete user journeys from end to end

**Coverage:** 5 critical user journeys

**Location:** `maestro/` and `appium/`

**Documentation:** [E2E_TESTING_GUIDE.md](E2E_TESTING_GUIDE.md)

**What We Test:**
- Complete user flows
- Real device interactions
- Cross-screen navigation
- API integration
- App stability

**Tools:**
- Maestro (5 YAML flows)
- Appium (Python tests)

**Run Tests:**
```bash
# Maestro
maestro test maestro/journeys/

# Appium
cd appium && pytest tests/
```

---

## User Journeys

We have 5 documented user journeys with corresponding E2E tests:

1. **Guest Onboarding** - Login as guest and view dashboard
2. **Home Features Tour** - Explore all home page features
3. **Bottom Tabs** - Navigate through all tabs
4. **Explore Discovery** - Browse explore content
5. **Profile Settings** - View profile and change settings

**Documentation:** [TEST_JOURNEYS.md](TEST_JOURNEYS.md)

**Journey Specs:** `docs/journeys/`

---

## Test Coverage

**Current Status:**
- Unit Tests: 70%+ coverage of business logic
- Widget Tests: Core screens and navigation
- E2E Tests: 100% of critical user flows

**Run Coverage Report:**
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

---

## Testing Best Practices

### Unit Testing
- One test file per source file
- Use descriptive test names
- Follow Arrange-Act-Assert pattern
- Mock external dependencies
- Test both success and error cases

### Widget Testing
- Use ProviderScope for Riverpod widgets
- Test user interactions, not implementation
- Use semantic finders when possible
- Verify widget tree structure
- Test accessibility

### E2E Testing
- Keep tests independent
- Use stable selectors (IDs over text)
- Add proper wait conditions
- Test critical paths first
- Document test data requirements

---

## Quick Reference

| Test Type | Command | Location | Count |
|-----------|---------|----------|-------|
| Unit | `flutter test test/unit/` | test/unit/ | 44+ |
| Widget | `flutter test test/widget/` | test/widget/ | 10+ |
| E2E Maestro | `maestro test maestro/journeys/` | maestro/journeys/ | 5 |
| E2E Appium | `cd appium && pytest tests/` | appium/tests/ | 5 |
| All Tests | `flutter test` | test/ | All |

---

## CI/CD Integration

Tests run automatically on:
- Pull Requests: Unit and Widget tests
- Main Branch: All tests including E2E
- Nightly: Full regression suite

**Configuration:** `.github/workflows/`

---

## Guides

### For Developers
- [Unit Testing Guide](UNIT_TESTING_GUIDE.md) - Writing unit tests for providers
- [Widget Testing Guide](WIDGET_TESTING_GUIDE.md) - Testing UI components
- [E2E Testing Guide](E2E_TESTING_GUIDE.md) - Setting up E2E tests

### For QA
- [Test Journeys](TEST_JOURNEYS.md) - User flow test cases
- [Journey Specs](../journeys/) - Detailed journey documentation

---

## Related Documentation

- [Architecture](../technical/ARCHITECTURE.md) - App structure
- [Features](../features/README.md) - All app features
- [Code Style](../technical/CODE_STYLE.md) - Coding standards

