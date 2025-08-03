// ✅ FILE: app/routes/app_pages.dart
import 'package:get/get.dart';
import '../views/login_page.dart';
import '../views/home_page.dart';
import '../views/todo_form_page.dart';
import '../views/stats_page.dart';

class AppPages {
  static String INITIAL = '/login';

  static final routes = [
    GetPage(name: '/login', page: () => const LoginPage()),
    GetPage(name: '/home', page: () => HomePage()),
    GetPage(name: '/form', page: () => const TodoFormPage()),
    GetPage(name: '/stats', page: () => const StatsPage()),
  ];
}
