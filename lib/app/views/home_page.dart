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
              TextField(
                controller: titleC,
                decoration: const InputDecoration(labelText: 'หัวข้อ'),
              ),
              TextField(
                controller: categoryC,
                decoration: const InputDecoration(labelText: 'หมวดหมู่'),
              ),
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
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('ยกเลิก'),
          ),
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

  Widget _buildStatBox(String count, String label, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              count,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: color)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Row(
                    children: [
                      Icon(Icons.calendar_today, size: 20),
                      SizedBox(width: 8),
                      Text(
                        "test day",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Statistics Grid
              Column(
                children: [
                  Row(
                    children: [
                      _buildStatBox("32", "Completed", Colors.teal),
                      _buildStatBox("24", "Pending", Colors.deepOrange),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildStatBox("16", "Cancelled", Colors.pink),
                      _buildStatBox("08", "Ongoing", Colors.indigo),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Tasks header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text("Tasks", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
              const SizedBox(height: 12),

              // Tasks List
              Expanded(
                child: Obx(() {
                  if (controller.todos.isEmpty) {
                    return const Center(child: Text('ไม่มีรายการ ToDo'));
                  }
                  return ListView.separated(
                    itemCount: controller.todos.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, index) {
                      final todo = controller.todos[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: TodoCard(todo: todo),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),

      // Add Button
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddOrEditDialog(context),
        child: const Icon(Icons.add),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
               icon: const Icon(Icons.home),
               onPressed: () {
                  Get.snackbar(
                    "ยังไม่รองรับ",
                    "หน้านี้ยังไม่เปิดใช้งาน",
                    snackPosition: SnackPosition.BOTTOM,
                    duration: const Duration(seconds: 2),
                  );
              },
            ),
            const SizedBox(width: 48), // Space for FAB
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Get.snackbar(
                  "ยังไม่รองรับ",
                  "หน้านี้ยังไม่เปิดใช้งาน",
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}