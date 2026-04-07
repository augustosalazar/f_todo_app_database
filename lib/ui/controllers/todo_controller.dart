import 'package:f_todo_app_database/data/repositories/todo_repository.dart';
import 'package:f_todo_app_database/domain/repositories/i_todo_repository.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';
import '../../domain/entities/todo.dart';

class TodoController extends GetxController {
  final ITodoRepository todoUseCase;
  final _todoList = <Todo>[].obs;

  List<Todo> get todoList => _todoList.value;

  TodoController(this.todoUseCase);

  @override
  void onInit() {
    getAllTodos();
    super.onInit();
  }

  Future<void> getAllTodos() async {
    var list = await todoUseCase.getAllTodos();
    logInfo("userController-getAllUsers-${list.length} items");
    _todoList.value = list;
  }

  Future<void> addTodo(title, body, type) async {
    logInfo("userController -> addTodo");
    Todo todo = Todo(
      title: title,
      body: body,
      completed: 0,
      type: type,
    );
    await addItem(todo);
  }

  Future<void> addItem(Todo item) async {
    await todoUseCase.addTodo(item);
    await getAllTodos();
  }

  Future<void> removeItem(item) async {
    await todoUseCase.deleteTodo(item.id);
    await getAllTodos();
  }

  Future<void> setCompleted(Todo item) async {
    item.completed == 0 ? item.completed = 1 : item.completed = 0;
    await todoUseCase.updateTodo(item);
    await getAllTodos();
  }

  Future<void> removeAll() async {
    await todoUseCase.deleteAll();
    await getAllTodos();
  }
}
