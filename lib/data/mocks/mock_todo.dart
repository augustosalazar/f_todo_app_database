import '../../domain/entities/todo.dart';

class MockTodo extends Todo {
  MockTodo(
      {required super.title, required super.body, required super.completed});

  static final List<Todo> items = [
    Todo(title: "One", body: "TheBond1", completed: 0, type: TodoType.DEFAULT),
    Todo(title: "Two", body: "TheBond2", completed: 0, type: TodoType.CALL),
    Todo(
        title: "Threee",
        body: "TheBond3",
        completed: 0,
        type: TodoType.DEFAULT),
    Todo(
        title: "Four", body: "TheBondy4", completed: 0, type: TodoType.DEFAULT),
  ];

  static List<Todo> fetchAll() {
    return MockTodo.items;
  }
}
