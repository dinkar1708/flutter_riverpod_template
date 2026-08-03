# Journey 2: Home features tour

**Spec ID:** `home_features_tour`  
**Doc file:** `docs/journeys/02-home-features-tour.md`  
**Maestro flow:** `maestro/journeys/02-home-features-tour.yaml`  
**Appium test:** `TestHomeFeaturesJourney::test_guest_browses_all_home_features`

## Summary

A guest user opens each home feature card, verifies the destination screen, and returns to home before trying the next feature.

## Actor

Guest user (already logged in on home tab)

## Preconditions

- Journey 1 completed (user on home dashboard)
- Home tab is active

## Steps

For each feature below:

1. Ensure you are on the home dashboard.
2. Tap the feature card.
3. Verify the destination screen loads.
4. Navigate back to the home dashboard.

### Feature 1: API Integration

- Tap **API Integration**
- Verify screen contains **Repositories**
- Go back to home

### Feature 2: Search & Filter

- Tap **Search & Filter**
- Verify screen contains **Search Users**
- Go back to home

### Feature 3: State Management

- Tap **State Management**
- Verify screen contains **increase counter**
- Go back to home

### Feature 4: Auto Route Navigation

- Tap **Auto Route Navigation**
- Verify screen contains **NavigationChild1Route**
- Go back to home

## Verify

- [ ] All four features open the correct destination
- [ ] User returns to home after each feature
- [ ] Home dashboard is usable after the full tour

## Selectors

| Feature | Semantics ID | Tap label |
|---------|--------------|-----------|
| API Integration | `home_feature_api_integration` | API Integration |
| Search & Filter | `home_feature_search_filter` | Search & Filter |
| State Management | `home_feature_state_management` | State Management |
| Auto Route Navigation | `home_feature_auto_route_navigation` | Auto Route Navigation |

## Success criteria

- All four round-trips complete without error

## Failure criteria

- A feature card does not open its screen
- Back navigation does not return to home
- Wrong destination screen is shown
