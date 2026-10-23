# Commit 8: Delete Confirmation Dialog

## Objective
Improve project deletion by asking users for confirmation before removing a project.

## Features Added
- Preserved the profile editing form and live preview.
- Preserved adding, editing, and deleting projects.
- Added a confirmation dialog before deletion.
- Added Cancel and Delete options.
- Updated the project count after confirmed deletion.
- Displayed a success message after deletion.

## Concepts Used
- AlertDialog
- showDialog()
- async and await
- setState()
- User confirmation

## Screenshots

### Delete Confirmation
![Delete Confirmation](screenshots/commit08_confirmation.png)

### Project List After Deletion
![Updated Project List](screenshots/commit08_deleted.png)

## Result
Users can cancel or confirm a project deletion, helping prevent accidental removal.

## Limitation
Project changes remain in memory and reset when the app restarts. Persistent storage will be added later.