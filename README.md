# Mini Course Player

A small Flutter app for browsing courses and watching lessons with resume-where-you-left-off playback. Built with Clean Architecture + MVVM (Cubit as ViewModel).

## Tech stack

- State management: flutter_bloc (Cubit)
- Functional error handling: dartz (Either<Failure, T>)
- Persistence: shared_preferences
- Video playback: video_player
- Connectivity check: connectivity_plus
- Testing: flutter_test

## Getting started

Prerequisites: Flutter SDK (stable channel) 3.x or newer, a connected device/simulator/emulator, and an internet connection.

### Run it

flutter pub get
flutter run

### Run the tests

flutter test

This runs the unit tests in test/unit/progress_calculator_test.dart and the widget test in test/widget/course_card_test.dart.

## Project structure

lib/core - Failures, Exceptions, UseCase base, NetworkInfo
lib/features/courses/data - Models, DataSources, Repository implementation
lib/features/courses/domain - Entities, Repository contract, UseCases, ProgressCalculator
lib/features/courses/presentation - Cubits and Screens/Widgets
lib/injection_container.dart - Manual dependency injection
lib/main.dart - App entry point
assets/json/courses.json - Mock course data

## Notes

Course data is mock data loaded locally rather than from a real backend, per the assessment requirements. See RATIONALE.md for design decisions and AI_DISCLOSURE.md for AI tool usage.
