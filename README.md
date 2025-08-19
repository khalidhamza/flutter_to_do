# Todo App

A simple Flutter Todo application using BLoC for state management.

## Features

- Home layout for managing todos
- BLoC pattern for state management
- Custom BLoC observer for debugging

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Dart SDK](https://dart.dev/get-dart)
- Compatible IDE (e.g., Android Studio, VS Code)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/khalidhamza/flutter_to_do.get
cd flutter_to_do
```
2. Install dependencies:
```bash
flutter pub get
```
3. Run the app:
```bash
flutter run
```

## Project Structure

- `lib/main.dart`: App entry point, sets up BLoC observer and root widget.
- `lib/layout/home_layout.dart`: Main layout for the todo app.
- `lib/shared/cubit/bloc_observer.dart`: Custom BLoC observer for logging state changes.

## Dependencies

- [flutter](https://pub.dev/packages/flutter)
- [bloc](https://pub.dev/packages/bloc)

## License

This project is licensed under the MIT License.
