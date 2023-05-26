import 'package:get/get.dart';
import 'package:loggy/loggy.dart';
import '../../data/mocks/mock_todo.dart';
import '../../domain/entities/todo.dart';

class TodoController extends GetxController {
  final _todoList = <Todo>[].obs;

  List<Todo> get todoList => _todoList.value;

  TodoController() {
    _todoList.value = MockTodo.fetchAll();
  }

  void addItem(item) {
    _todoList.add(item);
  }

  void removeItem(item) {
    _todoList.remove(item);
  }

  void setCompleted(index) {
    logInfo('setCompleted $index');
    _todoList[index].completed == 0
        ? _todoList[index].completed = 1
        : _todoList[index].completed = 0;
    _todoList.refresh();
  }
}
