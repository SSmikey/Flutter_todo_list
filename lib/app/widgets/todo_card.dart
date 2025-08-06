
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/todo_controller.dart';
import '../models/todo_model.dart';
import 'package:intl/intl.dart';

class TodoCard extends StatelessWidget {
  final TodoModel todo;
  final Color? cardColor;
  final TodoController controller = Get.find();

  TodoCard({super.key, required this.todo, this.cardColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: cardColor,
      child: ListTile(
        leading: Checkbox(
          value: todo.isDone,
          onChanged: (_) => controller.toggleTodo(todo.id),
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isDone ? TextDecoration.lineThrough : null,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (todo.category != null && todo.category!.isNotEmpty)
              Text('หมวดหมู่: ${todo.category!}',
                  style: theme.textTheme.bodySmall),
            
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => controller.deleteTodo(todo.id),
        ),
      ),
    );
  }
}
