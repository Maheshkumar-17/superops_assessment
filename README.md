
# MKs AuthorLine (Maheshkumar's AuthorLine)

## SuperOps Assessment

A Flutter mobile app developed to display a list of authors and their details with user-friendly features such as pagination, search, delete, and favorite options.

## App APK Link

https://i.diawi.com/wentfS  

This link will expire after 24 hours. If it expires, please check your email or download the APK from the 'apk' folder located in the project root directory.

---

## Flutter & Dart Versions

- Flutter: 3.29.0 (Stable)  
- Dart: 3.7.0  
- Framework Revision: `35c388afb5` (2025-02-10)  
- Engine: `f73bfc4522`  
- DevTools: 2.42.2  
- Channel: [Stable](https://github.com/flutter/flutter.git)

---

## Steps to Run the App

1. Make sure Flutter is installed on your machine.
2. Open the project root folder in your terminal or command prompt.
3. Run the following commands:
   - flutter clean
   - flutter pub get
   - flutter pub run build_runner build  --delete-conflicting-outputs
4. Now the app is ready to run on your emulator or physical device.

---

## Features Added

1. Displays a list of authors and their details.
2. List view with pagination.
3. Delete and favourite actions.
4. Search functionality to find authors.
5. Tap on an author to view details on a separate screen.
6. Confirmation modal before deleting an author.

---

## Add-On Features

1. A BLoC to check network status every 5 seconds (configurable) and notify users using a `Snackbar`.
2. If the internet is off at launch:
   - A retry option is shown.
3. When the internet is turned on, data automatically loads (or can be manually retried).
4. Used `SharedPreferences` to persist:
   - Favourite author IDs  
   - Deleted author IDs  
   This ensures changes are retained even after restarting the app.

---

---

## Notes

- I have uploaded the Android app's screen     recordings and screenshots for all the above-mentioned features.You can find them in the project’s root folder under:
/screenshotsandrecordings
- As I don't have access to a macOS machine, I wasn't able to test the app on an iOS device or emulator.
- However, I have added the required iOS permission to allow HTTP URLs and also configured the app name and launcher icon.

```xml
<!-- Info.plist -->
<!-- To allow HTTP URL  -->
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <true/>
</dict>

