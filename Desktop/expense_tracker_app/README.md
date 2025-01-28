# Expenzy - Personal Expense Tracker

Expenzy is a Personal Expense Tracker mobile application developed using Flutter. It helps users manage their finances by tracking and categorizing their expenses. The app follows Clean Architecture principles to ensure scalability, maintainability, and testability.

## Features

- **Expense Summary**: View a summary of all expenses.
- **Filter by Date Range**: Filter expenses based on the selected date range.
- **List of Expenses**: Display a list of recorded expenses.
- **State Management**: Uses efficient state management techniques for smooth user experience.
- **Local Notifications**: Notifications for upcoming or overdue expenses.
- **Unit Testing**: Ensures reliable functionality with unit tests.
  
## Project Structure

The project is structured based on Clean Architecture principles, divided into the following directories:

- **core**: Common utilities, themes, constants, and configuration files.
- **data**: Data layer that includes repositories, data sources, and models.
- **domain**: Domain layer with business logic, entities, and use cases.
- **presentation**: Presentation layer that includes screens, widgets, and UI components.
- **test**: Test files for provider and use cases.

## Technologies Used

- **Flutter**: Cross-platform mobile framework for building the app.
- **Dart**: Programming language for Flutter development.
- **Provider**: State management solution.
- **SQLite**: Local storage solution for persisting expense data.
  
## Setup Instructions

### Prerequisites

- Flutter SDK: Install the Flutter SDK from [flutter.dev](https://flutter.dev/docs/get-started/install).
- Dart SDK: Dart is bundled with Flutter, so there's no need to install it separately.
  
### Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/Amjadshaneeb/Expenzy.git
   cd Expenzy


Install dependencies:

    flutter pub get

Run the app on an emulator or physical device:
     
     flutter run


Testing

    flutter test


       
