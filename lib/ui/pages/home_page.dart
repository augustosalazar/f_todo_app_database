import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/todo.dart';
import '../controllers/todo_controller.dart';
import '../widget/new_todo_dialog.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  final TodoController todoController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo App"),
        actions: [
          IconButton(
            key: const Key('deleteAllButton'),
            onPressed: todoController.removeAll,
            icon: const Icon(Icons.delete_forever),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final padding = constraints.maxWidth > 600 ? 32.0 : 8.0;
          return Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: _list());
        },
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('floatingActionButton'),
        onPressed: () async => _addTodo(context),
        tooltip: 'Add task',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _list() {
    return Obx(() {
      final list = todoController.todoList;
      if (list.isEmpty) {
        return const Center(
          child: Text("No todos available", style: TextStyle(fontSize: 20)),
        );
      }
      return ListView.builder(
        itemCount: list.length,
        itemBuilder: (ctx, i) => _item(list[i]),
      );
    });
  }

  Widget _item(Todo todo) {
    return Dismissible(
      key: Key('todo${todo.id}'),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: const Text("Deleting", style: TextStyle(color: Colors.white)),
      ),
      onDismissed: (_) => todoController.removeItem(todo),
      child: Card(
        margin: const EdgeInsets.all(4),
        color: todo.completed == 1 ? Colors.blueGrey : Colors.yellow[200],
        child: ListTile(
          contentPadding: const EdgeInsets.all(10),
          leading: _itemIcon(todo),
          title: Text(todo.title,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(todo.body),
          isThreeLine: true,
          onTap: () => todoController.setCompleted(todo),
        ),
      ),
    );
  }

  void _addTodo(BuildContext context) async {
    await showDialog<Todo>(
      context: context,
      builder: (BuildContext context) {
        return const NewTodoDialog(
          key: Key('newTodoDialog'),
        );
      },
    );
  }

  Widget _itemIcon(Todo item) {
    switch (item.type) {
      case TodoType.CALL:
        return const Icon(Icons.call, size: 72);
      case TodoType.HOME_WORK:
        return const Icon(Icons.contacts, size: 72);
      case TodoType.DEFAULT:
      default:
        return const Icon(Icons.check, size: 72);
    }
  }
}
