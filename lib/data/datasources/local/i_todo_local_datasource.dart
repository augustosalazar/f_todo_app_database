import '../../../domain/entities/todo.dart';

abstract class ITodoLocalDataSource {
  Future<List<Todo>> getAllTodos();

  addTodo(Todo todo);

  updateTodo(Todo todo);

  deleteTodo(index);

  deleteAll();
}
