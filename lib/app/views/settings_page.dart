import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/theme_controller.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => ListTile(
                leading: const Icon(Icons.color_lens),
                title: const Text('โหมดกลางคืน'),
                trailing: Switch(
                  value: themeController.themeMode.value == ThemeMode.dark,
                  onChanged: (val) {
                    themeController.toggleTheme(val);
                    // ลบ redirect ออก เพื่อให้ theme เปลี่ยนทันที
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('ไปที่หน้า Login'),
              onTap: () {
                Get.toNamed('/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}
