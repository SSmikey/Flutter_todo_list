import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/todo_controller.dart';
import '../models/todo_model.dart';
import 'package:intl/intl.dart';

class TodoFormPage extends StatefulWidget {
  const TodoFormPage({super.key});

  @override
  State<TodoFormPage> createState() => _TodoFormPageState();
}

class _TodoFormPageState extends State<TodoFormPage> {
  final todoCtrl = Get.find<TodoController>();
  final titleCtrl = TextEditingController();
  // final noteCtrl = TextEditingController();
  final categoryCtrl = TextEditingController();
  DateTime? dueDate;

  int? index;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    if (args != null && args['todo'] != null) {
      final TodoModel todo = args['todo'];
      titleCtrl.text = todo.title;
      // noteCtrl.text = todo.note ?? '';
      categoryCtrl.text = todo.category ?? '';
      dueDate = todo.dueDate;
      index = args['index'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(index == null ? 'Add Todo' : 'Edit Todo')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 12),
            // TextField(
            //   controller: noteCtrl,
            //   decoration: const InputDecoration(labelText: 'Note'),
            //   maxLines: 3,
            // ),
            // const SizedBox(height: 12),
            TextField(
              controller: categoryCtrl,
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('Due Date:'),
                const SizedBox(width: 12),
                Text(
                  dueDate != null
                      ? DateFormat('yyyy-MM-dd').format(dueDate!)
                      : 'Not set',
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setState(() => dueDate = picked);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final title = titleCtrl.text.trim();
                // final note = noteCtrl.text.trim();
                final category = categoryCtrl.text.trim();
                if (title.isEmpty) return;

                if (index == null) {
                  todoCtrl.addTodo(title, category, dueDate);
                } else {
                  // หากต้องการแก้ไข ต้องเพิ่มเมธอด updateTodo ใน controller
                  // todoCtrl.updateTodo(index!, todo);
                }

                Get.back();
              },
              child: Text(index == null ? 'Add' : 'Update'),
            )
          ],
        ),
      ),
    );
  }
}
