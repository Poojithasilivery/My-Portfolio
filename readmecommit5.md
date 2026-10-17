# Commit 05: Reactive Personal Details Form with Validation

## 1. Objective
To create an interactive personal details form that allows users to enter and update their portfolio information with input validation.

## 2. Technologies Used
- Flutter
- Dart
- Visual Studio Code
- Git and GitHub

## 3. Implementation
- Created input fields for name, email, course, skills, and personal introduction.
- Used TextEditingController to access the entered information.
- Used Form and GlobalKey to manage form validation.
- Added validation to check required fields and email format.
- Added a Save Details button to update the portfolio preview.
- Used setState() to refresh the UI when the details are saved.
- Displayed the entered skills as individual chips.
- Added a success message after saving valid details.

## 4. Widgets and Concepts Used

- **StatefulWidget:** Allows the screen to maintain and update state.
- **TextFormField:** Accepts user input and supports validation.
- **TextEditingController:** Reads and manages text field values.
- **Form:** Groups the input fields for validation.
- **GlobalKey:** Provides access to the form state.
- **ElevatedButton / FilledButton:** Provides an action to save details.
- **setState():** Rebuilds the UI after the data changes.
- **Chip:** Displays individual skills.
- **SnackBar:** Displays a confirmation message.
- **SingleChildScrollView:** Allows the screen to scroll.

## 5. Reactive UI Explanation
When the user enters valid details and presses Save Details, the application validates the form and updates its state using `setState()`.

Flutter rebuilds the relevant UI, and the portfolio preview displays the updated name, email, course, introduction, and skills without restarting the application.

## 6. Validation
- Name cannot be empty.
- Email must follow a valid email format.
- Course cannot be empty.
- At least one skill must be entered.
- The form does not update when validation fails.

## 7. Expected Output
The application displays a portfolio preview and an editable form. After valid information is submitted, the preview updates immediately.

## 8. Testing
- Tested the form with empty fields.
- Tested an invalid email address.
- Entered valid personal details.
- Verified that the preview updated after saving.
- Edited the details and checked that the preview reflected the changes.

## 9. Learning Outcome
Learned how to create forms, validate user input, manage text controllers, and implement reactive UI updates using `setState()`.

## 10. Screenshots

### Personal Details Form Code
![Form Code](screenshots/commit05_code.png)

### Form and Portfolio Preview
![Form Output](screenshots/commit05_output.png)

### Updated Portfolio Details
![Updated Details](screenshots/commit05_updated.png)

## 11. Limitation
The entered details are stored in the current application state only. They are not permanently saved after the application restarts. Persistent storage can be implemented in a later commit.
