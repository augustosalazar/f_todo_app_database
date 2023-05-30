// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:f_todo_app_database/ui/widget/new_todo_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

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
}
