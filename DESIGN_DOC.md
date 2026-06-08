# Feedback Flow - Design Document

## Overview
Feedback Flow is a robust Flutter application designed for device owners to securely collect, store, and export structured user feedback. The application fulfills all assignment requirements, including Google Sign-In, local SQLite persistence, BLoC architecture, biometric security, and scoped storage data exporting.

---

## 1. Design Choices

### Architecture & State Management
*   **BLoC Pattern:** I chose `flutter_bloc` to maintain a strict separation of concerns. The UI is completely decoupled from the data layer; UI components only dispatch `FeedbackEvent`s and listen to `FeedbackState`s.
*   **Dependency Injection:** Using the `get_it` package, the `DatabaseService` is registered as a lazy singleton. This ensures database connections are highly memory-efficient and easily mockable for testing.
*   **Service Layer Pattern:** Direct SQLite queries (`sqflite`) are abstracted behind a `DatabaseHelper` and a `DatabaseService`. The UI never interacts with the database directly.

### UI / UX
*   **Modern Aesthetics:** Taking inspiration from modern app trends (via mobbin.com), the app utilizes a deep dark theme, glassmorphic (`BackdropFilter`) cards, and ambient glowing orbs to create a premium feel.
*   **Multi-Step Form:** To reduce cognitive load, the feedback collection process is broken down into a 4-step wizard with an animated progress indicator.

### Security & Export
*   **Authentication:** Firebase Auth handles Google Sign-In to ensure only authenticated users can access the dashboard.
*   **Biometric Security:** The `local_auth` package is used to gate the CSV export function. Recognizing that some devices (like emulators) may not have biometrics or lock screens configured, I engineered a **custom 4-digit App PIN fallback** utilizing `shared_preferences`.
*   **Scoped Storage:** The CSV export dynamically resolves the device's public `Downloads` directory (handling Android's external storage paths) to ensure the file is easily accessible to the user, strictly meeting the assignment's scoped storage requirement.

---

## 2. Challenges Faced

*   **Native Platform Configurations for Biometrics:** Integrating `local_auth` required modifying Android-specific files (e.g., changing `MainActivity` to extend `FlutterFragmentActivity` and adding permissions). Testing this on emulators without lock screens caused initial exceptions, which led to the creation of the custom PIN fallback system.
*   **SQLite Schema Migrations:** Midway through development, a requirement to attach a profile picture was added. This meant updating the `FeedbackData` model and successfully writing an `onUpgrade` script in SQLite to alter the table and add the `profilePicturePath` column without dropping existing data.
*   **CSV Column Formatting:** The assignment required mapping over 10 distinct data points into exactly 5 specific columns (`Device Owner`, `User Details`, `Bug/Issue`, `User Device`, `Description and Media Links`). To accomplish this, I integrated `device_info_plus` to dynamically pull the hardware model and carefully concatenated the remaining data inside the `DatabaseService` before generating the CSV.
*   **Scoped Storage on Android:** Writing to the `Downloads` folder varies greatly between Android 9, 10, and 13+. Ensuring the app safely targets `/storage/emulated/0/Download` while maintaining a fallback to `getApplicationDocumentsDirectory` required careful platform checks.

---

## 3. Potential Improvements (Given More Time)

1.  **Cloud Synchronization:**
    Currently, feedback is stored entirely locally via SQLite. Given more time, I would implement bidirectional syncing with **Firebase Firestore** and upload the media attachments to **Firebase Cloud Storage**.
    
2.  **Persistent Media Copying:**
    Right now, the app saves the temporary cache path of images selected via `file_picker`. If the OS clears the cache, those images might break in the UI. A better approach would be to programmatically copy the selected files into the app's persistent document directory.

3.  **Comprehensive Testing:**
    While the foundation is solid, implementing full unit tests for the `FeedbackBloc` (using `bloc_test`) and integration tests for the multi-step UI flow would guarantee higher reliability.

4.  **In-App Media Preview:**
    I would add the ability to tap on an attached image thumbnail in Step 3 or Step 4 to open a full-screen interactive preview or video player.