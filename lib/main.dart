import 'package:f_todo_app_database/domain/use_case/todo_use_case.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

import 'domain/repositories/todo_repository.dart';
import 'ui/controllers/todo_controller.dart';
import 'ui/todoapp.dart';

void main() {
  Loggy.initLoggy(
    logPrinter: const PrettyPrinter(
      showColors: true,
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(TodoRepository());
  Get.put(TodoUseCase());
  Get.put(TodoController());
  runApp(const TodoApp(
    key: Key('TodoApp'),
  ));
}
