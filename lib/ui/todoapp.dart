import 'package:flutter/material.dart';
import 'pages/home_page.dart';

class TodoApp extends StatelessWidget {
  const TodoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'TODO APP',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
