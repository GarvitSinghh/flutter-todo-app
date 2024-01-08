// Todo Model: convert recieved JSON to List<Todo> and Todo

import 'dart:convert';

Todos todosFromJson(String str) => Todos.fromJson(json.decode(str));

String todosToJson(Todos data) => json.encode(data.toJson());

class Todos {
    final List<Todo> todos;
    final int total;
    final int skip;
    final int limit;

    Todos({
        required this.todos,
        required this.total,
        required this.skip,
        required this.limit,
    });

    factory Todos.fromJson(Map<String, dynamic> json) => Todos(
        todos: List<Todo>.from(json["todos"].map((x) => Todo.fromJson(x))),
        total: json["total"],
        skip: json["skip"],
        limit: json["limit"],
    );

    Map<String, dynamic> toJson() => {
        "todos": List<dynamic>.from(todos.map((x) => x.toJson())),
        "total": total,
        "skip": skip,
        "limit": limit,
    };
}

class Todo {
    final int id;
    final String todo;
    bool completed;
    final int userId;

    Todo({
        required this.id,
        required this.todo,
        required this.completed,
        required this.userId,
    });

    factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        id: json["id"],
        todo: json["todo"],
        completed: json["completed"],
        userId: json["userId"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "todo": todo,
        "completed": completed,
        "userId": userId,
    };
}
