"""Explore tab page object."""

from __future__ import annotations

from typing import TYPE_CHECKING

from pages.base_page import BasePage

if TYPE_CHECKING:
    from pages.home_page import HomePage


class ExplorePage(BasePage):
    DISCOVER_MORE = "Discover More"
    DISCOVER_SUBTITLE = "Explore additional features and demos"
    TRENDING_HEADER = "Trending"
    TRENDING_TITLES = (
        "Popular Repositories",
        "Active Users",
        "Featured Projects",
    )

    def wait_for_screen(self) -> None:
        self.wait_until_visible(self.tab_locator("Explore"))
        self.wait_until_visible(self.label_locator(self.DISCOVER_MORE))
        self.wait_until_visible(self.label_locator(self.TRENDING_HEADER))

    def open_from_home(self, home: HomePage) -> None:
        home.wait_for_screen()
        home.switch_to_explore_tab()
        self.wait_for_screen()

    def is_discover_section_visible(self) -> bool:
        return (
            self.is_displayed_by_text(self.DISCOVER_MORE)
            and self.is_displayed_by_text(self.DISCOVER_SUBTITLE)
        )

    def are_all_trending_cards_visible(self) -> bool:
        return all(self.is_displayed_by_text(title) for title in self.TRENDING_TITLES)

    def open_popular_repositories(self) -> None:
        self.tap_by_label("Popular Repositories")

    def open_active_users(self) -> None:
        self.tap_by_label("Active Users")

    def open_featured_projects(self) -> None:
        self.tap_by_label("Featured Projects")

    def open_settings(self) -> None:
        self.tap_by_label("Settings")
