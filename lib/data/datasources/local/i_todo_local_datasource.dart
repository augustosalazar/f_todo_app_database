import '../../../domain/entities/todo.dart';

abstract class ITodoLocalDataSource {
  Future<List<Todo>> getAllTodos();

  Future<void> addTodo(Todo todo);

  Future<void> updateTodo(Todo todo);

  Future<void> deleteTodo(int id);

  Future<void> deleteAll();
}
