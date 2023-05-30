import 'package:f_todo_app_database/domain/entities/todo_hive.dart';
import 'package:hive/hive.dart';
import 'package:loggy/loggy.dart';

import '../../../domain/entities/todo.dart';

class TodoLocalDataSourceHive {
  addTodo(Todo todo) async {
    TodoHive todoHive = TodoHive.fromTodo(todo: todo);
    Hive.box('todos').add(todoHive);
  }

  Future<List<Todo>> getAllTodos() async {
    return Hive.box('todos').values.map((TodoHive e) => e.toTodo()).toList();
  }

  deleteAll() async {
    logInfo("Deleting all from database");
    await Hive.box('todos').clear();
  }

  deleteTodo(index) async {
    await Hive.box('todos').deleteAt(index);
  }

  updateTodo(Todo todo) async {
    TodoHive todoHive = TodoHive.fromTodo(todo: todo);
    await Hive.box('todos').putAt(todo.id!, todoHive);
  }
}
