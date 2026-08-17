import 'package:envied/envied.dart';

part 'env.g.dart';

/// Development environment configuration
///
/// Loaded from .env.dev file with obfuscated values
@Envied(path: '.env.dev', obfuscate: true, name: 'EnvDev')
abstract class EnvDev {
  @EnviedField(varName: 'API_BASE_URL', obfuscate: true)
  static final String apiBaseUrl = _EnvDev.apiBaseUrl;

  @EnviedField(varName: 'API_KEY', obfuscate: true)
  static final String apiKey = _EnvDev.apiKey;

  @EnviedField(varName: 'ENVIRONMENT', obfuscate: false)
  static final String environment = _EnvDev.environment;

  @EnviedField(varName: 'GOOGLE_MAPS_API_KEY', obfuscate: true)
  static final String googleMapsApiKey = _EnvDev.googleMapsApiKey;
}

/// Production environment configuration
///
/// Loaded from .env.prod file with obfuscated values
@Envied(path: '.env.prod', obfuscate: true, name: 'EnvProd')
abstract class EnvProd {
  @EnviedField(varName: 'API_BASE_URL', obfuscate: true)
  static final String apiBaseUrl = _EnvProd.apiBaseUrl;

  @EnviedField(varName: 'API_KEY', obfuscate: true)
  static final String apiKey = _EnvProd.apiKey;

  @EnviedField(varName: 'ENVIRONMENT', obfuscate: false)
  static final String environment = _EnvProd.environment;

  @EnviedField(varName: 'GOOGLE_MAPS_API_KEY', obfuscate: true)
  static final String googleMapsApiKey = _EnvProd.googleMapsApiKey;
}

/// Convenience class - use EnvDev or EnvProd directly
/// This is kept for backward compatibility
abstract class Env {
  static String get apiBaseUrl => EnvDev.apiBaseUrl;
  static String get apiKey => EnvDev.apiKey;
  static String get environment => EnvDev.environment;
  static String get googleMapsApiKey => EnvDev.googleMapsApiKey;
}

