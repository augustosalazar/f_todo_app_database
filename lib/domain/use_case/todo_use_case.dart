import 'package:get/get.dart';
import '../entities/random_Todo.dart';
import '../entities/todo.dart';
import '../repositories/Todo_repository.dart';

class TodoUseCase {
  TodoRepository repository = Get.find();

  Future<void> addTodo() async => await repository.getTodo();

  Future<List<Todo>> getAllTodos() async => await repository.getAllTodos();

  Future<void> deleteTodo(id) async => await repository.deleteTodo(id);

  Future<void> deleteAll() async => await repository.deleteAll();

  Future<void> updateTodo(todo) async => await repository.updateTodo(Todo);
}
