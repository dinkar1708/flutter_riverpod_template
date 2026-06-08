"""Bundles page objects for user journey tests."""

from __future__ import annotations

from appium.webdriver.webdriver import WebDriver
from selenium.common.exceptions import TimeoutException

from pages.explore_page import ExplorePage
from pages.home_page import HomePage
from pages.login_page import LoginPage
from pages.profile_page import ProfilePage


class AppSession:
    def __init__(self, driver: WebDriver) -> None:
        self.driver = driver
        self.login = LoginPage(driver)
        self.home = HomePage(driver)
        self.explore = ExplorePage(driver)
        self.profile = ProfilePage(driver)

    def login_as_guest(self) -> None:
        try:
            self.login.wait_for_login_screen()
            self.login.continue_as_guest()
        except TimeoutException:
            if not self.home.is_present_by_semantics_id("home_welcome_card"):
                raise
        self.login.wait_for_home_screen()
