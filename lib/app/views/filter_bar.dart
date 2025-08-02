import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/todo_controller.dart'; //รอtodo_controller.dart

class FilterBar extends StatelessWidget {
  const FilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    final todoController = Get.find<TodoController>(); //รอtodo_controller.dart

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          FilterChip(
            label: const Text('ทั้งหมด'),
            selected: todoController.filter.value == 'all',
            onSelected: (_) => todoController.setFilter('all'),
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('เสร็จแล้ว'),
            selected: todoController.filter.value == 'done',
            onSelected: (_) => todoController.setFilter('done'),
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('ยังไม่เสร็จ'),
            selected: todoController.filter.value == 'pending',
            onSelected: (_) => todoController.setFilter('pending'),
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('หมวด: งาน'),
            selected: todoController.filter.value == 'work',
            onSelected: (_) => todoController.setFilter('work'),
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('หมวด: ส่วนตัว'),
            selected: todoController.filter.value == 'personal',
            onSelected: (_) => todoController.setFilter('personal'),
          ),
        ],
      ),
    );
  }
}