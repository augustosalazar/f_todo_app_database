import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../domain/entities/todo.dart';
import '../controllers/todo_controller.dart';
import 'todo_type_dropdown.dart';

class NewTodoDialog extends StatefulWidget {
  const NewTodoDialog({super.key});

  @override
  State<NewTodoDialog> createState() => _NewTodoDialogState();
}

class _NewTodoDialogState extends State<NewTodoDialog> {
  final controllerTitle = TextEditingController();
  final controllerBody = TextEditingController();
  String _dropSelected = "DEFAULT";

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return AlertDialog(
          backgroundColor: Colors.yellow[200],
          contentPadding: const EdgeInsets.all(16.0),
          title: Text(
            'New todo',
            style: TextStyle(
                color: Theme.of(context).primaryColor, fontSize: 20.0),
          ),
          content: SingleChildScrollView(
            child: ConstrainedBox(
              constraints:
                  BoxConstraints(maxHeight: constraints.maxHeight * 0.6),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Title',
                    ),
                    controller: controllerTitle,
                    autofocus: true,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Body',
                    ),
                    controller: controllerBody,
                  ),
                  const SizedBox(height: 16),
                  TodoTypeDropdown(
                    key: const Key('todoTypeDropdown'),
                    selected: _dropSelected,
                    onChangedValue: (value) => setState(() {
                      _dropSelected = value;
                    }),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            OutlinedButton(
              child: Text(
                'Cancel',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 16.0),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            OutlinedButton(
              key: const Key('addButtonTodoDialog'),
              child: Text(
                'Add',
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 16.0),
              ),
              onPressed: () {
                TodoController controller = Get.find();
                controller.addTodo(
                  controllerTitle.value.text,
                  controllerBody.value.text,
                  Todo.visibilityFromString(_dropSelected),
                );
                controllerTitle.clear();
                controllerBody.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
