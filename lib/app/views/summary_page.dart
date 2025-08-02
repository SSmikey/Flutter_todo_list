import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/todo_controller.dart'; //รอtodo_controller.dart

class SummaryPage extends StatelessWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final todoController = Get.find<TodoController>(); //รอtodo_controller.dart
    final total = todoController.todos.length;
    final completed = todoController.todos.where((t) => t.isDone).length;
    final pending = total - completed;

    return Scaffold(
      appBar: AppBar(title: const Text('สรุปรายการทั้งหมด')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            SummaryTile(label: 'ทั้งหมด', count: total, color: Colors.blue),
            SummaryTile(label: 'เสร็จแล้ว', count: completed, color: Colors.green),
            SummaryTile(label: 'ยังไม่เสร็จ', count: pending, color: Colors.orange),
          ],
        ),
      ),
    );
  }
}

class SummaryTile extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const SummaryTile({
    super.key,
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: ListTile(
        leading: CircleAvatar(backgroundColor: color, child: Text('$count')),
        title: Text(label, style: Theme.of(context).textTheme.titleMedium),
      ),
    );
  }
}