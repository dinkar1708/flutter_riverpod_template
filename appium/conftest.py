"""Pytest fixtures for Appium E2E tests."""

from __future__ import annotations

import os
import time
from typing import Generator

import pytest
from appium import webdriver
from appium.options.android import UiAutomator2Options
from appium.options.ios import XCUITestOptions
from appium.webdriver.webdriver import WebDriver
from selenium.common.exceptions import TimeoutException

from pages.home_page import HomePage
from pages.login_page import LoginPage


def _build_android_driver() -> WebDriver:
    options = UiAutomator2Options()
    options.platform_name = "Android"
    options.automation_name = "UiAutomator2"
    options.device_name = os.getenv("APPIUM_DEVICE_NAME", "Android Emulator")
    options.app_package = os.getenv(
        "APPIUM_APP_PACKAGE",
        "com.example.flutter_rivperpod_template.dev",
    )
    options.app_activity = os.getenv(
        "APPIUM_APP_ACTIVITY",
        "com.example.flutter_rivperpod_template.MainActivity",
    )
    options.no_reset = os.getenv("APPIUM_NO_RESET", "true").lower() == "true"
    options.auto_grant_permissions = True

    app_path = os.getenv("APPIUM_APP_PATH")
    if app_path:
        options.app = app_path

    server_url = os.getenv("APPIUM_SERVER_URL", "http://127.0.0.1:4723")
    return webdriver.Remote(server_url, options=options)


def _build_ios_driver() -> WebDriver:
    options = XCUITestOptions()
    options.platform_name = "iOS"
    options.automation_name = "XCUITest"
    options.device_name = os.getenv("APPIUM_DEVICE_NAME", "iPhone 16")
    options.platform_version = os.getenv("APPIUM_PLATFORM_VERSION", "18.0")
    options.bundle_id = os.getenv(
        "APPIUM_BUNDLE_ID",
        "dev.dinakar.flutter.rivperpod.template",
    )
    options.no_reset = os.getenv("APPIUM_NO_RESET", "true").lower() == "true"

    app_path = os.getenv("APPIUM_APP_PATH")
    if app_path:
        options.app = app_path

    server_url = os.getenv("APPIUM_SERVER_URL", "http://127.0.0.1:4723")
    return webdriver.Remote(server_url, options=options)


def _restart_app(driver: WebDriver) -> None:
    app_id = os.getenv(
        "APPIUM_APP_PACKAGE",
        "com.example.flutter_rivperpod_template.dev",
    )
    if os.getenv("APPIUM_PLATFORM", "android").lower() == "ios":
        app_id = os.getenv(
            "APPIUM_BUNDLE_ID",
            "dev.dinakar.flutter.rivperpod.template",
        )
    driver.terminate_app(app_id)
    driver.activate_app(app_id)
    time.sleep(2)


@pytest.fixture(scope="function")
def driver() -> Generator[WebDriver, None, None]:
    platform = os.getenv("APPIUM_PLATFORM", "android").lower()
    if platform == "ios":
        session = _build_ios_driver()
    else:
        session = _build_android_driver()

    session.implicitly_wait(int(os.getenv("APPIUM_IMPLICIT_WAIT", "5")))
    yield session
    session.quit()


@pytest.fixture(scope="function")
def home_screen(driver: WebDriver):
    """Launch app, skip splash, and land on the Home tab."""
    _restart_app(driver)

    login_page = LoginPage(driver)
    home_page = HomePage(driver)

    try:
        login_page.wait_for_login_screen()
        login_page.continue_as_guest()
    except TimeoutException:
        if not home_page.is_present_by_semantics_id("home_welcome_card"):
            raise

    login_page.wait_for_home_screen()
    return driver
