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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Todo App"),
        centerTitle: false,
        actions: [
          IconButton(
            key: const Key('deleteAllButton'),
            tooltip: 'Delete all',
            onPressed: todoController.removeAll,
            icon: const Icon(Icons.delete_sweep_rounded),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final padding = constraints.maxWidth > 700 ? 32.0 : 16.0;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: padding, vertical: 12),
            child: _list(theme),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const Key('floatingActionButton'),
        onPressed: () async => _addTodo(context),
        icon: const Icon(Icons.add_rounded),
        label: const Text('New task'),
      ),
    );
  }

  Widget _list(ThemeData theme) {
    return Obx(() {
      final list = todoController.todoList;

      if (list.isEmpty) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.task_alt_rounded,
                size: 64,
                color: theme.colorScheme.primary.withValues(alpha: 0.7),
              ),
              const SizedBox(height: 16),
              Text(
                "No todos available",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Create your first task to get started",
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        );
      }

      return ListView.separated(
        itemCount: list.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (ctx, i) => _item(theme, list[i]),
      );
    });
  }

  Widget _item(ThemeData theme, Todo todo) {
    final isCompleted = todo.completed == 1;

    return Dismissible(
      key: Key('todo${todo.id}'),
      background: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.errorContainer,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        child: Icon(
          Icons.delete_rounded,
          color: theme.colorScheme.onErrorContainer,
        ),
      ),
      onDismissed: (_) => todoController.removeItem(todo),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          key: Key('todoTap_${todo.title}'),
          borderRadius: BorderRadius.circular(20),
          onTap: () => todoController.setCompleted(todo),
          child: Ink(
            decoration: BoxDecoration(
              color: isCompleted
                  ? theme.colorScheme.surfaceContainerHighest
                  : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isCompleted
                    ? theme.colorScheme.outlineVariant
                    : theme.colorScheme.primary.withValues(alpha: 0.15),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _itemIcon(theme, todo),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          todo.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            decoration:
                                isCompleted ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          todo.body,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            decoration:
                                isCompleted ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Chip(
                              label: Text(_typeLabel(todo.type)),
                              visualDensity: VisualDensity.compact,
                            ),
                            const Spacer(),
                            Icon(
                              isCompleted
                                  ? Icons.check_circle_rounded
                                  : Icons.radio_button_unchecked_rounded,
                              color: isCompleted
                                  ? Colors.green
                                  : theme.colorScheme.outline,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
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

  Widget _itemIcon(ThemeData theme, Todo item) {
    IconData icon;
    Color bgColor;
    Color iconColor;

    switch (item.type) {
      case TodoType.CALL:
        icon = Icons.call_rounded;
        bgColor = Colors.green.withValues(alpha: 0.12);
        iconColor = Colors.green;
        break;
      case TodoType.HOME_WORK:
        icon = Icons.home_work_rounded;
        bgColor = Colors.orange.withValues(alpha: 0.12);
        iconColor = Colors.orange;
        break;
      case TodoType.DEFAULT:
      default:
        icon = Icons.task_rounded;
        bgColor = theme.colorScheme.primary.withValues(alpha: 0.12);
        iconColor = theme.colorScheme.primary;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: iconColor, size: 24),
    );
  }

  String _typeLabel(TodoType type) {
    switch (type) {
      case TodoType.CALL:
        return 'Call';
      case TodoType.HOME_WORK:
        return 'Home work';
      case TodoType.DEFAULT:
      default:
        return 'Default';
    }
  }
}
