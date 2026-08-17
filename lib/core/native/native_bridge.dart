import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Service bridge to communicate securely with iOS / Android native layers.
class NativeBridge {
  static const MethodChannel _channel =
      MethodChannel('com.example.app/native_config');

  /// Pass Google Maps API Key securely to native iOS GMSServices, or log on Android
  static Future<void> initializeGoogleMaps(String apiKey) async {
    if (apiKey.trim().isEmpty) {
      if (kDebugMode) {
        debugPrint('⚠️ [NativeBridge] Google Maps API key is empty or not provided.');
      }
      return;
    }

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      try {
        final result = await _channel.invokeMethod('initGoogleMaps', {'apiKey': apiKey});
        if (kDebugMode) {
          debugPrint('🗺️ [NativeBridge] Google Maps API key passed to iOS native layer: $apiKey (For debug and testing only)');
          debugPrint('   • Native Response: $result');
        }
      } on PlatformException catch (e) {
        // Detailed error reporting from iOS native layer
        debugPrint('❌ [NativeBridge] Native Error from iOS:');
        debugPrint('   • Error Code:    ${e.code}');
        debugPrint('   • Error Message: ${e.message}');
        if (e.details != null) {
          debugPrint('   • Details:       ${e.details}');
        }
      } catch (e, st) {
        debugPrint('❌ [NativeBridge] Unexpected error initializing Google Maps on iOS: $e');
        if (kDebugMode) {
          debugPrint('   • StackTrace: $st');
        }
      }
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      if (kDebugMode) {
        debugPrint('🗺️ [NativeBridge] Google Maps API key configured for Android: $apiKey (For debug and testing only)');
      }
    }
  }
}
