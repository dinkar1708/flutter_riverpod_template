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

from journey_specs import ALL_JOURNEYS
from pages.app_session import AppSession


def pytest_configure(config):
    config.addinivalue_line(
        "markers",
        "journey(spec_id): marks test as implementing a documented user journey",
    )


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
    options.set_capability("appium:uiautomator2ServerLaunchTimeout", 60000)

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
def app_session(driver: WebDriver) -> AppSession:
    """Fresh app launch with guest login — starting point for user journeys."""
    _restart_app(driver)
    session = AppSession(driver)
    session.login_as_guest()
    return session


def pytest_collection_modifyitems(items):
    """Attach journey doc paths to test node names for clearer reports."""
    journey_by_class = {meta.test_class: meta for meta in ALL_JOURNEYS}
    for item in items:
        journey_meta = journey_by_class.get(item.cls.__name__ if item.cls else "")
        if journey_meta:
            item.add_marker(pytest.mark.journey(journey_meta.spec_id))
            item.user_properties.append(("journey_doc", journey_meta.doc_path))
