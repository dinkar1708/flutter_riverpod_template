"""
User journey E2E tests.

Each test class implements one journey from documentation/journeys/*.md.
Step data and expected outcomes are defined in appium/journey_specs.py.
"""

from __future__ import annotations

from journey_specs import (
    EXPLORE_TRENDING_DESTINATIONS,
    GUEST_ONBOARDING_FEATURE_SEMANTICS_IDS,
    GUEST_ONBOARDING_WELCOME_SUBTITLE,
    HOME_FEATURE_DESTINATIONS,
    PROFILE_ACCOUNT_HEADER,
    PROFILE_EDIT_PROFILE,
    PROFILE_LOGOUT,
    SETTINGS_APPEARANCE_TEXT,
)
from pages.app_session import AppSession


class TestGuestOnboardingJourney:
    """Journey 1 — documentation/journeys/01-guest-onboarding.md"""

    def test_guest_user_sees_home_dashboard(self, app_session: AppSession):
        home = app_session.home

        home.wait_for_screen()
        assert home.is_welcome_card_visible()
        assert home.is_displayed_by_text(GUEST_ONBOARDING_WELCOME_SUBTITLE)
        assert home.is_features_header_visible()
        for semantics_id in GUEST_ONBOARDING_FEATURE_SEMANTICS_IDS:
            assert home.is_displayed_by_semantics_id(semantics_id)


class TestHomeFeaturesJourney:
    """Journey 2 — documentation/journeys/02-home-features-tour.md"""

    def test_guest_browses_all_home_features(self, app_session: AppSession):
        home = app_session.home

        home.wait_for_screen()

        for opener_name, expected_screen in HOME_FEATURE_DESTINATIONS:
            home.return_to_home_tab()
            getattr(home, opener_name)()
            home.wait_until_text_visible(expected_screen)
            home.return_to_home_tab()


class TestBottomTabsJourney:
    """Journey 3 — documentation/journeys/03-bottom-tabs.md"""

    def test_guest_navigates_bottom_tabs_round_trip(self, app_session: AppSession):
        home = app_session.home
        explore = app_session.explore
        profile = app_session.profile

        home.wait_for_screen()
        assert home.is_welcome_card_visible()

        explore.open_from_home(home)
        assert explore.is_discover_section_visible()
        assert explore.are_all_trending_cards_visible()

        profile.open_from_tab(home)
        assert home.is_displayed_by_text(PROFILE_ACCOUNT_HEADER)
        assert home.is_displayed_by_text(PROFILE_EDIT_PROFILE)

        home.switch_to_home_tab()
        home.wait_for_screen()
        assert home.is_welcome_card_visible()
        assert home.is_features_header_visible()


class TestExploreDiscoveryJourney:
    """Journey 4 — documentation/journeys/04-explore-discovery.md"""

    def test_guest_explores_trending_and_detail_screens(self, app_session: AppSession):
        home = app_session.home
        explore = app_session.explore

        explore.open_from_home(home)

        for opener_name, expected_screen in EXPLORE_TRENDING_DESTINATIONS:
            explore.ensure_visible(home)
            getattr(explore, opener_name)()
            home.wait_until_text_visible(expected_screen)
            home.go_back()
            explore.ensure_visible(home)

        explore.open_settings()
        home.wait_until_text_visible(SETTINGS_APPEARANCE_TEXT)
        home.go_back()
        explore.ensure_visible(home)


class TestProfileAndSettingsJourney:
    """Journey 5 — documentation/journeys/05-profile-settings.md"""

    def test_guest_reviews_profile_and_settings(self, app_session: AppSession):
        home = app_session.home
        profile = app_session.profile

        home.wait_for_screen()
        home.open_settings()
        home.wait_until_text_visible(SETTINGS_APPEARANCE_TEXT)
        home.go_back()
        home.return_to_home_tab()

        profile.open_from_tab(home)
        assert home.is_displayed_by_text(PROFILE_ACCOUNT_HEADER)
        assert home.is_displayed_by_text(PROFILE_EDIT_PROFILE)
        assert home.is_displayed_by_text(PROFILE_LOGOUT)

        profile.open_settings_from_menu()
        home.wait_until_text_visible(SETTINGS_APPEARANCE_TEXT)
