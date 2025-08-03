import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/todo_model.dart';

class TodoController extends GetxController {
  var todos = <TodoModel>[].obs;
  var box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    loadTodos();
  }

  void loadTodos() {
    final storedTodos = box.read<List>('todos');
    if (storedTodos != null) {
      todos.assignAll(storedTodos.map((e) => TodoModel.fromJson(e)).toList());
    }
  }

  void saveTodos() {
    box.write('todos', todos.map((e) => e.toJson()).toList());
  }

  void addTodo(String title, String category, DateTime? dueDate) {
    todos.add(TodoModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      isDone: false,
      category: category,
      dueDate: dueDate,
    ));
    saveTodos();
  }

  void toggleTodo(String id) {
    var index = todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      todos[index].isDone = !todos[index].isDone;
      todos.refresh();
      saveTodos();
    }
  }

  void deleteTodo(String id) {
    todos.removeWhere((todo) => todo.id == id);
    saveTodos();
  }

  void clearAll() {
    todos.clear();
    saveTodos();
  }

  int get doneCount => todos.where((todo) => todo.isDone).length;
  int get pendingCount => todos.where((todo) => !todo.isDone).length;
}
