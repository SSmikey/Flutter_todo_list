import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/routes/app_pages.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return GetMaterialApp(
      title: 'To Do List',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
=======
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello World!'),//fkgnlfk
        ),
      ),
>>>>>>> 9a556d92962f64774da06e8e84fe1c3165551b7d
    );
  }
}