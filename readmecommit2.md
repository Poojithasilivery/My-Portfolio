# Commit 02: Responsive Portfolio Design

## 1. Objective
To make the Flutter portfolio application adjust its layout according to different screen sizes.

## 2. Concepts Used
- `LayoutBuilder`
- `SingleChildScrollView`
- `Row` and `Column`
- `Expanded`
- `ConstrainedBox`
- Reusable custom widgets
- Responsive layout design

## 3. Implementation
- Used `LayoutBuilder` to check the available screen width.
- Displayed the profile and introduction side by side on wider screens.
- Arranged the sections vertically on narrower screens.
- Used `ConstrainedBox` to limit the content width.
- Created reusable `ProfileSection` and `IntroductionSection` widgets.
- Added a `Wrap` widget to display skill chips.

## 4. Output
The portfolio adjusts its layout when the browser window is resized.

## 5. Testing
- Tested the application in Chrome.
- Resized the browser to check the desktop and mobile layouts.
- Verified that the content could be scrolled when necessary.

## 6. Learning Outcome
Learned how to implement responsive layouts using Flutter and create reusable widgets.

## 7. Screenshots
Add your screenshots to the `screenshots` folder.

### Source Code
![Responsive Flutter Code](screenshots/commit02_code.png)

### Application Output
![Responsive Portfolio Output](screenshots/commit02_output.png)
