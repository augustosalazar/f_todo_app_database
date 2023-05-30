import 'package:f_todo_app_database/domain/entities/todo.dart';
import 'package:hive/hive.dart';

part 'todo_hive.g.dart';

@HiveType(typeId: 0)
class TodoHive extends HiveObject {
  @HiveField(0)
  String title;

  @HiveField(1)
  String body;

  @HiveField(2)
  int completed;

  @HiveField(3)
  int type;

  TodoHive(
      {required this.title,
      required this.body,
      required this.completed,
      required this.type});

  Todo toTodo() {
    return Todo(
      title: title,
      body: body,
      completed: completed,
      type: TodoType.values[type],
    );
  }

  factory TodoHive.fromTodo({
    required Todo todo,
  }) {
    return TodoHive(
      title: todo.title,
      body: todo.body,
      completed: todo.completed,
      type: todo.type.index,
    );
  }
}
