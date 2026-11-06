# my_portfolio

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

## Experiment 1(a):

Flutter SDK and Visual Studio Code were installed and configured to develop the application. A new Flutter project named my_portfoliop was created using the Flutter command. The Dart and Flutter extensions were added to VS Code for development. The project structure was created with main.dart as the entry point of the application. Finally, the application was successfully executed in Google Chrome. 

### Experiment 1(b): Dart Language Basics

Dart Language Basics is covered through your project code.
I used:
- Variables and data types – storing project and profile details.
- Classes and objects – PortfolioProject and ContactMessage.
- Functions – adding, editing and deleting projects.
- Lists – storing projects and contact messages.
- Conditional statements – project status and filtering.
 
Implemented basic Dart concepts such as variables, data types, classes, objects, functions, lists and conditional statements in the Flutter portfolio application. These concepts were used to manage project details, profile information and contact messages.

## Experiment 2(a): Basic Flutter Widgets

In this experiment, basic Flutter widgets were used to design the portfolio application's user interface.
1. Scaffold was used to provide the basic screen structure.
2. Text widgets were used to display headings, profile details and project information.
3. Container and Card widgets were used to organize and display content.
4. Buttons were used to perform actions such as adding projects and navigating between pages.
5. Icons were used to make the interface more attractive and user-friendly.
These widgets helped create the basic layout and design of the Flutter portfolio application.

![Home Page](images/Screenshot(65).png)

### Experiment 2(b): Layout Structures Using Row, Column and Stack

In this experiment, Row, Column and Stack widgets were used to arrange elements in the Flutter portfolio application. Row organizes widgets horizontally, while Column arranges them vertically. Stack allows widgets to overlap each other. These layout widgets help create a structured and user-friendly portfolio interface.

![Page1](images/Screenshot(1).png)
### Experiment 3(a): Responsive UI Design

In this experiment, responsive UI design was implemented in the Flutter portfolio application. The layout adjusts according to the screen size of the device. On smaller screens, content is arranged vertically, while on larger screens, it is displayed horizontally. This helps the application provide a consistent and user-friendly interface on different devices.

![Page4](images/Screenshot(2).png)
### Experiment 3(b): Media Queries and Breakpoints

In this experiment, MediaQuery and breakpoints were used in the Flutter portfolio application to adjust the layout based on screen size. The application detects the available screen width and changes the arrangement of widgets accordingly. This helps the portfolio display properly on mobile and desktop screens.
 ![Page3](images/Screenshot(3).png)
### Experiment 4(a): Basic Navigation Using Navigator

In this experiment, Navigator was used to navigate between different screens in the Flutter portfolio application. The `Navigator.push()` method is used to open a new page, while `Navigator.pop()` is used to return to the previous page. This allows users to move between the home page, projects page and contact page easily.

![Page3](images/Screenshot(4).png)

### Experiment 4(b): Navigation with Named Routes

Named routes provide a way to navigate between screens using route names. In Flutter, routes are defined in the MaterialApp widget and accessed using Navigator.pushNamed(). This makes screen navigation organized and easier to manage.

![Page3](images/Screenshot(5).png)

### Experiment 5(a): Stateful vs Stateless Widgets

In this experiment, StatefulWidget and StatelessWidget were used in the portfolio application. StatelessWidget displays fixed content, while StatefulWidget manages changing data. The setState() method updates the user interface when project details or other information changes.

![Page3](images/Screenshot(6).png)

### Experiment 5(b): State Management Using Provider

Provider is used to manage and share application state between different widgets. It helps maintain data without passing it manually through multiple widget levels. It makes state management easier in larger Flutter applications.

![Page3](images/Screenshot(7).png)

### Experiment 6(a): Creation of Custom Widgets

Custom widgets were created to make the portfolio application reusable and organized. Reusable components such as project cards and profile sections reduce code duplication. They help maintain a consistent user interface.

![Page3](images/Screenshot(8).png)

### Experiment 6(b): Styling Using Themes and Custom Styles

Themes and custom styles were used to improve the appearance of the portfolio application. Colors, text styles and widget designs were organized using Flutter's theme system. Light and dark modes help provide a better user experience.

![Page3](images/Screenshot(9).png)

### Experiment 7(a): Designing Forms with Various Input Fields

Forms were designed in the portfolio application to collect profile details and contact messages. TextFormField widgets were used to accept user inputs such as name, email and message. These forms allow users to enter and manage information.

![Page3](images/Screenshot(10).png)

### Experiment 7(b): Form Validation and Error Handling

Form validation was implemented to check user inputs before submission. Required fields and email formats are validated to prevent incorrect data. Error messages are displayed when invalid information is entered.

![Page3](images/Screenshot(11).png)

### Experiment 8(a): UI Animations Using Flutter Animation Framework

Flutter's animation framework is used to create smooth movements and visual effects in the user interface. AnimationController and Tween are used to control animation duration and values. Explicit animations improve the visual appearance of an application.

![Page3](images/Screenshot(12).png)


### Experiment 8(b): Implicit Animations

Implicit animations are used to create smooth UI transitions when widget properties change. Widgets such as AnimatedContainer and AnimatedOpacity automatically animate changes in size, color and opacity. These animations make the interface more interactive.

![Page3](images/Screenshot(13).png)


### Experiment 9(a): Fetching Data from REST API

REST API data can be fetched asynchronously using the HTTP package in Flutter. The http.get() method sends a request to a server and receives data in JSON format. This allows applications to access external information.

![Page3](images/Screenshot(14).png)

### Experiment 9(b): Displaying Fetched API Data in UI

Fetched API data is parsed and displayed in the Flutter user interface. ListView.builder is used to display multiple records dynamically. This helps present data in a structured and scrollable format.

![Page3](images/Screenshot(15).png)


### Experiment 10(a): Writing Unit and Widget Tests

Flutter testing is used to verify the functionality and correctness of application widgets. Widget tests check whether UI elements are displayed correctly. The flutter_test package is used to perform automated testing.

![Page3](images/Screenshot(16).png)

### Experiment 10(b): Flutter Debugging Tools

Flutter debugging tools are used to identify and fix errors in the application. Flutter DevTools and Flutter Inspector help examine widget layouts and diagnose rendering issues. These tools improve application reliability.

![Page3](images/Screenshot(17).png)
