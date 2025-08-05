import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/todo_controller.dart';
import '../models/todo_model.dart';
import 'todo_card.dart';
import 'stats_page.dart'; // ใช้ StatsPage จากไฟล์นี้

// เพิ่ม HomeContent และ ListPage ให้สมบูรณ์
class HomeContent extends StatelessWidget {
  final void Function(BuildContext, {TodoModel? existing}) showAddOrEditDialog;

  const HomeContent({super.key, required this.showAddOrEditDialog});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TodoController>();

    return Obx(() {
      if (controller.todos.isEmpty) {
        return const Center(child: Text('ไม่มีรายการ ToDo'));
      }
      return ListView.builder(
        itemCount: controller.todos.length,
        itemBuilder: (_, index) {
          final todo = controller.todos[index];
          return TodoCard(
            todo: todo,
            onEdit: () => showAddOrEditDialog(context, existing: todo),
          );
        },
      );
    });
  }
}

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('หน้ารายการทั้งหมด'));
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('การตั้งค่า'));
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TodoController controller = Get.put(TodoController());
  int _selectedIndex = 0;

  String getDateString(DateTime? date) {
    if (date == null) return 'ไม่ระบุ';
    return "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
  }

  void _showAddOrEditDialog(BuildContext context, {TodoModel? existing}) {
    final titleC = TextEditingController(text: existing?.title ?? '');
    final categoryC = TextEditingController(text: existing?.category ?? '');
    DateTime? pickedDate = existing?.dueDate;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
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
                          if (dt != null) {
                            setStateDialog(() {
                              pickedDate = dt;
                            });
                          }
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
                    controller.updateTodo(
                      existing.id,
                      title,
                      category,
                      pickedDate,
                    );
                  }

                  Navigator.pop(context);
                },
                child: Text(existing == null ? 'เพิ่ม' : 'บันทึก'),
              ),
            ],
          );
        },
      ),
    );
  }

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeContent(showAddOrEditDialog: _showAddOrEditDialog),
      const ListPage(),
      const StatsPage(), // ใช้ StatsPage จาก stats_page.dart
      const SettingsPage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF0D47A1), // กรม
          primary: const Color(0xFF1565C0), // น้ำเงิน
          secondary: const Color(0xFF42A5F5), // ฟ้า
          surface: Colors.white, // ใช้ surface แทน background
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1565C0), // น้ำเงิน
          foregroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFF1565C0), // น้ำเงิน
          foregroundColor: Colors.white,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFF0D47A1), // กรม
          unselectedItemColor: Colors.grey,
        ),
      ),
      child: Scaffold(
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
              onPressed: controller.clearAll,
            ),
          ],
        ),
        body: _pages[_selectedIndex],
        floatingActionButton: _selectedIndex == 0
            ? FloatingActionButton(
                onPressed: () => _showAddOrEditDialog(context),
                tooltip: 'เพิ่มรายการ ToDo',
                child: const Icon(Icons.add),
              )
            : null,
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
           items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'หน้าหลัก'),
            BottomNavigationBarItem(icon: Icon(Icons.list), label: 'รายการ'),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'สถิติ'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'ตั้งค่า'),
          ],
        ),
      ),
    );
  }
}