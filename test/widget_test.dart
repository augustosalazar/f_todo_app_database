import 'package:f_todo_app_database/domain/entities/todo.dart';
import 'package:f_todo_app_database/ui/controllers/todo_controller.dart';
import 'package:f_todo_app_database/ui/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

class MockTodoController extends GetxService
    with Mock
    implements TodoController {
  final RxList<Todo> _todoList = <Todo>[].obs;

  @override
  RxList<Todo> get todoList => _todoList;

  @override
  Future<void> removeAll() async {
    _todoList.clear();
  }

  @override
  Future<void> addItem(Todo item) async {
    _todoList.add(item);
  }

  @override
  Future<void> removeItem(item) async {
    _todoList.removeWhere((i) => i.id == item.id);
  }

  @override
  Future<void> setCompleted(Todo todo) async {
    final index = _todoList.indexWhere((i) => i.id == todo.id);
    if (index == -1) return;

    final current = _todoList[index];
    _todoList[index] = Todo(
      id: current.id,
      title: current.title,
      body: current.body,
      completed: current.completed == 1 ? 0 : 1,
      type: current.type,
    );
  }
}

void main() {
  setUp(() {
    Get.testMode = true;
    Get.reset();
    final mockTodoController = MockTodoController();
    Get.put<TodoController>(mockTodoController);
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('HomePage Test', (WidgetTester tester) async {
    await tester.pumpWidget(
      GetMaterialApp(home: HomePage()),
    );

    expect(find.byType(Dismissible), findsNothing);

    final mockTodoController = Get.find<TodoController>();

    // add one
    await mockTodoController.addItem(Todo(
      id: 0,
      title: 'Test',
      body: 'Body',
      completed: 0,
      type: TodoType.DEFAULT,
    ));
    await tester.pumpAndSettle();

    expect(find.byType(Dismissible), findsOneWidget);
    expect(find.byKey(const Key('todoTitle_Test')), findsOneWidget);
    expect(find.byKey(const Key('todoBody_Test')), findsOneWidget);

    // verify initial incomplete state
    expect(find.byIcon(Icons.radio_button_unchecked_rounded), findsOneWidget);
    expect(find.byIcon(Icons.check_circle_rounded), findsNothing);

    final titleBefore =
        tester.widget<Text>(find.byKey(const Key('todoTitle_Test')));
    final bodyBefore =
        tester.widget<Text>(find.byKey(const Key('todoBody_Test')));

    expect(titleBefore.style?.decoration, isNot(TextDecoration.lineThrough));
    expect(bodyBefore.style?.decoration, isNot(TextDecoration.lineThrough));

    // edit/update by toggling completed state
    await tester.tap(find.byKey(const Key('todoTap_Test')));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.check_circle_rounded), findsOneWidget);
    expect(find.byIcon(Icons.radio_button_unchecked_rounded), findsNothing);

    final titleAfterComplete =
        tester.widget<Text>(find.byKey(const Key('todoTitle_Test')));
    final bodyAfterComplete =
        tester.widget<Text>(find.byKey(const Key('todoBody_Test')));

    expect(titleAfterComplete.style?.decoration, TextDecoration.lineThrough);
    expect(bodyAfterComplete.style?.decoration, TextDecoration.lineThrough);

    // toggle back
    await tester.tap(find.byKey(const Key('todoTap_Test')));
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.radio_button_unchecked_rounded), findsOneWidget);
    expect(find.byIcon(Icons.check_circle_rounded), findsNothing);

    final titleAfterUndo =
        tester.widget<Text>(find.byKey(const Key('todoTitle_Test')));
    final bodyAfterUndo =
        tester.widget<Text>(find.byKey(const Key('todoBody_Test')));

    expect(titleAfterUndo.style?.decoration, isNot(TextDecoration.lineThrough));
    expect(bodyAfterUndo.style?.decoration, isNot(TextDecoration.lineThrough));

    // add another
    await mockTodoController.addItem(Todo(
      id: 1,
      title: 'Test2',
      body: 'Body2',
      completed: 0,
      type: TodoType.DEFAULT,
    ));
    await tester.pumpAndSettle();

    expect(find.byType(Dismissible), findsNWidgets(2));

    // delete all
    await tester.tap(find.byKey(const Key('deleteAllButton')));
    await tester.pumpAndSettle();
    expect(find.byType(Dismissible), findsNothing);

    // finally, swipe to dismiss one
    await mockTodoController.addItem(Todo(
      id: 7,
      title: 'Swipe me',
      body: '',
      completed: 0,
      type: TodoType.DEFAULT,
    ));
    await tester.pumpAndSettle();
    expect(find.byType(Dismissible), findsOneWidget);

    await tester.drag(find.byType(Dismissible).first, const Offset(500, 0));
    await tester.pumpAndSettle(Durations.medium4);
    expect(find.byType(Dismissible), findsNothing);
  });
}
