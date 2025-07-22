import '../entities/todo.dart';

abstract class ITodoRepository {
  Future<void> addTodo(Todo todo);

  Future<List<Todo>> getAllTodos();

  Future<void> deleteTodo(id);

  Future<void> deleteAll();

  Future<void> updateTodo(Todo todo);
}
