// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:f_todo_app_database/domain/entities/todo.dart';
import 'package:f_todo_app_database/ui/controllers/todo_controller.dart';
import 'package:f_todo_app_database/ui/pages/home_page.dart';
import 'package:f_todo_app_database/ui/widget/new_todo_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

class MockTodoController extends GetxService
    with Mock
    implements TodoController {
  @override
  void removeAll() async {
    todoList.clear();
  }

  @override
  Future<void> addItem(item) async {
    todoList.add(item);
  }
}

void main() {
  testWidgets('NewTodoDialog Test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: NewTodoDialog()));

    // Verify that the initial state is correct
    expect(find.text('New todo'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.byKey(const Key('todoTypeDropdown')), findsOneWidget);
    expect(find.byKey(const Key('addButtonTodoDialog')), findsOneWidget);

    // Enter text in the title and body text fields
    await tester.enterText(find.byType(TextField).first, 'Test Title');
    await tester.enterText(find.byType(TextField).last, 'Test Body');

    // Tap the Add button
    await tester.tap(find.byKey(const Key('addButtonTodoDialog')));
    await tester.pumpAndSettle();

    // Verify that the dialog is dismissed and the todo is returned
    expect(find.text('New todo'), findsNothing);
  });

  testWidgets('HomePage Test', (WidgetTester tester) async {
    // Create a mock instance of the TodoController
    final mockTodoController = MockTodoController();

    // Inject the mock instance into the Get dependency management system
    Get.put<TodoController>(mockTodoController);

    // Build the HomePage widget
    await tester.pumpWidget(MaterialApp(home: HomePage()));

    // Verify that the initial state is correct
    expect(find.text('Todo App'), findsOneWidget);
    expect(find.byKey(const Key('deleteAllButton')), findsOneWidget);
    expect(find.byKey(const Key('floatingActionButton')), findsOneWidget);

    // Simulate tapping the delete all button
    await tester.tap(find.byKey(const Key('deleteAllButton')));
    await tester.pumpAndSettle();
    expect(find.byType(Dismissible), findsNothing);

    // Simulate adding a todo through the dialog
    mockTodoController.addItem(Todo(
      id: 0,
      title: 'Test Todo',
      body: 'Test Body',
      completed: 0,
      type: TodoType.DEFAULT,
    ));
    await tester.pumpAndSettle();
    expect(find.byType(Dismissible), findsOneWidget);

    // Simulate adding a todo through the dialog
    mockTodoController.addItem(Todo(
      id: 1,
      title: 'Test Todo',
      body: 'Test Body',
      completed: 0,
      type: TodoType.DEFAULT,
    ));
    await tester.pumpAndSettle();
    expect(find.byType(Dismissible), findsNWidgets(2));

    // Simulate tapping the delete all button
    await tester.tap(find.byKey(const Key('deleteAllButton')));
    await tester.pumpAndSettle();
    expect(find.byType(Dismissible), findsNothing);

    // Simulate adding a todo through the dialog
    mockTodoController.addItem(Todo(
      id: 0,
      title: 'Test Todo',
      body: 'Test Body',
      completed: 0,
      type: TodoType.DEFAULT,
    ));
    await tester.pumpAndSettle();
    expect(find.byType(Dismissible), findsOneWidget);

    // Simulate adding a todo through the dialog
    mockTodoController.addItem(Todo(
      id: 1,
      title: 'Test Todo',
      body: 'Test Body',
      completed: 0,
      type: TodoType.DEFAULT,
    ));
    await tester.pumpAndSettle();
    expect(find.byType(Dismissible), findsNWidgets(2));

    await tester.drag(find.byKey(const Key('todo0')), const Offset(500.0, 0.0));

    await tester.pumpAndSettle();
    expect(find.byType(Dismissible), findsOneWidget);
  });
}
