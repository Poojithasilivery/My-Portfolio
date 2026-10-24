# Commit 14: Save Contact Messages Permanently

## Overview
This commit adds permanent local storage for contact form messages in the Flutter Portfolio application.

## Features Added
- **Save Messages:** Contact form messages are saved using `SharedPreferences`.
- **Load Messages:** Previously saved messages appear when the application is reopened or refreshed.
- **Delete Messages:** Users can delete saved messages from Message History.
- **JSON Conversion:** Contact messages are converted to and from JSON for storage.

## Technologies Used
- Flutter
- Dart
- SharedPreferences
- JSON

## How to Run
1. Install the required dependency:
   ```bash
   flutter pub add shared_preferences
   ```
2. Get the dependencies:
   ```bash
   flutter pub get
   ```
3. Run the application:
   ```bash
   flutter run -d chrome
   ```

## Testing
1. Open the Contact page.
2. Submit a message.
3. Open Message History and verify the message appears.
4. Refresh the browser.
5. Check that the message is still available.
6. Delete the message and verify it is removed.

## Note
Messages are stored locally in the browser/device. They are not synchronized with an online database.

## Commit Message
`Save contact messages permanently`
