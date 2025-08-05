import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/todo_controller.dart';
import '../models/todo_model.dart';
import 'package:intl/intl.dart';

class TodoCard extends StatelessWidget {
  final TodoModel todo;
  final VoidCallback? onEdit; // เพิ่มบรรทัดนี้
  final TodoController controller = Get.find<TodoController>();

  TodoCard({super.key, required this.todo, this.onEdit}); // เพิ่ม this.onEdit

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dueText = todo.dueDate != null
        ? DateFormat('dd MMM yyyy').format(todo.dueDate!)
        : 'ไม่มีกำหนด';

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            if (todo.category != null && todo.category!.isNotEmpty)
              Text('หมวดหมู่: ${todo.category!}', style: theme.textTheme.bodySmall),
            Text('กำหนด: $dueText', style: theme.textTheme.bodySmall),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              tooltip: 'แก้ไข',
              onPressed: onEdit, // ใช้ onEdit ที่รับมา
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              tooltip: 'ลบ',
              onPressed: () => controller.deleteTodo(todo.id),
            ),
          ],
        ),
      ),
    );
  }
}