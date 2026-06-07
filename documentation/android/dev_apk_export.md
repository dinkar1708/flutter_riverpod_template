# Development APK Build Guide

**Instructions for creating development release APKs for testing purposes.**

---

## Build Process

### 1. Initial Keystore Configuration

**First-time setup required:**
Complete the keystore configuration by following [Keystore Setup Guide](./keystore_setup_guide.md#required-setup-for-release-builds)

Skip this if already configured.

### 2. Execute Build Command
```bash
flutter build apk --release --flavor dev -t lib/main/main_dev.dart
```

### 3. Locate Output File
```
build/app/outputs/flutter-apk/app-dev-release.apk
```

### 4. Install on Device
```bash
adb install build/app/outputs/flutter-apk/app-dev-release.apk
```

---

## Build Characteristics
- Requires initial keystore configuration
- Connects to development environment
- Build duration: approximately 2-3 minutes
- File size: roughly 80MB
- Recommended use: Internal quality assurance

---

## Troubleshooting Google Authentication

**Experiencing Google Sign-In failures?**
Refer to [Firebase SHA Configuration](./keystore_setup_guide.md#firebase-sha-configuration-google-sign-in)

---

## Debug Build Alternative

For quick testing without keystore requirements:
```bash
flutter build apk --debug --flavor dev -t lib/main/main_dev.dart
```

Output location: `build/app/outputs/flutter-apk/app-dev-debug.apk`

---

**See also:** [Prod APK Export](./prod_apk_export.md) | [Keystore Setup](./keystore_setup_guide.md)
