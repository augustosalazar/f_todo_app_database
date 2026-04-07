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
  void dispose() {
    controllerTitle.dispose();
    controllerBody.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      Icons.add_task_rounded,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'New todo',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextField(
                controller: controllerTitle,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Title',
                  hintText: 'Ej. Llamar al cliente',
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.35),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: controllerBody,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Agrega detalles opcionales',
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest
                      .withValues(alpha: 0.35),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TodoTypeDropdown(
                key: const Key('todoTypeDropdown'),
                selected: _dropSelected,
                onChangedValue: (value) {
                  setState(() {
                    _dropSelected = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    key: const Key('addButtonTodoDialog'),
                    onPressed: () {
                      final title = controllerTitle.text.trim();
                      final body = controllerBody.text.trim();

                      if (title.isEmpty) return;

                      final controller = Get.find<TodoController>();
                      controller.addTodo(
                        title,
                        body,
                        Todo.visibilityFromString(_dropSelected),
                      );

                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.check_rounded),
                    label: const Text('Add'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
