import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';
import '../../domain/entities/todo.dart';
import '../controllers/todo_controller.dart';
import '../widget/new_todo_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TodoController todoController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo App"),
        actions: [
          IconButton(
              key: const Key('deleteAllButton'),
              onPressed: () {
                todoController.removeAll();
              },
              icon: const Icon(Icons.delete_forever))
        ],
      ),
      body: _list(),
      floatingActionButton: FloatingActionButton(
          key: const Key('floatingActionButton'),
          onPressed: _addTodo,
          tooltip: 'Add task',
          child: const Icon(Icons.add)),
    );
  }

  Widget _list() {
    return Obx(() => ListView.builder(
          itemCount: todoController.todoList.length,
          itemBuilder: (context, posicion) {
            var element = todoController.todoList[posicion];
            return _item(element, posicion);
          },
        ));
  }

  Widget _item(Todo element, int posicion) {
    logInfo('(UI)creating item on List with id ${element.id}');
    return Dismissible(
      key: Key('todo${element.id}'),
      background: Container(
          color: Colors.red,
          alignment: Alignment.centerLeft,
          child: const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Text(
              "Deleting",
              style: TextStyle(color: Colors.white),
            ),
          )),
      onDismissed: (direction) {
        // Remove the item from the data source.
        todoController.removeItem(element);
      },
      child: Card(
        key: const Key('todoCard'),
        margin: const EdgeInsets.all(4.0),
        color: element.completed == 1 ? Colors.blueGrey : Colors.yellow[200],
        child: ListTile(
            contentPadding: const EdgeInsets.all(10.0),
            leading: _itemIcon(element),
            title: _itemTitle(element),
            subtitle: _itemSubTitle(element),
            isThreeLine: true,
            onTap: () => _onTap(context, element, posicion)),
      ),
    );
  }

  Widget _itemIcon(Todo item) {
    switch (item.type) {
      case TodoType.DEFAULT:
        return const Icon(Icons.check, size: 72.0);
      case TodoType.CALL:
        return const Icon(Icons.call, size: 72.0);
      case TodoType.HOME_WORK:
        return const Icon(Icons.contacts, size: 72.0);
      default:
        return const Icon(Icons.dialpad, size: 72.0);
    }
  }

  void _onTap(BuildContext context, Todo location, int posicion) {
    logInfo(location.title);
    logInfo('$posicion');
    todoController.setCompleted(location);
  }

  Widget _itemTitle(Todo item) {
    return Text(item.title,
        style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold));
  }

  Widget _itemSubTitle(Todo item) {
    return Text(item.body, style: const TextStyle(fontSize: 10.0));
  }

  _addTodo() async {
    final todo = await showDialog<Todo>(
      context: context,
      builder: (BuildContext context) {
        return const NewTodoDialog(
          key: Key('newTodoDialog'),
        );
      },
    );

    if (todo != null) {
      todoController.addItem(todo);
    }
  }
}
