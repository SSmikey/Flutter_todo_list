import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/routes/app_pages.dart';

import 'app/controllers/auth_controller.dart';

void main() async {
  await GetStorage.init();
  Get.put(AuthController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'To Do List',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Kanit',
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Kanit',
        brightness: Brightness.dark,
      ),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}