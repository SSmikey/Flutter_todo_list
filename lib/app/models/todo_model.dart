class Todo {
  String title;
  String? note;
  bool isDone;
  String? category;
  DateTime? dueDate;

  Todo({
    required this.title,
    this.note,
    this.isDone = false,
    this.category,
    this.dueDate,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      title: json['title'],
      note: json['note'],
      isDone: json['isDone'],
      category: json['category'],
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'note': note,
        'isDone': isDone,
        'category': category,
        'dueDate': dueDate?.toIso8601String(),
      };
}

class TodoModel {
  String id;
  String title;
  String? note;
  bool isDone;
  String? category;
  DateTime? dueDate;

  TodoModel({
    required this.id,
    required this.title,
    this.note,
    this.isDone = false,
    this.category,
    this.dueDate,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'],
      title: json['title'],
      note: json['note'],
      isDone: json['isDone'],
      category: json['category'],
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'note': note,
        'isDone': isDone,
        'category': category,
        'dueDate': dueDate?.toIso8601String(),
      };
}