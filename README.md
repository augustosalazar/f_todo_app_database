# f_todo_app_database

A simple TODO application with Hive and Sqflite local storage support.

## Features

- Create todos
- Mark todos as completed or incomplete
- Delete individual todos
- Delete all todos
- Local persistence with:
  - Hive
  - Sqflite

## Testing

This project includes:

- Widget tests
- Integration tests

## Run tests

### Widget test

```bash
flutter test
```

### Integration test (for web)

```bash
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/app_test.dart -d chrome
```

### Integration test (for mobile)

```bash
flutter test integration_test/app_test.dart
```

### Demo

<p align="center">
  <img src="https://github.com/user-attachments/assets/4a397431-a45b-4d43-b6ed-a5f9f9b1bc50" alt="pruebaTodoApp" width="350"/>
</p>
