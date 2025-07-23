import 'package:f_todo_app_database/domain/use_case/todo_use_case.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';
import '../../domain/entities/todo.dart';

class TodoController extends GetxController {
  final _todoList = <Todo>[].obs;

  TodoController() {
    getAllTodos();
  }

  List<Todo> get todoList => _todoList.value;

  TodoUseCase todoUseCase = Get.find();

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

  Future<void> addItem(item) async {
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

  void removeAll() async {
    await todoUseCase.deleteAll();
    await getAllTodos();
  }
}
