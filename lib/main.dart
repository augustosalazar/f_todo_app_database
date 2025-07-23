import 'package:f_todo_app_database/data/datasources/local/todo_local_datasource_sqflite.dart';
import 'package:f_todo_app_database/domain/use_case/todo_use_case.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:loggy/loggy.dart';
import 'data/datasources/local/i_todo_local_datasource.dart';
import 'data/datasources/local/todo_local_datasource_hive.dart';
import 'data/repositories/todo_repository.dart';
import 'domain/entities/todo_hive.dart';
import 'domain/repositories/i_todo_repository.dart';
import 'ui/controllers/todo_controller.dart';
import 'ui/todoapp.dart';

Future<void> _openBox() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TodoHiveAdapter());
  await Hive.openBox("todos");
}

void main() async {
  Loggy.initLoggy(
    logPrinter: const PrettyPrinter(
      showColors: true,
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();

  //await _openBox();
  //Get.put<ITodoLocalDataSource>(TodoLocalDataSourceHive());
  Get.put<ITodoLocalDataSource>(TodoLocalDataSourceSqflite());
  Get.put<ITodoRepository>(TodoRepository(Get.find()));
  Get.put(TodoUseCase(Get.find()));
  Get.put(TodoController());
  runApp(const TodoApp(
    key: Key('TodoApp'),
  ));
}
