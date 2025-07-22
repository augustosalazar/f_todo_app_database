import 'package:f_todo_app_database/domain/entities/todo_hive.dart';
import 'package:hive/hive.dart';
import 'package:loggy/loggy.dart';

import '../../../domain/entities/todo.dart';
import 'i_todo_local_datasource.dart';

class TodoLocalDataSourceHive implements ITodoLocalDataSource {
  @override
  Future<List<Todo>> getAllTodos() async {
    return Hive.box('todos').values.map((e) {
      return Todo(
          id: e.key,
          title: e.title,
          body: e.body,
          completed: e.completed,
          type: TodoType.values[e.type]);
    }).toList();
  }

  @override
  addTodo(Todo todo) async {
    logInfo(
        "Adding todo to database with title: ${todo.title}  body: ${todo.body} completed: ${todo.completed}  type: ${todo.type}");
    TodoHive todoHive = TodoHive.fromTodo(todo: todo);
    Hive.box('todos').add(todoHive);
  }

  @override
  updateTodo(Todo todo) async {
    logInfo(
        "Updating todo in database with title: ${todo.title}  body: ${todo.body} completed: ${todo.completed}  type: ${todo.type}");
    TodoHive todoHive = TodoHive.fromTodo(todo: todo);
    int id = todo.id!;
    await Hive.box('todos').put(id, todoHive);
  }

  @override
  deleteAll() async {
    logInfo("Deleting all from database");
    await Hive.box('todos').clear();
  }

  @override
  deleteTodo(index) async {
    logInfo("Deleting todo from database with index: $index");
    await Hive.box('todos').delete(index);
  }
}
