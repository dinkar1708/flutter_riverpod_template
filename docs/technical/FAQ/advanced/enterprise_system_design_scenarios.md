# Advanced Level: Enterprise System Design & Scenario Challenges

This guide provides staff-level architectural solutions for complex real-world mobile engineering problems.

---

## Table of Contents

1. [Scenario 1: Offline-First Caching Architecture](#scenario-1-offline-first-caching-architecture)
2. [Scenario 2: High-Throughput Streaming & Isolate Batching](#scenario-2-high-throughput-streaming--isolate-batching)
3. [Scenario 3: Concurrency Control in Token Refresh (QueuedInterceptor)](#scenario-3-concurrency-control-in-token-refresh-queuedinterceptor)
4. [Scenario 4: Global Auth State & Route Guards](#scenario-4-global-auth-state--route-guards)

---

## Scenario 1: Offline-First Caching Architecture

### Challenge:
*"Architect a caching layer where the UI displays cached database records immediately on app launch, then fetches fresh data from the API in the background and updates the screen seamlessly."*

### Solution:
```dart
@riverpod
class OfflineFirstRepositoriesNotifier extends _$OfflineFirstRepositoriesNotifier {
  @override
  Stream<List<RepositoryListModel>> build(String username) async* {
    final localDb = ref.read(localDatabaseProvider);
    final api = ref.read(apiClientProvider);

    // 1. Emit cached local data immediately
    final cachedData = await localDb.getCachedRepositories(username);
    if (cachedData.isNotEmpty) {
      yield cachedData;
    }

    try {
      // 2. Fetch fresh network data in background
      final remoteData = await api.getRepositories(username, 30);
      // 3. Update local database cache
      await localDb.saveRepositories(username, remoteData);
      // 4. Emit updated network data
      yield remoteData;
    } catch (e) {
      if (cachedData.isEmpty) {
        throw Exception('No offline data available: $e');
      }
      // If we have cached data, silently keep showing cache
    }
  }
}
```

---

## Scenario 2: High-Throughput Streaming & Isolate Batching

### Challenge:
*"A real-time financial ticker stream delivers 500 JSON updates per second. The Flutter UI is stuttering and dropping frames. How do you resolve this?"*

### Solution:
1. **Move I/O and JSON parsing off the UI Isolate**: Spawn a persistent worker isolate (`Isolate.spawn`) that opens the WebSocket and parses the raw JSON into typed model instances.
2. **Batch & Throttle Port Messages**: Instead of sending 500 individual messages per second across the isolate port, buffer messages inside the isolate and emit a batched array (`List<TickerUpdate>`) every 100ms (10 updates/sec).
3. **Targeted UI Subscriptions**: On the presentation layer, use `ref.watch(tickerProvider.select((s) => s.currentPrice))` to rebuild only the price text widget without rebuilding the parent dashboard.

---

## Scenario 3: Concurrency Control in Token Refresh (QueuedInterceptor)

### Challenge:
*"When a user's JWT expires, 5 simultaneous API calls fail with HTTP 401 Unauthorized. How do you prevent 5 redundant refresh token calls and race condition crashes?"*

### Solution:
Use Dio's `QueuedInterceptor` which pauses outgoing requests when an error is being handled:

```dart
class AuthInterceptor extends QueuedInterceptor {
  final SecureStorageService storage;
  final Dio dio;
  AuthInterceptor({required this.storage, required this.dio});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshToken = await storage.getRefreshToken();
      if (refreshToken != null) {
        try {
          // QueuedInterceptor automatically locks the queue!
          final newToken = await _fetchNewAccessToken(refreshToken);
          await storage.saveAuthToken(newToken);

          // Retry the original request
          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer $newToken';
          final response = await dio.fetch(options);
          return handler.resolve(response);
        } catch (e) {
          await storage.clearAll();
          return handler.reject(err);
        }
      }
    }
    handler.next(err);
  }
}
```

---

## Scenario 4: Global Auth State & Route Guards

### Challenge:
*"How do you ensure unauthenticated users cannot access private screens even when navigating via deep links, while preserving their intended destination after login?"*

### Solution:
Implement an `AutoRouteGuard`:

```dart
class AuthGuard extends AutoRouteGuard {
  final Ref ref;
  AuthGuard(this.ref);

  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final isAuthenticated = ref.read(userSessionNotifierProvider).value?.isAuthenticated ?? false;

    if (isAuthenticated || resolver.route.name == LoginRoute.name) {
      resolver.next(true);
    } else {
      router.push(LoginRoute(
        onSuccess: () => resolver.next(true), // Resume navigation to original target
      ));
    }
  }
}
```
