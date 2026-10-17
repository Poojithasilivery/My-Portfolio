# Commit 03: Reusable Portfolio Project Cards

## 1. Objective
To improve the portfolio home screen by adding reusable cards to display project information.

## 2. Technologies Used
- Flutter
- Dart
- Visual Studio Code
- Git and GitHub

## 3. Implementation
- Created a profile card to display profile information.
- Added a My Projects section to the home screen.
- Created three project cards with different titles and descriptions.
- Used icons to represent different projects.
- Applied padding, margins, and elevation to improve the user interface.
- Created a reusable `ProjectCard` widget.

## 4. Widgets Used

- **Card:** Displays information inside a card-shaped layout.
- **ListTile:** Arranges an icon, title, and description.
- **CircleAvatar:** Displays a circular icon.
- **Row:** Arranges widgets horizontally.
- **Column:** Arranges widgets vertically.
- **Padding:** Adds space around widgets.
- **SizedBox:** Adds fixed spacing.
- **SingleChildScrollView:** Allows the screen content to scroll.

## 5. Custom Widget Explanation
The `ProjectCard` widget accepts three parameters:

- `title` – the project name.
- `description` – information about the project.
- `icon` – an icon representing the project.

The same widget can be reused for multiple projects by passing different values.

## 6. Expected Output
The portfolio displays a profile card followed by three project cards:
1. Portfolio Website
2. Student App
3. UI Design Project

## 7. Testing
- Ran the Flutter application in Chrome.
- Checked that all three project cards were displayed.
- Verified that the project titles and descriptions were visible.
- Checked the layout and scrolling behavior.

## 8. Learning Outcome
Learned how to create reusable custom widgets and display information using Flutter cards, icons, and list tiles.

## 9. Screenshots

### Source Code
![Reusable Project Card Code](screenshots/commit03_code.png)

### Application Output
![Portfolio Project Cards](screenshots/commit03_output.png)
