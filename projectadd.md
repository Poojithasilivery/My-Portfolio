# Commit 15: Save Projects Permanently

## Overview
This commit adds local persistence for projects in the Flutter Portfolio application.

## Features
- Save project details locally.
- Load saved projects when the application starts.
- Keep project search functionality.
- Support adding, editing, and deleting projects.
- Preserve existing portfolio features.

## Technology Used
- Flutter
- Dart
- SharedPreferences
- JSON

## Testing
1. Add a new project.
2. Refresh the browser.
3. Confirm that the project is still displayed.
4. Edit the project and refresh again.
5. Delete the project and verify the change.

## Storage Note
Projects are saved locally in the browser/device and are not synchronized with an online database.

## Commit Message
`Save projects permanently`
