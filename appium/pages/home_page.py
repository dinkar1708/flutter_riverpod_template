"""Home screen page object."""

from __future__ import annotations

from appium.webdriver.common.appiumby import AppiumBy

from pages.base_page import BasePage


class HomePage(BasePage):
    WELCOME_SUBTITLE = "Ready to explore? Check out the features below"
    FEATURE_TITLES = (
        "API Integration",
        "Search & Filter",
        "State Management",
        "Auto Route Navigation",
    )

    def is_tab_bar_visible(self) -> bool:
        return self.is_displayed_by_text("Tab 1 of 3")

    def return_to_home_tab(self) -> None:
        for _ in range(6):
            if self.is_tab_bar_visible():
                self.switch_to_home_tab()
                if self.is_displayed_by_text(self.WELCOME_SUBTITLE):
                    return
            else:
                self.go_back()
        self.wait_for_screen()

    def wait_for_screen(self) -> None:
        self.wait_until_visible(self.semantics_locator("home_welcome_card"))
        self.wait_until_visible(self.semantics_locator("home_features_header"))

    def is_welcome_card_visible(self) -> bool:
        return self.is_displayed_by_semantics_id("home_welcome_card")

    def is_features_header_visible(self) -> bool:
        return self.is_displayed_by_semantics_id("home_features_header")

    def is_welcome_subtitle_visible(self) -> bool:
        return self.is_displayed_by_text(self.WELCOME_SUBTITLE)

    def are_all_feature_cards_visible(self) -> bool:
        semantics_ids = (
            "home_feature_api_integration",
            "home_feature_search_filter",
            "home_feature_state_management",
            "home_feature_auto_route_navigation",
        )
        return all(self.is_displayed_by_semantics_id(item) for item in semantics_ids)

    def tap_feature(self, semantics_id: str, label: str) -> None:
        if self.platform == "ios":
            self.tap_by_label(label)
            return
        selector = (
            f'new UiSelector().resourceId("{semantics_id}")'
            f'.childSelector(new UiSelector().clickable(true))'
        )
        try:
            self.wait_until_clickable((AppiumBy.ANDROID_UIAUTOMATOR, selector)).click()
        except Exception:
            self.scroll_to_label(label)
            self.tap_by_label(label)

    def open_settings(self) -> None:
        self.tap_by_label("Settings")

    def open_api_integration(self) -> None:
        self.tap_feature("home_feature_api_integration", "API Integration")

    def open_search_and_filter(self) -> None:
        self.tap_feature("home_feature_search_filter", "Search & Filter")

    def open_state_management(self) -> None:
        self.tap_feature("home_feature_state_management", "State Management")

    def open_auto_route_navigation(self) -> None:
        self.tap_feature("home_feature_auto_route_navigation", "Auto Route Navigation")

    def switch_to_home_tab(self) -> None:
        self.tap_by_tab("Home")

    def switch_to_explore_tab(self) -> None:
        self.tap_by_tab("Explore")

    def switch_to_profile_tab(self) -> None:
        self.tap_by_tab("Profile")
