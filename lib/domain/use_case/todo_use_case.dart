import '../entities/todo.dart';
import '../repositories/i_todo_repository.dart';

class TodoUseCase {
  final ITodoRepository repository;

  TodoUseCase(this.repository);

  Future<void> addTodo(Todo todo) async => await repository.addTodo(todo);

  Future<List<Todo>> getAllTodos() async => await repository.getAllTodos();

  Future<void> deleteTodo(id) async => await repository.deleteTodo(id);

  Future<void> deleteAll() async => await repository.deleteAll();

  Future<void> updateTodo(todo) async => await repository.updateTodo(todo);
}
