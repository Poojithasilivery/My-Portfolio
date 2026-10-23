# Commit 7: Edit and Delete Projects

## Objective
Improve the existing Flutter portfolio by allowing users to edit and delete projects.

## Features Added
- Preserved the profile form and live profile preview.
- Preserved navigation and dynamic project addition.
- Added an Edit button to each project card.
- Added a Delete button to each project card.
- Reused the project form for adding and updating projects.
- Added Cancel functionality while editing.
- Updated the project count automatically.
- Added a message when a project is added, updated, or deleted.

## Concepts Used
- StatefulWidget and setState()
- Lists and custom Dart classes
- TextEditingController
- Form validation
- GridView and Card widgets
- CRUD operations: Create, Read, Update, Delete

## Screenshots

### Projects Screen
![Projects Screen](screenshots/commit07_projects.png)

### Editing a Project
![Editing a Project](screenshots/commit07_edit.png)

### Updated Project List
![Updated Projects](screenshots/commit07_updated.png)

## Result
Users can add, edit, and delete projects from the same portfolio application.

## Limitation
Project changes are held in memory and do not survive an application restart. Persistent storage will be introduced in a future commit.