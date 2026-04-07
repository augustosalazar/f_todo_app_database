import 'package:f_todo_app_database/core/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'pages/home_page.dart';

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      title: 'TODO APP',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
