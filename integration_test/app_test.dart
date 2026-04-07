import 'package:f_todo_app_database/data/datasources/local/i_todo_local_datasource.dart';
import 'package:f_todo_app_database/data/datasources/local/todo_local_datasource_hive.dart';
import 'package:f_todo_app_database/data/datasources/local/todo_local_datasource_sqflite.dart';
import 'package:f_todo_app_database/data/repositories/todo_repository.dart';
import 'package:f_todo_app_database/domain/entities/todo_hive.dart';
import 'package:f_todo_app_database/domain/repositories/i_todo_repository.dart';
import 'package:f_todo_app_database/ui/controllers/todo_controller.dart';
import 'package:f_todo_app_database/ui/todoapp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:integration_test/integration_test.dart';
import 'package:path_provider/path_provider.dart';

Future<void> _openHiveBox() async {
  final dir = await getApplicationDocumentsDirectory();

  Hive.init(dir.path);

  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(TodoHiveAdapter());
  }

  final box = await Hive.openBox<TodoHive>('todos');
  await box.clear();
}

Future<void> _closeHive() async {
  if (Hive.isBoxOpen('todos')) {
    await Hive.box<TodoHive>('todos').close();
  }
  await Hive.close();
}

Future<Widget> createHomeScreenHive() async {
  WidgetsFlutterBinding.ensureInitialized();

  await _openHiveBox();

  Get.testMode = true;
  Get.reset();

  Get.put<ITodoLocalDataSource>(TodoLocalDataSourceHive());
  Get.put<ITodoRepository>(TodoRepository(Get.find()));
  Get.put(TodoController(Get.find()));

  return const TodoApp(
    key: Key('TodoApp'),
  );
}

Future<Widget> createHomeScreenSqflite() async {
  WidgetsFlutterBinding.ensureInitialized();

  Get.testMode = true;
  Get.reset();

  Get.put<ITodoLocalDataSource>(TodoLocalDataSourceSqflite());
  Get.put<ITodoRepository>(TodoRepository(Get.find()));
  Get.put(TodoController(Get.find()));

  return const TodoApp(
    key: Key('TodoApp'),
  );
}

Future<void> runCommonTodoFlow(WidgetTester tester) async {
  expect(find.text('Todo App'), findsOneWidget);
  expect(find.byKey(const Key('deleteAllButton')), findsOneWidget);
  expect(find.byKey(const Key('floatingActionButton')), findsOneWidget);

  await tester.tap(find.byKey(const Key('deleteAllButton')));
  await tester.pumpAndSettle();
  expect(find.byType(Dismissible), findsNothing);

  await tester.tap(find.byKey(const Key('floatingActionButton')));
  await tester.pumpAndSettle();

  expect(find.text('New todo'), findsOneWidget);

  await tester.enterText(find.byType(TextField).first, 'Test Title');
  await tester.enterText(find.byType(TextField).last, 'Test Body');
  await tester.pumpAndSettle();

  await tester.tap(find.byKey(const Key('addButtonTodoDialog')));
  await tester.pumpAndSettle();

  expect(find.text('New todo'), findsNothing);

  await tester.tap(find.byKey(const Key('floatingActionButton')));
  await tester.pumpAndSettle();

  expect(find.text('New todo'), findsOneWidget);

  await tester.enterText(find.byType(TextField).first, 'Test Title 2');
  await tester.enterText(find.byType(TextField).last, 'Test Body 2');
  await tester.pumpAndSettle();

  await tester.tap(find.byKey(const Key('addButtonTodoDialog')));
  await tester.pumpAndSettle();

  expect(find.text('New todo'), findsNothing);
  expect(find.byType(Dismissible), findsNWidgets(2));

  await tester.tap(find.byKey(const Key('deleteAllButton')));
  await tester.pumpAndSettle();

  expect(find.byType(Dismissible), findsNothing);
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  tearDown(() async {
    Get.reset();
    await _closeHive();
  });

  testWidgets('Hive integration test', (WidgetTester tester) async {
    final widget = await createHomeScreenHive();
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    await runCommonTodoFlow(tester);
  });

  testWidgets('Sqflite integration test', (WidgetTester tester) async {
    final widget = await createHomeScreenSqflite();
    await tester.pumpWidget(widget);
    await tester.pumpAndSettle();

    await runCommonTodoFlow(tester);
  });
}
