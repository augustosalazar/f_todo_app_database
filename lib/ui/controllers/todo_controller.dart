import 'package:f_todo_app_database/domain/use_case/todo_use_case.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';
import '../../data/mocks/mock_todo.dart';
import '../../domain/entities/todo.dart';

class TodoController extends GetxController {
  final _todoList = <Todo>[].obs;

  List<Todo> get todoList => _todoList.value;

  TodoUseCase todoUseCase = Get.find();

  TodoController() {
    getAllTodos();
  }

  Future<void> getAllTodos() async {
    logInfo("userController -> getAllUsers");
    var list = await todoUseCase.getAllTodos();
    _todoList.value = list;
  }

  void addItem(item) async {
    await todoUseCase.addTodo(item);
    await getAllTodos();
  }

  void removeItem(item) async {
    _todoList.remove(item);
  }

  void setCompleted(index) async {
    logInfo('setCompleted $index');
    _todoList[index].completed == 0
        ? _todoList[index].completed = 1
        : _todoList[index].completed = 0;
    _todoList.refresh();
  }
}
