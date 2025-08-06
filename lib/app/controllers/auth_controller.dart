import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

class AuthController extends GetxController {
  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}');
    return emailRegex.hasMatch(email);
  }

  List<Map<String, dynamic>> users = [];
  final _box = GetStorage();
  final isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    isLoggedIn.value = _box.read('loggedIn') ?? false;
    users = List<Map<String, dynamic>>.from(_box.read('users') ?? []);
  }

  void saveUsers() {
    _box.write('users', users);
  }

  // สมัครสมาชิกใหม่
  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (!isValidEmail(normalizedEmail)) {
      return {'success': false, 'errorMessage': 'กรุณาใส่อีเมลที่ถูกต้อง'};
    }
    if (users.any(
      (u) => (u['email'] as String).trim().toLowerCase() == normalizedEmail,
    )) {
      return {'success': false, 'errorMessage': 'อีเมลนี้ถูกลงทะเบียนแล้ว'};
    }
    users.add({'name': name, 'email': normalizedEmail, 'password': password});
    saveUsers();
    return {'success': true};
  }

  /// login: return true ถ้าสำเร็จ, false ถ้า fail, และ errorMessage
  Future<Map<String, dynamic>> login(String email, String password) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (!isValidEmail(normalizedEmail)) {
      return {'success': false, 'errorMessage': 'กรุณาใส่อีเมลที่ถูกต้อง.'};
    }
    final user = users.isNotEmpty
        ? users.firstWhere(
            (u) =>
                (u['email'] as String).trim().toLowerCase() ==
                    normalizedEmail &&
                u['password'] == password,
            orElse: () => {},
          )
        : {};
    if (user.isNotEmpty) {
      isLoggedIn.value = true;
      _box.write('loggedIn', true);
      _box.write('user', user);
      return {'success': true};
    } else {
      return {'success': false, 'errorMessage': 'อีเมลหรือรหัสผ่านไม่ถูกต้อง'};
    }
  }

  void logout() {
    isLoggedIn.value = false;
    _box.write('loggedIn', false);
    Get.offAllNamed('/login');
  }

  void resetPassword(String lowerCase, String trim, BuildContext context) {}
}
