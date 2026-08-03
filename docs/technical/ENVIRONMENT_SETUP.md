# Environment Setup


## Quick Start

```bash
# Clone and run
git clone <your-repo>
cd flutter_riverpod_template
cp .env.example .env.dev
cp .env.example .env.prod
flutter pub get && dart run build_runner build && flutter run -t lib/main/main_dev.dart
```

## Prerequisites

- Flutter SDK 3.44.1+
- Dart 3.8.0+
- iOS 12+ or Android API 21+

## Environment Variables

This project uses **envied** for secure, obfuscated environment variables.

###Why envied?

**Security Comparison:**
- ❌ flutter_dotenv: .env file in assets, easily extracted from APK
- ✅ envied: Obfuscated at compile time, cannot be extracted

### Setup

**envied uses separate .env files for each environment:**

1. Create environment files:
```bash
cp .env.example .env.dev
cp .env.example .env.prod
```

2. Edit `.env.dev` for development:
```bash
API_BASE_URL=https://api.github.com/
API_KEY=your_dev_api_key
ENVIRONMENT=dev
```

3. Edit `.env.prod` for production:
```bash
API_BASE_URL=https://api.github.com/
API_KEY=your_prod_api_key
ENVIRONMENT=prod
```

4. Generate code:
```bash
dart run build_runner build
```

This generates obfuscated code for **both** environments.

### After Changing .env Files

**IMPORTANT:** build_runner doesn't auto-detect .env file changes. Full clean required:

```bash
flutter clean && flutter pub get && dart run build_runner build
```

**What this does:**
- `flutter clean` - Removes all build artifacts
- `flutter pub get` - Reinstalls dependencies
- `dart run build_runner build` - Regenerates all generated files

**Quick clean (faster, only cleans build_runner cache):**
```bash
dart run build_runner clean && dart run build_runner build
```

## Running the App

**Development:**
```bash
flutter run -t lib/main/main_dev.dart
```

**Production:**
```bash
flutter run -t lib/main/main_prod.dart
```

**Mock (hardcoded data):**
```bash
flutter run -t lib/main/main_mock_development.dart
```

## Building for Release

**Development APK:**
```bash
flutter build apk --release --flavor dev -t lib/main/main_dev.dart
```

**Production APK:**
```bash
flutter build apk --release --flavor prod -t lib/main/main_prod.dart
```

**Production App Bundle (for Play Store):**
```bash
flutter build appbundle --release --flavor prod -t lib/main/main_prod.dart
```

**iOS (Development):**
```bash
flutter build ios --release --flavor dev -t lib/main/main_dev.dart
```

**iOS (Production):**
```bash
flutter build ios --release --flavor prod -t lib/main/main_prod.dart
```

For detailed build instructions, see:
- [Android Dev APK Guide](../build/android/dev_apk_export.md)
- [Android Prod APK Guide](../build/android/prod_apk_export.md)
- [Android Keystore Setup](../build/android/keystore_setup_guide.md)
- [iOS Build Guide](../build/ios/ios_build_guide.md)

## Code Generation

```bash
# Generate once
dart run build_runner build

# Watch for changes
dart run build_runner watch

# Clean and rebuild
flutter clean && dart run build_runner build
```

## Using Environment Variables

```dart
import 'package:flutter_riverpod_template/core/config/env.dart';

// Development environment
final devUrl = EnvDev.apiBaseUrl;
final devKey = EnvDev.apiKey;

// Production environment
final prodUrl = EnvProd.apiBaseUrl;
final prodKey = EnvProd.apiKey;

// Or use in main files:
// main_dev.dart uses EnvDev
// main_prod.dart uses EnvProd
```

## Troubleshooting

**Variables not loading:**
1. Ensure `.env` exists
2. Run `dart run build_runner build`
3. Check `lib/core/config/env.g.dart` was generated
4. Restart app (hot restart may not work)

**Build fails:**
```bash
flutter clean
rm -rf .dart_tool
flutter pub get
dart run build_runner build
```

## Security Best Practices

1. **Never commit `.env` files**
   - Already in `.gitignore`
   - Only commit `.env.example`

2. **Use different keys per environment**
   - Dev: Personal access token
   - Prod: Organization token

3. **Rotate keys regularly**
   - Update `.env`
   - Run `flutter clean && dart run build_runner build`
   - Rebuild app

4. **Always use obfuscation for production**
   - `--obfuscate --split-debug-info=outputs/symbols/`

## References

- [envied package](https://pub.dev/packages/envied)
- [Security Guide](SECURITY.md)
- [Architecture Guide](ARCHITECTURE.md)
