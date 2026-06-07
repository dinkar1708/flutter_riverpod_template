# Android Keystore Configuration

**Initial configuration required for signing release builds.**

---

## Required Setup for Release Builds

### 1. Obtain Keystore Credentials

Contact your project administrator to receive:
- Keystore file (`.jks` format)
- Release key properties file or credentials
- Authentication details (alias, passwords)

### 2. Install Keystore File

Place the keystore file in your project's Android directory:

```bash
# Navigate from project root
cp /path/to/your-keystore.jks android/release-keystore.jks
```

Confirm installation:
```bash
ls -la android/release-keystore.jks
```

### 3. Configure Properties File

Copy the example properties file:
```bash
cd android
cp release_key_example.properties release_key.properties
```

### 4. Add Your Credentials

Open `android/release_key.properties` and configure:
```properties
storeFile=release-keystore.jks
keyAlias=<your-alias-here>
storePassword=<your-store-password>
keyPassword=<your-key-password>
```

---

## Creating a New Keystore

If you need to generate a fresh keystore:

```bash
keytool -genkey -v -keystore release-keystore.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias my-release-key
```

Provide the requested information:
- Store and key passwords
- Organization and contact information

Move the generated file to `android/` and configure `release_key.properties` accordingly.

---

## Firebase SHA Configuration (Google Sign-In)

**Only required if experiencing Google Sign-In authentication failures.**

Common symptoms:
- Authentication error code 12500
- Sign-in process fails silently
- Login button unresponsive

### Extract SHA Certificates

Using your keystore credentials:

```bash
keytool -list -v -keystore android/release-keystore.jks -alias <your-alias> -storepass <your-password>
```

Or let the system prompt for password:
```bash
keytool -list -v -keystore android/release-keystore.jks -alias <your-alias>
```

Expected output includes:
```
Certificate fingerprints:
         SHA1: XX:XX:XX:XX:...
         SHA256: XX:XX:XX:XX:...
```

Record both fingerprint values.

---

### Register Fingerprints in Firebase

For each application flavor:

1. Navigate to Firebase Console (https://console.firebase.google.com)
2. Select your project
3. Access Project Settings (gear icon)
4. Locate Your Apps section
5. Select the appropriate Android app
6. Add SHA1 fingerprint using "Add fingerprint"
7. Save changes
8. Add SHA256 fingerprint similarly
9. Save again
10. Download updated `google-services.json`
11. Place in correct location:
    - Development: `android/app/src/dev/google-services.json`
    - Production: `android/app/src/prod/google-services.json`

---

### Rebuild Applications

After updating Firebase configuration:

```bash
flutter clean
flutter pub get
flutter build apk --release --flavor dev -t lib/main/main_dev.dart
flutter build apk --release --flavor prod -t lib/main/main_prod.dart
```

---

**See also:** [Dev APK Export](./dev_apk_export.md) | [Prod APK Export](./prod_apk_export.md)
