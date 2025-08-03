import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/todo_controller.dart';
import '../models/todo_model.dart';
import '../widgets/todo_card.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final TodoController controller = Get.put(TodoController());

  void _showAddOrEditDialog(BuildContext context, {TodoModel? existing}) {
    final titleC = TextEditingController(text: existing?.title ?? '');
    final categoryC = TextEditingController(text: existing?.category ?? '');
    DateTime? pickedDate = existing?.dueDate;

    String getDateString(DateTime? date) {
      if (date == null) return 'ไม่ระบุ';
      try {
        return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
      } catch (_) {
        return 'ไม่ระบุ';
      }
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(existing == null ? 'เพิ่ม ToDo' : 'แก้ไข ToDo'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleC, decoration: const InputDecoration(labelText: 'หัวข้อ')),
              TextField(controller: categoryC, decoration: const InputDecoration(labelText: 'หมวดหมู่')),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Text('วันครบกำหนด: '),
                  Text(getDateString(pickedDate)),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final dt = await showDatePicker(
                        context: context,
                        initialDate: pickedDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (dt != null) pickedDate = dt;
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('ยกเลิก')),
          ElevatedButton(
            onPressed: () {
              final title = titleC.text.trim();
              final category = categoryC.text.trim();
              if (title.isEmpty) return;
              if (existing == null) {
                controller.addTodo(title, category, pickedDate);
              } else {
                controller.deleteTodo(existing.id);
                controller.addTodo(title, category, pickedDate);
              }
              Navigator.pop(context);
            },
            child: Text(existing == null ? 'เพิ่ม' : 'บันทึก'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('รายการ ToDo'),
        actions: [
          Obx(() => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Center(
                  child: Text(
                    'เสร็จ: ${controller.doneCount}  ค้าง: ${controller.pendingCount}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              )),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'ล้างทั้งหมด',
            onPressed: () {
              controller.clearAll();
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.todos.isEmpty) {
          return const Center(child: Text('ไม่มีรายการ ToDo'));
        }
        return ListView.builder(
          itemCount: controller.todos.length,
          itemBuilder: (_, index) {
            final todo = controller.todos[index];
            return TodoCard(
              todo: todo,
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddOrEditDialog(context),
        tooltip: 'เพิ่มรายการ ToDo',
        child: const Icon(Icons.add),
      ),
    );
  }
}
