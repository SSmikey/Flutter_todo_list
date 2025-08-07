import 'package:get/get.dart';
import '../views/login_page.dart';
import '../views/home_page.dart';
import '../views/register_page.dart';
import '../views/settings_page.dart';

class AppPages {
  static String INITIAL = '/login';

  static final routes = [
    GetPage(name: '/login', page: () => const LoginPage()),
    GetPage(name: '/register', page: () => const RegisterPage()),
    GetPage(name: '/home', page: () => HomePage()),
    GetPage(name: '/settings', page: () => const SettingsPage()),
  ];
}
