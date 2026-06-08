"""
Journey specifications — single source of truth for automated E2E tests.

Keep in sync with:
- documentation/journeys/*.md
- documentation/USER_JOURNEYS.md
- maestro/journeys/*.yaml
"""

from __future__ import annotations

from dataclasses import dataclass
from typing import Tuple


@dataclass(frozen=True)
class JourneyMeta:
    spec_id: str
    doc_path: str
    maestro_flow: str
    test_class: str
    test_method: str
    summary: str


GUEST_ONBOARDING = JourneyMeta(
    spec_id="guest_onboarding",
    doc_path="documentation/journeys/01-guest-onboarding.md",
    maestro_flow="maestro/journeys/01-guest-onboarding.yaml",
    test_class="TestGuestOnboardingJourney",
    test_method="test_guest_user_sees_home_dashboard",
    summary="Guest login and home dashboard verification",
)

HOME_FEATURES_TOUR = JourneyMeta(
    spec_id="home_features_tour",
    doc_path="documentation/journeys/02-home-features-tour.md",
    maestro_flow="maestro/journeys/02-home-features-tour.yaml",
    test_class="TestHomeFeaturesJourney",
    test_method="test_guest_browses_all_home_features",
    summary="Open each home feature card and return",
)

BOTTOM_TABS = JourneyMeta(
    spec_id="bottom_tabs",
    doc_path="documentation/journeys/03-bottom-tabs.md",
    maestro_flow="maestro/journeys/03-bottom-tabs.yaml",
    test_class="TestBottomTabsJourney",
    test_method="test_guest_navigates_bottom_tabs_round_trip",
    summary="Navigate Home → Explore → Profile → Home",
)

EXPLORE_DISCOVERY = JourneyMeta(
    spec_id="explore_discovery",
    doc_path="documentation/journeys/04-explore-discovery.md",
    maestro_flow="maestro/journeys/04-explore-discovery.yaml",
    test_class="TestExploreDiscoveryJourney",
    test_method="test_guest_explores_trending_and_detail_screens",
    summary="Explore trending cards and settings",
)

PROFILE_SETTINGS = JourneyMeta(
    spec_id="profile_settings",
    doc_path="documentation/journeys/05-profile-settings.md",
    maestro_flow="maestro/journeys/05-profile-settings.yaml",
    test_class="TestProfileAndSettingsJourney",
    test_method="test_guest_reviews_profile_and_settings",
    summary="Settings from home and profile",
)

ALL_JOURNEYS: Tuple[JourneyMeta, ...] = (
    GUEST_ONBOARDING,
    HOME_FEATURES_TOUR,
    BOTTOM_TABS,
    EXPLORE_DISCOVERY,
    PROFILE_SETTINGS,
)

# Journey 1 — verification targets (doc: 01-guest-onboarding.md)
GUEST_ONBOARDING_WELCOME_SUBTITLE = "Ready to explore? Check out the features below"
GUEST_ONBOARDING_FEATURE_SEMANTICS_IDS: Tuple[str, ...] = (
    "home_feature_api_integration",
    "home_feature_search_filter",
    "home_feature_state_management",
    "home_feature_auto_route_navigation",
)

# Journey 2 — feature opener method → expected screen text (doc: 02-home-features-tour.md)
HOME_FEATURE_DESTINATIONS: Tuple[Tuple[str, str], ...] = (
    ("open_api_integration", "Repositories"),
    ("open_search_and_filter", "Search Users"),
    ("open_state_management", "increase counter"),
    ("open_auto_route_navigation", "NavigationChild1Route"),
)

# Journey 4 — trending opener method → expected screen text (doc: 04-explore-discovery.md)
EXPLORE_TRENDING_DESTINATIONS: Tuple[Tuple[str, str], ...] = (
    ("open_popular_repositories", "Repositories"),
    ("open_active_users", "Search Users"),
    ("open_featured_projects", "Featured"),
)

SETTINGS_APPEARANCE_TEXT = "Appearance"

# Journey 3 & 5 — profile labels (doc: 03-bottom-tabs.md, 05-profile-settings.md)
PROFILE_ACCOUNT_HEADER = "Account"
PROFILE_EDIT_PROFILE = "Edit Profile"
PROFILE_LOGOUT = "Logout"
