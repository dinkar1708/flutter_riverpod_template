# Network Error Handling

## Purpose

Network calls can fail due to no internet, timeouts, server errors, or invalid responses. Proper error handling prevents app crashes and shows users meaningful feedback.

**DevTools to verify:** Network tab → See failed requests with error details

---

## When does this happen?

- No internet connection
- Server is down (500, 502, 503 errors)
- Timeout (slow connection)
- Invalid JSON response
- 4xx client errors (401, 404, etc.)

**Symptom:** App crashes, shows "Null check error", or hangs forever on loading.

---

## The Problem

```dart
// WRONG - No error handling, app crashes
Future<void> fetchData() async {
  final response = await http.get(url);
  final data = jsonDecode(response.body);  // Crashes if network fails!
  setState(() => items = data);
}
```

**What happens:**
- Network fails (no internet, timeout, etc.)
- Exception thrown but not caught
- App crashes or shows error screen
- User has no idea what went wrong

---

## The Solution

**Use try-catch with specific error handling:**

```dart
// RIGHT - Handles all network errors gracefully
Future<void> fetchData() async {
  try {
    final response = await http.get(url).timeout(Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Server error: ${response.statusCode}');
    }

    final data = jsonDecode(response.body);
    if (!mounted) return;
    setState(() => items = data);
  } on TimeoutException {
    _showError('Request timed out. Check your connection.');
  } on SocketException {
    _showError('No internet connection.');
  } catch (e) {
    _showError('Failed to load data: $e');
  }
}
```

---

## How to Verify in DevTools

**Network Tab:**

1. Open DevTools Network tab
2. Trigger network request
3. See request appear in list
4. Check status code, response time, error details

**BAD example (no error handling):**
- Request fails
- App crashes or freezes
- No error shown in Network tab (app crashed before logging)

**GOOD example (with error handling):**
- Request fails
- Error appears in Network tab with details
- App shows user-friendly error message
- User can retry

---

## Common Error Types

1. **SocketException** - No internet connection
2. **TimeoutException** - Request took too long
3. **HttpException** - HTTP-level error (4xx, 5xx)
4. **FormatException** - Invalid JSON response

---

## Rule

**Always wrap network calls in try-catch with timeout**

---

## Checklist

- [ ] Used try-catch around network calls?
- [ ] Added timeout to prevent hanging?
- [ ] Handled specific exceptions (SocketException, TimeoutException)?
- [ ] Checked mounted before setState after async?
- [ ] Showed user-friendly error messages?
- [ ] Verified in DevTools Network tab?

---

## Code Example

**Live example:** `lib/samples/intermediate/network/network_error_example.dart`

**Test it:**
1. Open "Network Error Handling" from samples
2. Try BAD example - app crashes on network error
3. Try GOOD example - shows friendly error message
4. Check DevTools Network tab to see request details

---

## Console Logs

**BAD example (no error handling - crashes):**

Success scenario:
```
🔴 [WRONG] Fetching data WITHOUT error handling...
🔴 [WRONG] Got data: {"status": "success", "data": "Hello World"}
💀 [WRONG] If network failed, app would have crashed here!
```

Error scenarios (no internet, server error, etc.):
```
🔴 [WRONG] Fetching data WITHOUT error handling...
💀 [WRONG] Simulating no internet - app will crash!
💀 [WRONG] APP CRASHED! Error: SocketException: No internet connection
💀 [WRONG] In real code without try-catch, user sees crash screen!
```

**GOOD example (with error handling):**

Success scenario:
```
✅ [GOOD] Fetching data WITH proper error handling...
✅ [GOOD] Got data successfully: {"status": "success"...}
```

Error scenarios (handled gracefully):
```
✅ [GOOD] Fetching data WITH proper error handling...
✅ [GOOD] Simulating no internet - will be caught!
✅ [GOOD] Caught SocketException: SocketException: No internet connection
✅ [GOOD] Showing user-friendly error: No internet connection. Please check your network.
```
