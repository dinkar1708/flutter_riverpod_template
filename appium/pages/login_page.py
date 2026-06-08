"""Login screen page object."""

from __future__ import annotations

from appium.webdriver.common.appiumby import AppiumBy

from pages.base_page import BasePage


class LoginPage(BasePage):
    CONTINUE_AS_GUEST = (AppiumBy.ACCESSIBILITY_ID, "Continue as Guest")
    SIGN_IN = (AppiumBy.ACCESSIBILITY_ID, "Sign In")

    def wait_for_login_screen(self) -> None:
        self.wait_until_visible(self.CONTINUE_AS_GUEST)

    def continue_as_guest(self) -> None:
        self.wait_until_clickable(self.CONTINUE_AS_GUEST).click()

    def sign_in(self) -> None:
        self.wait_until_clickable(self.SIGN_IN).click()

    def wait_for_home_screen(self) -> None:
        self.wait_until_visible(self.semantics_locator("home_welcome_card"))
