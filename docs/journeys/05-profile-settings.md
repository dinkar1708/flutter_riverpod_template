# Journey 5: Profile & settings

**Spec ID:** `profile_settings`  
**Doc file:** `docs/journeys/05-profile-settings.md`  
**Maestro flow:** `maestro/journeys/05-profile-settings.yaml`  
**Appium test:** `TestProfileAndSettingsJourney::test_guest_reviews_profile_and_settings`

## Summary

A guest user opens Settings from Home, reviews the Profile tab, and opens Settings from the profile menu.

## Actor

Guest user (already logged in)

## Preconditions

- Journey 1 completed
- User on home dashboard

## Steps

### Part A: Settings from Home

1. On home, tap **Settings** in the app bar (`home_settings_button`).
2. Verify **Appearance** section is visible.
3. Go back to home dashboard.

### Part B: Profile review

4. Tap **Profile** tab (`Tab 3 of 3`).
5. Verify profile screen shows:
   - **Account** section header
   - **Edit Profile** menu item
   - **Logout** button

### Part C: Settings from Profile menu

6. Tap **Settings** menu item (subtitle: `App preferences and configuration`).
7. Verify **Appearance** section is visible.

## Verify

- [ ] Settings from home app bar opens Appearance
- [ ] Profile shows Account, Edit Profile, and Logout
- [ ] Settings from profile menu opens Appearance

## Selectors

| Element | Locator |
|---------|---------|
| Home settings button | `home_settings_button` / label `Settings` |
| Profile tab | `Tab 3 of 3` |
| Account header | `Account` |
| Edit Profile | `Edit Profile` |
| Logout | `Logout` |
| Profile settings menu | description contains `App preferences and configuration` |
| Settings screen | `Appearance` |

## Success criteria

- Settings is reachable from both Home and Profile
- Profile account content is visible

## Failure criteria

- Settings does not open from app bar or profile menu
- Profile account section is missing
- User cannot return to home after settings from home
