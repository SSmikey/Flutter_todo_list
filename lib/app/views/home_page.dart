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
    final List<String> categories = ['งาน', 'โรงเรียน', 'ส่วนตัว', 'อื่นๆ'];
    String selectedCategory = existing?.category ?? categories[0];
    DateTime? pickedDate = existing?.dueDate;
    TimeOfDay? pickedTime = existing?.dueDate != null
        ? TimeOfDay(
            hour: existing!.dueDate!.hour,
            minute: existing.dueDate!.minute,
          )
        : null;

    String getDateTimeString(DateTime? date, TimeOfDay? time) {
      if (date == null) return 'ไม่ระบุ';
      final dateStr =
          "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
      final timeStr = time != null
          ? "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}"
          : '--:--';
      return "$dateStr $timeStr";
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 24,
              ),
              child: StatefulBuilder(
                builder: (context, setState) => SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      Text(
                        existing == null ? 'เพิ่ม Task' : 'แก้ไข Task',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: titleC,
                        decoration: const InputDecoration(labelText: 'หัวข้อ'),
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: selectedCategory,
                        decoration: const InputDecoration(
                          labelText: 'หมวดหมู่',
                        ),
                        items: categories
                            .map(
                              (cat) => DropdownMenuItem(
                                value: cat,
                                child: Text(cat),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          if (val != null)
                            setState(() => selectedCategory = val);
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Text('วันครบกำหนด: '),
                          Text(getDateTimeString(pickedDate, pickedTime)),
                          IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () async {
                              final dt = await showDatePicker(
                                context: context,
                                initialDate: pickedDate ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (dt != null) setState(() => pickedDate = dt);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.access_time),
                            onPressed: () async {
                              final tm = await showTimePicker(
                                context: context,
                                initialTime: pickedTime ?? TimeOfDay.now(),
                              );
                              if (tm != null) setState(() => pickedTime = tm);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('ยกเลิก'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              final title = titleC.text.trim();
                              final category = selectedCategory;
                              if (title.isEmpty) return;
                              DateTime? finalDate;
                              if (pickedDate != null) {
                                if (pickedTime != null) {
                                  finalDate = DateTime(
                                    pickedDate!.year,
                                    pickedDate!.month,
                                    pickedDate!.day,
                                    pickedTime!.hour,
                                    pickedTime!.minute,
                                  );
                                } else {
                                  finalDate = pickedDate;
                                }
                              }
                              if (existing == null) {
                                controller.addTodo(title, category, finalDate);
                              } else {
                                controller.deleteTodo(existing.id);
                                controller.addTodo(title, category, finalDate);
                              }
                              Navigator.pop(context);
                            },
                            child: Text(existing == null ? 'เพิ่ม' : 'บันทึก'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatBox(String count, String label, Color color) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          if (label == "Completed") {
            controller.setFilter('completed');
          } else if (label == "Pending") {
            controller.setFilter('pending');
          } else if (label == "Work") {
            controller.setFilter('งาน');
          } else if (label == "School") {
            controller.setFilter('โรงเรียน');
          } else if (label == "Personal") {
            controller.setFilter('ส่วนตัว');
          } else if (label == "Other") {
            controller.setFilter('อื่นๆ');
          } else {
            controller.setFilter('');
          }
        },
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
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 4),
              Text(label, style: TextStyle(color: color)),
            ],
          ),
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
                        "Tasks management",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Statistics Grid
              Obx(() {
                final todos = controller.todos;
                final completed = todos.where((t) => t.isDone == true).length;
                final pending = todos.where((t) => t.isDone != true).length;
                final work = todos.where((t) => t.category == 'งาน').length;
                final school = todos
                    .where((t) => t.category == 'โรงเรียน')
                    .length;
                final personal = todos
                    .where((t) => t.category == 'ส่วนตัว')
                    .length;
                final other = todos.where((t) => t.category == 'อื่นๆ').length;
                return Column(
                  children: [
                    Row(
                      children: [
                        _buildStatBox(
                          completed.toString(),
                          "Completed",
                          Colors.teal,
                        ),
                        _buildStatBox(
                          pending.toString(),
                          "Pending",
                          Colors.red,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildStatBox(work.toString(), "Work", Colors.pink),
                        _buildStatBox(
                          school.toString(),
                          "School",
                          Colors.orangeAccent,
                        ),
                        _buildStatBox(
                          personal.toString(),
                          "Personal",
                          Colors.deepPurpleAccent,
                        ),
                        _buildStatBox(other.toString(), "Other", Colors.indigo),
                      ],
                    ),
                  ],
                );
              }),
              const SizedBox(height: 24),

              // Tasks header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Tasks",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Tasks List
              Expanded(
                child: Obx(() {
                  final filtered = controller.filteredTodos;
                  if (filtered.isEmpty) {
                    return const Center(child: Text('ไม่มีรายการ ToDo'));
                  }
                  return ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, index) {
                      final todo = filtered[index];
                      String dateTimeStr = '';
                      if (todo.dueDate != null) {
                        final d = todo.dueDate!;
                        dateTimeStr =
                            "${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year} "
                            "${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}";
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TodoCard(
                              todo: todo,
                              cardColor: todo.isDone == true
                                  ? Colors.teal.withOpacity(0.15)
                                  : Colors.white,
                            ),
                            if (dateTimeStr.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: 12,
                                  top: 2,
                                  bottom: 8,
                                ),
                                child: Text(
                                  'กำหนด: $dateTimeStr',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                          ],
                        ),
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
                controller.setFilter('');
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
