"""Appium E2E tests for the Home screen."""

from __future__ import annotations

from pages.explore_page import ExplorePage
from pages.home_page import HomePage


class TestHomeScreenLayout:
    """Verify home screen UI elements render after login."""

    def test_welcome_card_is_displayed(self, home_screen):
        home = HomePage(home_screen)
        home.wait_for_screen()

        assert home.is_welcome_card_visible()
        assert home.is_welcome_subtitle_visible()

    def test_features_section_is_displayed(self, home_screen):
        home = HomePage(home_screen)
        home.wait_for_screen()

        assert home.is_features_header_visible()
        assert home.is_displayed_by_text("Features")

    def test_all_feature_cards_are_visible(self, home_screen):
        home = HomePage(home_screen)
        home.wait_for_screen()

        assert home.are_all_feature_cards_visible()
        for title in HomePage.FEATURE_TITLES:
            assert home.is_displayed_by_text(title)


class TestHomeScreenNavigation:
    """Verify navigation from home screen feature cards and app bar."""

    def test_settings_button_opens_settings(self, home_screen):
        home = HomePage(home_screen)
        home.wait_for_screen()
        home.open_settings()

        assert HomePage(home_screen).is_displayed_by_text("Appearance")

    def test_api_integration_opens_repositories(self, home_screen):
        home = HomePage(home_screen)
        home.wait_for_screen()
        home.open_api_integration()

        assert HomePage(home_screen).is_displayed_by_text("Repositories")

    def test_search_filter_opens_users_screen(self, home_screen):
        home = HomePage(home_screen)
        home.wait_for_screen()
        home.open_search_and_filter()

        assert HomePage(home_screen).is_displayed_by_text("Search Users")

    def test_state_management_opens_counter(self, home_screen):
        home = HomePage(home_screen)
        home.wait_for_screen()
        home.open_state_management()

        assert HomePage(home_screen).is_displayed_by_text("Counter")

    def test_auto_route_navigation_opens_navigation_screen(self, home_screen):
        home = HomePage(home_screen)
        home.wait_for_screen()
        home.open_auto_route_navigation()

        assert HomePage(home_screen).is_displayed_by_text("Navigation")


class TestHomeBottomNavigation:
    """Verify bottom tab navigation from the home shell."""

    def test_explore_tab_shows_explore_screen(self, home_screen):
        home = HomePage(home_screen)
        explore = ExplorePage(home_screen)
        explore.open_from_home(home)

        assert explore.is_discover_section_visible()
        assert explore.are_all_trending_cards_visible()

    def test_profile_tab_shows_profile_screen(self, home_screen):
        home = HomePage(home_screen)
        home.wait_for_screen()
        home.switch_to_profile_tab()

        assert home.is_displayed_by_text("Account")

    def test_home_tab_returns_to_home_screen(self, home_screen):
        home = HomePage(home_screen)
        home.wait_for_screen()
        home.switch_to_explore_tab()
        home.switch_to_home_tab()

        assert home.is_welcome_card_visible()
        assert home.is_features_header_visible()


class TestExploreTab:
    """Verify Explore tab clicks and navigation."""

    def test_explore_tab_click_shows_trending_section(self, home_screen):
        home = HomePage(home_screen)
        explore = ExplorePage(home_screen)
        explore.open_from_home(home)

        assert explore.is_displayed_by_text(ExplorePage.TRENDING_HEADER)
        assert explore.is_displayed_by_text("Popular Repositories")
        assert explore.is_displayed_by_text("Active Users")
        assert explore.is_displayed_by_text("Featured Projects")

    def test_explore_tab_popular_repositories_opens_repositories(self, home_screen):
        home = HomePage(home_screen)
        explore = ExplorePage(home_screen)
        explore.open_from_home(home)
        explore.open_popular_repositories()

        assert HomePage(home_screen).is_displayed_by_text("Repositories")

    def test_explore_tab_active_users_opens_search_users(self, home_screen):
        home = HomePage(home_screen)
        explore = ExplorePage(home_screen)
        explore.open_from_home(home)
        explore.open_active_users()

        assert HomePage(home_screen).is_displayed_by_text("Search Users")

    def test_explore_tab_featured_projects_opens_featured(self, home_screen):
        home = HomePage(home_screen)
        explore = ExplorePage(home_screen)
        explore.open_from_home(home)
        explore.open_featured_projects()

        assert HomePage(home_screen).is_displayed_by_text("Featured")

    def test_explore_tab_settings_button_opens_settings(self, home_screen):
        home = HomePage(home_screen)
        explore = ExplorePage(home_screen)
        explore.open_from_home(home)
        explore.open_settings()

        assert HomePage(home_screen).is_displayed_by_text("Appearance")
