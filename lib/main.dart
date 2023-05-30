import 'package:f_todo_app_database/domain/use_case/todo_use_case.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:loggy/loggy.dart';
import 'domain/entities/todo_hive.dart';
import 'domain/repositories/todo_repository.dart';
import 'ui/controllers/todo_controller.dart';
import 'ui/todoapp.dart';

Future<List<Box>> _openBox() async {
  List<Box> boxList = [];
  await Hive.initFlutter();
  Hive.registerAdapter(TodoHiveAdapter());
  boxList.add(await Hive.openBox("todos"));
  return boxList;
}

void main() async {
  Loggy.initLoggy(
    logPrinter: const PrettyPrinter(
      showColors: true,
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await _openBox();
  Get.put(TodoRepository());
  Get.put(TodoUseCase());
  Get.put(TodoController());
  runApp(const TodoApp(
    key: Key('TodoApp'),
  ));
}
