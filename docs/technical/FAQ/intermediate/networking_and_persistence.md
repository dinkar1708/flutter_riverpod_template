# Intermediate Level: Networking & Persistence Guide

This guide details HTTP client architecture using **Dio + Retrofit**, interceptors, error translation, and local persistence strategies.

---

## Table of Contents

1. [Dio & Retrofit Architecture](#1-dio--retrofit-architecture)
2. [Interceptors Pipeline (Auth, Error, Logging)](#2-interceptors-pipeline-auth-error-logging)
3. [Error Translation (`ApiError` / `ApiErrorHandler`)](#3-error-translation-apierror--apierrorhandler)
4. [Persistence: `SecureStorage` vs `SharedPreferences` vs `Hive`/`Isar`](#4-persistence-securestorage-vs-sharedpreferences-vs-hiveisar)
5. [Freezed & JSON Serialization](#5-freezed--json-serialization)

---

## 1. Dio & Retrofit Architecture

### Q1: Why use Retrofit with Dio instead of raw `http`?
**Answer:**

**Production Example:** [lib/data/remote/api/client/api_client.dart](../../../../lib/data/remote/api/client/api_client.dart)

- **Retrofit**: Generates type-safe REST API client code using simple annotations (`@GET`, `@POST`, `@Path`, `@Query`), eliminating manual JSON parsing boilerplate and URL concatenation bugs.
- **Dio**: Provides advanced networking capabilities: interceptors, global timeouts, request cancellation tokens, form data uploads, and custom base options.

```dart
@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @GET('/users/{username}/repos')
  Future<List<RepositoryListModel>> getRepositories(
    @Path('username') String username,
    @Query('per_page') int pageSize,
  );
}
```

---

## 2. Interceptors Pipeline (Auth, Error, Logging)

### Q2: What are Dio Interceptors and how are they chained?
**Answer:**
Interceptors intercept outgoing requests and incoming responses/errors before reaching the application layer.

```
Request ──► [AuthInterceptor] ──► [LoggerInterceptor] ──► Network
                                                              │
Response/Error ◄── [ErrorInterceptor] ◄── [LoggerInterceptor] ◄
```

1. **`AuthInterceptor`**: Injects `Authorization: Bearer <token>` from `SecureStorageService`.
2. **`ErrorInterceptor`**: Catches HTTP/network errors and maps them to domain-level `ApiError` exceptions.
3. **`CustomLoggerInterceptor`**: Formats request/response logs in debug mode.

---

## 3. Error Translation (`ApiError` / `ApiErrorHandler`)

### Q3: Why should UI not handle raw `DioException` objects?
**Answer:**
Handling raw HTTP exceptions in the presentation layer couples the UI to the networking library and backend implementation. Normalizing them into typed `ApiError` domain models allows clean UI error presentations:

- `DioExceptionType.connectionTimeout` $\rightarrow$ `ApiError.noInternetConnection()`
- HTTP `401` $\rightarrow$ `ApiError.unauthorized()`
- HTTP `422` $\rightarrow$ `ApiError.badRequest(message)`
- HTTP `500` $\rightarrow$ `ApiError.serverError()`

---

## 4. Persistence: `SecureStorage` vs `SharedPreferences` vs `Hive`/`Isar`

### Q4: Compare persistent storage mechanisms in Flutter.
**Answer:**

| Technology | Storage Type | Security Level | Best Used For |
| :--- | :--- | :--- | :--- |
| **`flutter_secure_storage`** | Keychain (iOS) / Keystore AES (Android) | **High (Hardware Encrypted)** | JWT Tokens, refresh tokens, credentials, API keys |
| **`shared_preferences`** | Key-Value XML / Plist | **None (Plaintext)** | Theme mode, language preference, onboarding flags |
| **`Isar` / `Hive` / `Drift`** | Binary / Embedded SQLite | High performance (Optional AES) | Offline caching of feeds, large data tables, chat history |

---

## 5. Freezed & JSON Serialization

### Q5: What are the benefits of using `Freezed` models?
**Answer:**
- **Immutability**: Guarantees object state cannot be mutated accidentally.
- **`copyWith` method**: Clean, type-safe immutable object cloning.
- **Value Equality**: Compares objects by value (`==`) and hash code rather than memory reference.
- **Union / Sealed Types**: Built-in pattern matching (`when`, `map`).
