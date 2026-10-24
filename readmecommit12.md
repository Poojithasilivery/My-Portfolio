# Commit 12: Add Contact Form with Validation

## Objective
Added a contact form to the existing Flutter portfolio application.

## Features Added
- Name, email, and message fields
- Required-field validation
- Email format validation
- Minimum message length validation
- Success notification after valid submission
- Navigation from the home page and projects page
- Supports existing light and dark themes

## Existing Features Preserved
- Editable profile and live preview
- Responsive layout
- Project search
- Add, edit, and delete projects
- Delete confirmation
- Dark mode with saved theme preference

## Flutter Concepts Used
- StatefulWidget
- Form and GlobalKey
- TextFormField
- Form validation
- Navigator
- SnackBar
- SharedPreferences

## Screenshot
Save your screenshot as `screenshots/commit12_contact_form.png`.

![Contact Form](screenshots/commit12_contact_form.png)

## Result
Visitors can fill in and validate the contact form. This version displays a success message; it does not send messages to a server.
