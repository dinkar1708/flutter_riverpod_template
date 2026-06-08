# Journey 4: Explore discovery

**Spec ID:** `explore_discovery`  
**Doc file:** `documentation/journeys/04-explore-discovery.md`  
**Maestro flow:** `maestro/journeys/04-explore-discovery.yaml`  
**Appium test:** `TestExploreDiscoveryJourney::test_guest_explores_trending_and_detail_screens`

## Summary

A guest user opens the Explore tab, visits each trending card destination, opens Settings from Explore, and returns to Explore each time.

## Actor

Guest user (already logged in)

## Preconditions

- Journey 1 completed
- User can reach bottom navigation

## Steps

1. From home, tap **Explore** tab.
2. Verify Explore screen is visible (Discover More + Trending).

For each trending card:

3. Tap **Popular Repositories** → verify **Repositories** → go back → verify Explore.
4. Tap **Active Users** → verify **Search Users** → go back → verify Explore.
5. Tap **Featured Projects** → verify **Featured** → go back → verify Explore.

6. Tap **Settings** in the Explore app bar.
7. Verify **Appearance** section on Settings screen.
8. Go back to Explore.

## Verify

- [ ] Popular Repositories opens Repositories screen
- [ ] Active Users opens Search Users screen
- [ ] Featured Projects opens Featured screen
- [ ] Settings from Explore shows Appearance section
- [ ] User returns to Explore after each back navigation

## Selectors

| Element | Label |
|---------|-------|
| Popular Repositories | Popular Repositories |
| Active Users | Active Users |
| Featured Projects | Featured Projects |
| Explore settings | Settings |
| Settings screen | Appearance |

## Success criteria

- All trending destinations and Explore settings are reachable
- Explore tab remains usable after each back action

## Failure criteria

- Trending card does not navigate
- Back navigation lands on wrong tab
- Settings does not show Appearance
