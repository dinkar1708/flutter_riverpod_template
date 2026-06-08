"""Shared helpers for Appium page objects."""

from __future__ import annotations

import os
from typing import Tuple

from appium.webdriver.common.appiumby import AppiumBy
from appium.webdriver.webdriver import WebDriver
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait


class BasePage:
    def __init__(self, driver: WebDriver) -> None:
        self.driver = driver
        self.timeout = int(os.getenv("APPIUM_EXPLICIT_WAIT", "15"))

    @property
    def platform(self) -> str:
        return os.getenv("APPIUM_PLATFORM", "android").lower()

    def wait_for(self, locator: Tuple[str, str]):
        return WebDriverWait(self.driver, self.timeout).until(
            EC.presence_of_element_located(locator)
        )

    def wait_until_visible(self, locator: Tuple[str, str]):
        return WebDriverWait(self.driver, self.timeout).until(
            EC.visibility_of_element_located(locator)
        )

    def wait_until_clickable(self, locator: Tuple[str, str]):
        return WebDriverWait(self.driver, self.timeout).until(
            EC.element_to_be_clickable(locator)
        )

    def semantics_locator(self, semantics_id: str) -> Tuple[str, str]:
        """Flutter Semantics.identifier maps to resource-id on Android."""
        if self.platform == "ios":
            return (AppiumBy.ACCESSIBILITY_ID, semantics_id)
        selector = f'new UiSelector().resourceId("{semantics_id}")'
        return (AppiumBy.ANDROID_UIAUTOMATOR, selector)

    def label_locator(self, label: str) -> Tuple[str, str]:
        return (AppiumBy.ACCESSIBILITY_ID, label)

    def tab_locator(self, tab_name: str) -> Tuple[str, str]:
        if self.platform == "ios":
            return (AppiumBy.ACCESSIBILITY_ID, tab_name)
        tab_markers = {
            "Home": "Tab 1 of 3",
            "Explore": "Tab 2 of 3",
            "Profile": "Tab 3 of 3",
        }
        marker = tab_markers.get(tab_name, tab_name)
        selector = f'new UiSelector().descriptionContains("{marker}")'
        return (AppiumBy.ANDROID_UIAUTOMATOR, selector)

    def find_by_text(self, text: str):
        if self.platform == "ios":
            predicate = f'label CONTAINS "{text}" OR name CONTAINS "{text}"'
            return self.driver.find_element(AppiumBy.IOS_PREDICATE, predicate)

        for selector in (
            f'new UiSelector().descriptionContains("{text}")',
            f'new UiSelector().textContains("{text}")',
        ):
            try:
                return self.driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, selector)
            except Exception:
                continue
        raise Exception(f'Could not find element containing text "{text}"')

    def tap_by_semantics_id(self, semantics_id: str) -> None:
        self.wait_until_visible(self.semantics_locator(semantics_id)).click()

    def scroll_to_label(self, label: str) -> None:
        if self.platform == "ios":
            return
        selector = (
            f'new UiScrollable(new UiSelector().scrollable(true))'
            f'.scrollIntoView(new UiSelector().descriptionContains("{label}"))'
        )
        self.driver.find_element(AppiumBy.ANDROID_UIAUTOMATOR, selector)

    def tap_by_label(self, label: str) -> None:
        self.scroll_to_label(label)
        if self.platform == "ios":
            self.wait_until_clickable(self.label_locator(label)).click()
            return
        selector = f'new UiSelector().descriptionContains("{label}")'
        self.wait_until_clickable((AppiumBy.ANDROID_UIAUTOMATOR, selector)).click()

    def tap_by_tab(self, tab_name: str) -> None:
        self.wait_until_clickable(self.tab_locator(tab_name)).click()

    def is_present_by_semantics_id(self, semantics_id: str) -> bool:
        try:
            self.driver.find_element(*self.semantics_locator(semantics_id))
            return True
        except Exception:
            return False

    def is_displayed_by_semantics_id(self, semantics_id: str) -> bool:
        try:
            self.wait_until_visible(self.semantics_locator(semantics_id))
            return True
        except Exception:
            return False

    def is_displayed_by_text(self, text: str) -> bool:
        try:
            self.find_by_text(text)
            return True
        except Exception:
            return False

    def wait_until_text_visible(self, text: str):
        if self.platform == "ios":
            return self.wait_until_visible(self.label_locator(text))
        selector = f'new UiSelector().descriptionContains("{text}")'
        return self.wait_until_visible((AppiumBy.ANDROID_UIAUTOMATOR, selector))

    def go_back(self) -> None:
        self.driver.back()

    def go_back_to_home(self, home: "HomePage", max_attempts: int = 5) -> None:
        for _ in range(max_attempts):
            if home.is_present_by_semantics_id("home_welcome_card"):
                home.wait_for_screen()
                return
            self.go_back()
        home.wait_for_screen()
