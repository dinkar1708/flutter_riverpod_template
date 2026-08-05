# Journey 3: Bottom tabs round trip

**Spec ID:** `bottom_tabs`  
**Doc file:** `docs/journeys/03-bottom-tabs.md`  
**Maestro flow:** `maestro/journeys/03-bottom-tabs.yaml`  
**Appium test:** `TestBottomTabsJourney::test_guest_navigates_bottom_tabs_round_trip`

## Summary

A guest user navigates across all bottom tabs — Home, Explore, Profile — and returns to Home.

## Actor

Guest user (already logged in)

## Preconditions

- Journey 1 completed (user on home dashboard)
- Bottom navigation bar is visible

## Steps

1. Verify home dashboard (welcome card visible).
2. Tap **Explore** tab (`Tab 2 of 3`).
3. Verify Explore screen:
   - **Discover More**
   - **Explore additional features and demos**
   - **Trending** section
   - Cards: Popular Repositories, Active Users, Featured Projects
4. Tap **Profile** tab (`Tab 3 of 3`).
5. Verify Profile screen:
   - **Account** section
   - **Edit Profile** menu item
6. Tap **Home** tab (`Tab 1 of 3`).
7. Verify home dashboard again (welcome card + features header).

## Verify

- [ ] Explore tab shows discover section and all trending cards
- [ ] Profile tab shows account section and edit profile
- [ ] Home tab shows welcome card and features header after round trip

## Selectors

| Tab | Android bottom nav locator |
|-----|----------------------------|
| Home | `UiSelector().descriptionContains("Tab 1 of 3")` |
| Explore | `UiSelector().descriptionContains("Tab 2 of 3")` |
| Profile | `UiSelector().descriptionContains("Tab 3 of 3")` |

## Success criteria

- All three tabs are reachable and show expected content
- User ends on Home tab with dashboard visible

## Failure criteria

- Tab tap opens wrong screen
- Content from a previous tab blocks verification
- Cannot return to home dashboard
