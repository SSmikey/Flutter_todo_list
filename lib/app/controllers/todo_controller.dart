import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/todo_model.dart';

class TodoController extends GetxController {
  var todos = <TodoModel>[].obs;
  var filteredTodos = <TodoModel>[].obs;
  var filter = 'all'.obs;
  var box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    loadTodos();
    ever(filter, (_) => filterTodos());
  }

  void loadTodos() {
    final storedTodos = box.read<List>('todos');
    if (storedTodos != null) {
      todos.assignAll(storedTodos.map((e) => TodoModel.fromJson(e)).toList());
      filterTodos();
    }
    filterTodos();
  }

  void saveTodos() {
    box.write('todos', todos.map((e) => e.toJson()).toList());
    filterTodos();
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
    filterTodos();
  }

  void toggleTodo(String id) {
    var index = todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      todos[index].isDone = !todos[index].isDone;
      todos.refresh();
      saveTodos();
      filterTodos();
    }
  }

  void deleteTodo(String id) {
    todos.removeWhere((todo) => todo.id == id);
    saveTodos();
    filterTodos();
  }

  void clearAll() {
    todos.clear();
    saveTodos();
    filterTodos();
  }

  void setFilter(String value) {
    filter.value = value;
    filterTodos();
  }

  void filterTodos() {
    switch (filter.value) {
      case 'done':
        filteredTodos.assignAll(todos.where((todo) => todo.isDone));
        break;
      case 'pending':
        filteredTodos.assignAll(todos.where((todo) => !todo.isDone));
        break;
      case 'work':
        filteredTodos.assignAll(todos.where((todo) => todo.category == 'งาน'));
        break;
      case 'personal':
        filteredTodos.assignAll(todos.where((todo) => todo.category == 'ส่วนตัว'));
        break;
      default:
        filteredTodos.assignAll(todos);
    }
  }

  int get doneCount => todos.where((todo) => todo.isDone).length;
  int get pendingCount => todos.where((todo) => !todo.isDone).length;
}
