# Intermediate Level: Navigation & App Lifecycle Guide

This guide covers declarative type-safe navigation using **AutoRoute** and managing application lifecycle states.

---

## Table of Contents

1. [Declarative Navigation (AutoRoute)](#1-declarative-navigation-autoroute)
2. [Nested Routing & Bottom Tabs (`AutoTabsRouter`)](#2-nested-routing--bottom-tabs-autotabsrouter)
3. [App Lifecycle Management (`AppLifecycleListener`)](#3-app-lifecycle-management-applifecyclelistener)
4. [Deep Linking & Route Guards](#4-deep-linking--route-guards)

---

## 1. Declarative Navigation (AutoRoute)

### Q1: Why choose AutoRoute over Navigator 1.0 named routes?
**Answer:**
- **Strongly Typed Route Arguments**: Passing parameters (e.g., `ProfileRoute(userId: 123)`) is compile-time verified, preventing runtime casting crashes.
- **Code Generation**: Automatically generates router mappings and routes.
- **Nested Routing**: Declarative handling of sub-routes and multi-tab state preservation.

---

## 2. Nested Routing & Bottom Tabs (`AutoTabsRouter`)

### Q2: How does `AutoTabsRouter` manage bottom navigation state?
**Answer:**
`AutoTabsRouter` maintains separate navigation stacks for each tab, preserving scroll position and state when switching between tabs.

```dart
@RoutePage()
class HomeWithTabsPage extends StatelessWidget {
  const HomeWithTabsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [
        HomeRoute(),
        ExploreRoute(),
        ProfileRoute(),
      ],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          body: child,
          bottomNavigationBar: NavigationBar(
            selectedIndex: tabsRouter.activeIndex,
            onDestinationSelected: tabsRouter.setActiveIndex,
            destinations: const [
              NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
              NavigationDestination(icon: Icon(Icons.explore), label: 'Explore'),
              NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
            ],
          ),
        );
      },
    );
  }
}
```

---

## 3. App Lifecycle Management (`AppLifecycleListener`)

### Q3: Explain the 5 `AppLifecycleState` phases and how to listen to them.
**Answer:**
- **`resumed`**: App visible and receiving user interaction.
- **`inactive`**: App visible but interrupted (phone call, system permission prompt).
- **`hidden`**: App minimized or covered.
- **`paused`**: App backgrounded; frame drawing stopped.
- **`detached`**: Flutter engine shutting down.

```dart
late final AppLifecycleListener _lifecycleListener;

@override
void initState() {
  super.initState();
  _lifecycleListener = AppLifecycleListener(
    onResume: () => debugPrint('App returned to foreground - refresh sync'),
    onPause: () => debugPrint('App backgrounded - pause heavy tasks'),
  );
}

@override
void dispose() {
  _lifecycleListener.dispose();
  super.dispose();
}
```

---

## 4. Deep Linking & Route Guards

### Q4: How do Route Guards protect authenticated routes?
**Answer:**
In AutoRoute, an `AutoRouteGuard` checks authentication before resolving navigation:

```dart
class AuthGuard extends AutoRouteGuard {
  final Ref ref;
  AuthGuard(this.ref);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final isAuthenticated = ref.read(userSessionNotifierProvider).value?.isAuthenticated ?? false;
    if (isAuthenticated || resolver.route.name == LoginRoute.name) {
      resolver.next(true); // Allow
    } else {
      router.push(LoginRoute(onSuccess: () => resolver.next(true)));
    }
  }
}
```
