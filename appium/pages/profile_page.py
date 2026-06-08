"""Profile tab page object."""

from __future__ import annotations

from typing import TYPE_CHECKING

from appium.webdriver.common.appiumby import AppiumBy

from pages.base_page import BasePage

if TYPE_CHECKING:
    from pages.home_page import HomePage


class ProfilePage(BasePage):
    ACCOUNT_HEADER = "Account"
    EDIT_PROFILE = "Edit Profile"
    SETTINGS_MENU = "Settings"
    LOGOUT = "Logout"

    def wait_for_screen(self) -> None:
        self.wait_until_visible(self.tab_locator("Profile"))
        self.wait_until_visible(self.label_locator(self.ACCOUNT_HEADER))

    def open_from_tab(self, home: HomePage) -> None:
        home.switch_to_profile_tab()
        self.wait_for_screen()

    def is_account_section_visible(self) -> bool:
        return self.is_displayed_by_text(self.ACCOUNT_HEADER)

    def is_edit_profile_visible(self) -> bool:
        return self.is_displayed_by_text(self.EDIT_PROFILE)

    def is_logout_visible(self) -> bool:
        return self.is_displayed_by_text(self.LOGOUT)

    def open_settings_from_menu(self) -> None:
        if self.platform == "ios":
            self.tap_by_label(self.SETTINGS_MENU)
            return

        selector = (
            'new UiSelector().descriptionContains("App preferences and configuration")'
        )
        self.wait_until_clickable((AppiumBy.ANDROID_UIAUTOMATOR, selector)).click()
