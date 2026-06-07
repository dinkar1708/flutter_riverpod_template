# Production APK Build Guide

**Instructions for creating production-ready APKs for distribution.**

---

## Standard Build Process

### 1. Initial Keystore Configuration

**First-time setup required:**
Complete the keystore configuration by following [Keystore Setup Guide](./keystore_setup_guide.md#required-setup-for-release-builds)

Skip this if already configured.

### 2. Execute Build Command
```bash
flutter build apk --release --flavor prod -t lib/main/main_prod.dart
```

### 3. Locate Output File
```
build/app/outputs/flutter-apk/app-prod-release.apk
```

### 4. Install on Device
```bash
adb install build/app/outputs/flutter-apk/app-prod-release.apk
```

---

## Build Characteristics
- Requires initial keystore configuration
- Connects to production environment
- Build duration: approximately 2-3 minutes
- File size: roughly 80MB
- Recommended use: Store distribution or direct sharing

---

## Production-Specific Configurations

### Version Management

Update application version before building in `pubspec.yaml`:
```yaml
version: 1.0.0+1  # Semantic versioning + build identifier
```

Components:
- **Display version**: `1.0.0` (shown to end users)
- **Build identifier**: `1` (increment with each release)

### Code Optimization (Optional)

Enable minification and resource shrinking in `android/app/build.gradle`:
```gradle
buildTypes {
    release {
        minifyEnabled true
        shrinkResources true
        proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'), 'proguard-rules.pro'
    }
}
```

### App Bundle Format

**Preferred for Play Store distribution:**
```bash
flutter build appbundle --release --flavor prod -t lib/main/main_prod.dart
```

Output location: `build/app/outputs/bundle/prodRelease/app-prod-release.aab`

**Benefits:**
- Reduced download sizes through dynamic delivery
- Mandatory for new Play Store submissions
- Optimized per-device configurations

### Architecture-Specific Builds

Generate individual APKs per CPU architecture:
```bash
flutter build apk --release --flavor prod -t lib/main/main_prod.dart --split-per-abi
```

Resulting files:
- `app-armeabi-v7a-prod-release.apk` (ARM 32-bit devices)
- `app-arm64-v8a-prod-release.apk` (ARM 64-bit devices)
- `app-x86_64-prod-release.apk` (Intel 64-bit devices)

### Release Verification Checklist

- [ ] Version number updated in `pubspec.yaml`
- [ ] Multi-device testing completed
- [ ] Google Sign-In functionality verified
- [ ] Production API endpoints confirmed
- [ ] Manifest permissions reviewed
- [ ] Deep linking tested
- [ ] Push notifications working
- [ ] Payment integration verified (if applicable)
- [ ] Crash reporting enabled

---

## Troubleshooting Google Authentication

**Experiencing Google Sign-In failures in production?**
Refer to [Firebase SHA Configuration](./keystore_setup_guide.md#firebase-sha-configuration-google-sign-in)

---

## Quick Reference Commands

```bash
# Standard production APK
flutter build apk --release --flavor prod -t lib/main/main_prod.dart

# App Bundle for Play Store
flutter build appbundle --release --flavor prod -t lib/main/main_prod.dart

# Architecture-specific APKs
flutter build apk --release --flavor prod -t lib/main/main_prod.dart --split-per-abi

# Debug build for testing
flutter build apk --debug --flavor prod -t lib/main/main_prod.dart
```

---

**See also:** [Dev APK Export](./dev_apk_export.md) | [Keystore Setup](./keystore_setup_guide.md)
