import '../../domain/entities/todo.dart' show Todo;
import '../../domain/repositories/i_todo_repository.dart';
import '../datasources/local/i_todo_local_datasource.dart';

class TodoRepository implements ITodoRepository {
  final ITodoLocalDataSource localDataSource;

  TodoRepository(this.localDataSource);

  @override
  Future<void> addTodo(Todo todo) async => await localDataSource.addTodo(todo);

  @override
  Future<List<Todo>> getAllTodos() async => await localDataSource.getAllTodos();

  @override
  Future<void> deleteTodo(id) async => await localDataSource.deleteTodo(id);

  @override
  Future<void> deleteAll() async => await localDataSource.deleteAll();

  @override
  Future<void> updateTodo(Todo todo) async =>
      await localDataSource.updateTodo(todo);
}
