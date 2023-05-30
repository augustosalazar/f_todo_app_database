enum TodoType {
  DEFAULT,
  CALL,
  HOME_WORK,
}

class Todo {
  int? id;
  late String title;
  late String body;
  late int completed;
  TodoType type = TodoType.DEFAULT;

  Todo(
      {this.id,
      required this.title,
      required this.body,
      required this.completed,
      this.type = TodoType.DEFAULT});

  static TodoType visibilityFromString(String value) {
    return TodoType.values.firstWhere(
        (e) => e.toString().split('.')[1].toUpperCase() == value.toUpperCase());
  }

  // convenience constructor to create a Word object
  Todo.fromMap(Map<dynamic, dynamic> map) {
    id = map['id'];
    title = map['title'];
    body = map['body'];
    completed = map['completed'];
    type = TodoType.values[int.parse(map['type'])];
  }

  // convenience method to create a Map from this Word object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'title': title,
      'body': body,
      'completed': completed,
      'type': type.index.toInt(),
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }
}
