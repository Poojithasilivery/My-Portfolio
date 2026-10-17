# Commit 04: Navigation Between Screens

## 1. Objective
To implement navigation between different screens in a Flutter portfolio application.

## 2. Technologies Used
- Flutter
- Dart
- Visual Studio Code
- Git and GitHub

## 3. Implementation
- Created a Portfolio Home Screen.
- Created a separate Projects Screen.
- Added a View My Projects button to the home screen.
- Used Navigator to navigate from the home screen to the Projects screen.
- Used MaterialPageRoute to define the destination screen.
- Added project cards to display project information.
- Added a back arrow to return to the previous screen.

## 4. Widgets and Concepts Used

- **MaterialApp:** Provides the basic application structure.
- **Scaffold:** Defines the layout of each screen.
- **AppBar:** Displays the title and navigation controls.
- **Navigator.push():** Opens a new screen.
- **MaterialPageRoute:** Defines the screen to open.
- **FilledButton:** Creates the navigation button.
- **ListView:** Displays project cards in a scrollable list.
- **Card:** Presents project information in a card layout.
- **ListTile:** Organizes icons, titles, and descriptions.

## 5. Navigation Explanation
When the user clicks the View My Projects button, `Navigator.push()` opens the Projects screen using `MaterialPageRoute`.

The AppBar on the Projects screen provides a back arrow. Pressing it returns the user to the portfolio home screen.

## 6. Expected Output
The application displays a home screen with profile information, skills, and a View My Projects button. Clicking the button opens another screen containing three project cards.

## 7. Testing
- Ran the application in Chrome.
- Clicked the View My Projects button.
- Verified that the Projects screen opened.
- Tested returning to the home screen using the back arrow.

## 8. Learning Outcome
Learned how to navigate between screens using Navigator and MaterialPageRoute in Flutter.

## 9. Screenshots

### Home Screen
![Portfolio Home Screen](screenshots/commit04_home.png)

### Projects Screen
![Projects Screen](screenshots/commit04_projects.png)

### Navigation Code
![Navigation Code](screenshots/commit04_code.png)
