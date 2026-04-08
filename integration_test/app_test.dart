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

Future<void> pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  Duration timeout = const Duration(seconds: 5),
  Duration step = const Duration(milliseconds: 100),
}) async {
  final end = DateTime.now().add(timeout);

  while (DateTime.now().isBefore(end)) {
    await tester.pump(step);
    if (finder.evaluate().isNotEmpty) {
      return;
    }
  }

  throw TestFailure('Widget not found within timeout: $finder');
}

void debugPrintAllTexts(WidgetTester tester) {
  final textWidgets = find.byType(Text).evaluate();

  for (final element in textWidgets) {
    final widget = element.widget as Text;
    debugPrint('TEXT FOUND: "${widget.data}"');
  }
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

  await tester.enterText(
    find.byKey(const Key('titleTextFieldTodoDialog')),
    'Test Title',
  );
  await tester.enterText(
    find.byKey(const Key('bodyTextFieldTodoDialog')),
    'Test Body',
  );
  await tester.pumpAndSettle();

  await tester.tap(find.byKey(const Key('addButtonTodoDialog')));
  await tester.pumpAndSettle();

  expect(find.text('New todo'), findsNothing);
  expect(find.byKey(const Key('todoTitle_Test Title')), findsOneWidget);
  expect(find.byKey(const Key('todoBody_Test Title')), findsOneWidget);

  await tester.tap(find.byKey(const Key('floatingActionButton')));
  await tester.pumpAndSettle();

  expect(find.text('New todo'), findsOneWidget);

  await tester.enterText(
    find.byKey(const Key('titleTextFieldTodoDialog')),
    'Test Title 2',
  );
  await tester.enterText(
    find.byKey(const Key('bodyTextFieldTodoDialog')),
    'Test Body 2',
  );
  await tester.pumpAndSettle();

  await tester.tap(find.byKey(const Key('addButtonTodoDialog')));
  await tester.pumpAndSettle();

  expect(find.text('New todo'), findsNothing);
  expect(find.byType(Dismissible), findsNWidgets(2));
  expect(find.byKey(const Key('todoTitle_Test Title 2')), findsOneWidget);
  expect(find.byKey(const Key('todoBody_Test Title 2')), findsOneWidget);

  // ----- EDITION / UPDATE: toggle completed state -----

  // Initial state: both incomplete
  expect(find.byIcon(Icons.radio_button_unchecked_rounded), findsNWidgets(2));
  expect(find.byIcon(Icons.check_circle_rounded), findsNothing);

  final titleBefore =
      tester.widget<Text>(find.byKey(const Key('todoTitle_Test Title')));
  final bodyBefore =
      tester.widget<Text>(find.byKey(const Key('todoBody_Test Title')));

  expect(titleBefore.style?.decoration, isNot(TextDecoration.lineThrough));
  expect(bodyBefore.style?.decoration, isNot(TextDecoration.lineThrough));

  // Toggle first todo to completed
  await tester.tap(find.byKey(const Key('todoTap_Test Title')));
  await tester.pumpAndSettle();

  expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
  expect(find.byIcon(Icons.radio_button_unchecked_rounded), findsOneWidget);

  final titleAfterComplete =
      tester.widget<Text>(find.byKey(const Key('todoTitle_Test Title')));
  final bodyAfterComplete =
      tester.widget<Text>(find.byKey(const Key('todoBody_Test Title')));

  expect(titleAfterComplete.style?.decoration, TextDecoration.lineThrough);
  expect(bodyAfterComplete.style?.decoration, TextDecoration.lineThrough);

  // Toggle back to incomplete
  await tester.tap(find.byKey(const Key('todoTap_Test Title')));
  await tester.pumpAndSettle();

  expect(find.byIcon(Icons.check_circle_rounded), findsNothing);
  expect(find.byIcon(Icons.radio_button_unchecked_rounded), findsNWidgets(2));

  final titleAfterUndo =
      tester.widget<Text>(find.byKey(const Key('todoTitle_Test Title')));
  final bodyAfterUndo =
      tester.widget<Text>(find.byKey(const Key('todoBody_Test Title')));

  expect(titleAfterUndo.style?.decoration, isNot(TextDecoration.lineThrough));
  expect(bodyAfterUndo.style?.decoration, isNot(TextDecoration.lineThrough));

  // Delete all
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
