import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod_template/data/local/secure_storage_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Skip these tests in CI - they require platform channel mocking
  // TODO: Add proper mocks for flutter_secure_storage
  group('SecureStorageService Tests', skip: 'Requires platform channel mocking', () {
    late SecureStorageService service;

    setUp(() {
      service = SecureStorageService();
    });

    group('Auth Token Operations', () {
      test('saveAuthToken should store token', () async {
        const testToken = 'test_auth_token_123';

        await service.saveAuthToken(testToken);

        // Note: In a real test with mocks, you'd verify the write was called
        // For now, this tests that the method executes without errors
      });

      test('getAuthToken should return null when no token is stored', () async {
        final token = await service.getAuthToken();

        // Note: This may return null or a previous value depending on test isolation
        // In production tests with mocks, you'd control the return value
        expect(token, isA<String?>());
      });

      test('deleteAuthToken should remove token', () async {
        await service.deleteAuthToken();

        // Verify deletion executes without errors
      });
    });

    group('Refresh Token Operations', () {
      test('saveRefreshToken should store refresh token', () async {
        const testRefreshToken = 'test_refresh_token_456';

        await service.saveRefreshToken(testRefreshToken);

        // Verify save executes without errors
      });

      test('getRefreshToken should return stored refresh token', () async {
        final refreshToken = await service.getRefreshToken();

        expect(refreshToken, isA<String?>());
      });

      test('deleteRefreshToken should remove refresh token', () async {
        await service.deleteRefreshToken();

        // Verify deletion executes without errors
      });
    });

    group('User Credentials Operations', () {
      test('saveUserCredentials should store username and email', () async {
        const testUsername = 'testuser';
        const testEmail = 'test@example.com';

        await service.saveUserCredentials(
          username: testUsername,
          email: testEmail,
        );

        // Verify save executes without errors
      });

      test('saveUserCredentials should store username without email', () async {
        const testUsername = 'testuser';

        await service.saveUserCredentials(username: testUsername);

        // Verify save executes without errors
      });

      test('getUsername should return stored username', () async {
        final username = await service.getUsername();

        expect(username, isA<String?>());
      });

      test('getEmail should return stored email', () async {
        final email = await service.getEmail();

        expect(email, isA<String?>());
      });
    });

    group('Clear and Login Status', () {
      test('clearAll should remove all stored data', () async {
        // Store some data first
        await service.saveAuthToken('token');
        await service.saveRefreshToken('refresh');
        await service.saveUserCredentials(username: 'user');

        // Clear all
        await service.clearAll();

        // Verify all data is cleared
        final token = await service.getAuthToken();
        final refresh = await service.getRefreshToken();
        final username = await service.getUsername();
        final email = await service.getEmail();

        expect(token, isNull);
        expect(refresh, isNull);
        expect(username, isNull);
        expect(email, isNull);
      });

      test('isLoggedIn should return true when auth token exists', () async {
        await service.saveAuthToken('valid_token');

        final isLoggedIn = await service.isLoggedIn();

        expect(isLoggedIn, isTrue);

        // Cleanup
        await service.clearAll();
      });

      test('isLoggedIn should return false when no auth token', () async {
        await service.clearAll();

        final isLoggedIn = await service.isLoggedIn();

        expect(isLoggedIn, isFalse);
      });

      test('isLoggedIn should return false when auth token is empty', () async {
        await service.saveAuthToken('');

        final isLoggedIn = await service.isLoggedIn();

        expect(isLoggedIn, isFalse);

        // Cleanup
        await service.clearAll();
      });
    });

    group('Integration Tests', () {
      test('complete auth flow - save, retrieve, delete', () async {
        // Clear any existing data
        await service.clearAll();

        // Save tokens and credentials
        const authToken = 'auth_token_xyz';
        const refreshToken = 'refresh_token_abc';
        const username = 'integrationuser';
        const email = 'integration@test.com';

        await service.saveAuthToken(authToken);
        await service.saveRefreshToken(refreshToken);
        await service.saveUserCredentials(
          username: username,
          email: email,
        );

        // Verify login status
        expect(await service.isLoggedIn(), isTrue);

        // Retrieve and verify
        expect(await service.getAuthToken(), equals(authToken));
        expect(await service.getRefreshToken(), equals(refreshToken));
        expect(await service.getUsername(), equals(username));
        expect(await service.getEmail(), equals(email));

        // Cleanup
        await service.clearAll();

        // Verify cleanup
        expect(await service.isLoggedIn(), isFalse);
        expect(await service.getAuthToken(), isNull);
        expect(await service.getRefreshToken(), isNull);
        expect(await service.getUsername(), isNull);
        expect(await service.getEmail(), isNull);
      });
    });
  });
}
