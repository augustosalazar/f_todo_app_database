import 'package:f_todo_app_database/domain/entities/todo_hive.dart';
import 'package:hive/hive.dart';
import 'package:loggy/loggy.dart';

import '../../../domain/entities/todo.dart';
import 'i_todo_local_datasource.dart';

class TodoLocalDataSourceHive implements ITodoLocalDataSource {
  Box<TodoHive> get _box => Hive.box<TodoHive>('todos');

  @override
  Future<List<Todo>> getAllTodos() async {
    return _box.values.map((e) => e.toTodo()).toList();
  }

  @override
  Future<void> addTodo(Todo todo) async {
    logInfo(
      'Adding todo to database with title: ${todo.title} body: ${todo.body} completed: ${todo.completed} type: ${todo.type}',
    );

    final todoHive = TodoHive.fromTodo(todo: todo);
    await _box.add(todoHive);
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    if (todo.id == null) {
      throw ArgumentError('Todo id cannot be null when updating');
    }

    logInfo(
      'Updating todo in database with title: ${todo.title} body: ${todo.body} completed: ${todo.completed} type: ${todo.type}',
    );

    final todoHive = TodoHive.fromTodo(todo: todo);
    await _box.put(todo.id, todoHive);
  }

  @override
  Future<void> deleteAll() async {
    logInfo('Deleting all from database');
    await _box.clear();
  }

  @override
  Future<void> deleteTodo(int id) async {
    logInfo('Deleting todo from database with id: $id');
    await _box.delete(id);
  }
}
