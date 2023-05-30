import 'package:loggy/loggy.dart';

import '../../data/datasources/local/todo_local_datasource_hive.dart';
import '../../data/datasources/local/todo_local_datasource_sqflite.dart';
import '../entities/todo.dart';

class TodoRepository {
  late TodoLocalDataSource localDataSource;
  //late TodoLocalDataSourceHive localDataSource;

  TodoRepository() {
    logInfo("Starting TodoRepository");
    localDataSource = TodoLocalDataSource();
    //localDataSource = TodoLocalDataSourceHive();
  }

  Future<void> addTodo(Todo todo) async => await localDataSource.addTodo(todo);

  Future<List<Todo>> getAllTodos() async => await localDataSource.getAllTodos();

  Future<void> deleteTodo(id) async => await localDataSource.deleteTodo(id);

  Future<void> deleteAll() async => await localDataSource.deleteAll();

  Future<void> updateTodo(Todo todo) async =>
      await localDataSource.updateTodo(todo);
}
