import 'package:flutter/material.dart';

import '../../domain/entities/todo.dart';
import 'todo_type_dropdown.dart';

class NewTodoDialog extends StatefulWidget {
  const NewTodoDialog({Key? key}) : super(key: key);

  @override
  State<NewTodoDialog> createState() => _NewTodoDialogState();
}

class _NewTodoDialogState extends State<NewTodoDialog> {
  final controllerTitle = TextEditingController();
  final controllerBody = TextEditingController();
  String _dropSelected = "DEFAULT";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.yellow[200],
      title: Text(
        'New todo',
        style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 20.0),
      ),
      content: Column(children: <Widget>[
        TextField(
          decoration: const InputDecoration(
            labelText: 'Title',
          ),
          controller: controllerTitle,
          autofocus: true,
        ),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Body',
          ),
          controller: controllerBody,
          autofocus: true,
        ),
        Expanded(
          child: TodoTypeDropdown(
            key: const Key('todoTypeDropdown'),
            selected: _dropSelected,
            onChangedValue: (value) => setState(() {
              _dropSelected = value;
            }),
          ),
        ),
      ]),
      actions: <Widget>[
        OutlinedButton(
          child: Text('Cancel',
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 16.0)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        OutlinedButton(
          key: const Key('addButtonTodoDialog'),
          child: Text('Add',
              style: TextStyle(
                  color: Theme.of(context).primaryColor, fontSize: 16.0)),
          onPressed: () {
            final todo = Todo(
                title: controllerTitle.value.text,
                body: controllerBody.value.text,
                completed: 0,
                type: Todo.visibilityFromString(_dropSelected));
            controllerTitle.clear();
            controllerBody.clear();

            Navigator.of(context).pop(todo);
          },
        ),
      ],
    );
  }
}
