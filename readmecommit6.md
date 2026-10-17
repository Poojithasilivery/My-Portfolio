# Commit 6: Dynamic Project Management

## Objective
Extend the existing Flutter portfolio application with a form that lets users add new projects dynamically.

## Features Added
- Preserved the profile editing form and live profile preview.
- Preserved navigation between the home screen and Projects screen.
- Added project title, description, and technology fields.
- Added form validation.
- Used `setState()` to update the project list immediately.
- Displayed the number of projects.
- Added responsive project-card layouts.

## Concepts Used
- StatefulWidget and setState()
- TextEditingController
- Form validation
- List of custom objects
- GridView and Card widgets
- Responsive layouts and navigation

## Screenshots

### Projects Screen
![Projects Screen](screenshots/commit06_projects.png)

### Newly Added Project
![New Project Added](screenshots/commit06_added.png)

## Result
Users can add projects and see them appear immediately in the existing portfolio.

## Limitation
Projects are stored in memory and reset when the app is restarted. Persistent storage will be added in a later commit.