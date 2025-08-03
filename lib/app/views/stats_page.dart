import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/todo_controller.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final todoCtrl = Get.find<TodoController>();
    final total = todoCtrl.todos.length;
    final done = todoCtrl.todos.where((t) => t.isDone).length;
    final notDone = total - done;

    final categories = <String, int>{};
    for (var t in todoCtrl.todos) {
      final key = t.category ?? 'Uncategorized';
      categories[key] = (categories[key] ?? 0) + 1;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total Tasks: $total'),
            Text('Completed: $done'),
            Text('Pending: $notDone'),
            const SizedBox(height: 20),
            const Text('By Category:'),
            ...categories.entries.map((e) => Text('${e.key}: ${e.value}')),
          ],
        ),
      ),
    );
  }
}
