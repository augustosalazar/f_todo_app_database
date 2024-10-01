import 'package:f_todo_app_database/domain/entities/todo_hive.dart';
import 'package:f_todo_app_database/domain/repositories/todo_repository.dart';
import 'package:f_todo_app_database/domain/use_case/todo_use_case.dart';
import 'package:f_todo_app_database/ui/controllers/todo_controller.dart';
import 'package:f_todo_app_database/ui/todoapp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:integration_test/integration_test.dart';
import 'package:loggy/loggy.dart';

Future<List<Box>> _openBox() async {
  List<Box> boxList = [];
  await Hive.initFlutter();
  Hive.registerAdapter(TodoHiveAdapter());
  boxList.add(await Hive.openBox("todos"));
  return boxList;
}

Future<Widget> createHomeScreen() async {
  WidgetsFlutterBinding.ensureInitialized();

  Loggy.initLoggy(
    logPrinter: const PrettyPrinter(
      showColors: true,
    ),
  );

  await _openBox();
  Get.put(TodoRepository());
  Get.put(TodoUseCase());
  Get.put(TodoController());
  return const TodoApp(
    key: Key('TodoApp'),
  );
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Complete test", (WidgetTester tester) async {
    Widget w = await createHomeScreen();
    await tester.pumpWidget(w);

    // Verify that the initial state is correct
    expect(find.text('Todo App'), findsOneWidget);
    expect(find.byKey(const Key('deleteAllButton')), findsOneWidget);
    expect(find.byKey(const Key('floatingActionButton')), findsOneWidget);

    // Simulate tapping the delete all button
    await tester.tap(find.byKey(const Key('deleteAllButton')));
    await tester.pumpAndSettle();
    expect(find.byType(Dismissible), findsNothing);

    await tester.tap(find.byKey(const Key('floatingActionButton')));
    await tester.pumpAndSettle();

    expect(find.text('New todo'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'Test Title');
    await tester.enterText(find.byType(TextField).last, 'Test Body');

    await tester.pumpAndSettle();

    // Tap the Add button
    await tester.tap(find.byKey(const Key('addButtonTodoDialog')));
    await tester.pumpAndSettle();

    expect(find.text('New todo'), findsNothing);

    await tester.tap(find.byKey(const Key('floatingActionButton')));
    await tester.pumpAndSettle();

    expect(find.text('New todo'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'Test Title 2');
    await tester.enterText(find.byType(TextField).last, 'Test Body 2');

    await tester.pumpAndSettle();

    // Tap the Add button
    await tester.tap(find.byKey(const Key('addButtonTodoDialog')));
    await tester.pumpAndSettle();

    expect(find.text('New todo'), findsNothing);

    // Should find two items on the list
    await tester.pumpAndSettle();
    expect(find.byType(Dismissible), findsNWidgets(2));

    // when testing sqflite the key should be todo1
    // when testing hive the key should be todo0
    // Delete the first item
    await tester.drag(find.byKey(const Key('todo0')), const Offset(500.0, 0.0));
    await tester.pumpAndSettle();

    // Should find one item on the list
    expect(find.byType(Dismissible), findsOneWidget);

    // Simulate tapping the delete all button
    await tester.tap(find.byKey(const Key('deleteAllButton')));
    await tester.pumpAndSettle();

    // Should find no items on the list
    expect(find.byType(Dismissible), findsNothing);
  });
}
