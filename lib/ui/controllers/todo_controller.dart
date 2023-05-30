import 'package:f_todo_app_database/domain/use_case/todo_use_case.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';
import '../../data/mocks/mock_todo.dart';
import '../../domain/entities/todo.dart';

class TodoController extends GetxController {
  final _todoList = <Todo>[].obs;

  TodoController() {
    getAllTodos();
  }

  List<Todo> get todoList => _todoList.value;

  TodoUseCase todoUseCase = Get.find();

  Future<void> getAllTodos() async {
    logInfo("userController -> getAllUsers");
    _todoList.clear();
    var list = await todoUseCase.getAllTodos();
    _todoList.value = list;
  }

  void addItem(item) async {
    await todoUseCase.addTodo(item);
    await getAllTodos();
  }

  void removeItem(item) async {
    await todoUseCase.deleteTodo(item.id);
    await getAllTodos();
  }

  void setCompleted(Todo item) async {
    item.completed == 0 ? item.completed = 1 : item.completed = 0;
    await todoUseCase.updateTodo(item);
    await getAllTodos();
  }

  void removeAll() async {
    await todoUseCase.deleteAll();
    await getAllTodos();
  }
}
