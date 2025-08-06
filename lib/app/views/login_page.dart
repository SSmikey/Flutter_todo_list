import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authCtrl = Get.find<AuthController>();
    final emailCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    // เช็ค argument ที่ส่งมาจาก RegisterPage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map && args['successMessage'] != null) {
        Get.snackbar(
          'สำเร็จ',
          args['successMessage'],
          backgroundColor: Colors.green.shade100,
          colorText: Colors.green,
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.TOP,
        );
      }
    });

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 124, 127, 139),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: Colors.blue.shade100,
                        child: const Icon(
                          Icons.calendar_today,
                          size: 40,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'To Do List ✔️',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'ลงชื่อเข้าใช้เพื่อดำเนินการต่อ',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: emailCtrl,
                        decoration: InputDecoration(
                          labelText: 'อีเมล',
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณากรอกอีเมล';
                          }
                          if (!GetUtils.isEmail(value)) {
                            return 'รูปแบบอีเมลไม่ถูกต้อง';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: passwordCtrl,
                        decoration: InputDecoration(
                          labelText: 'รหัสผ่าน',
                          prefixIcon: const Icon(Icons.lock_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณากรอกรหัสผ่าน';
                          }
                          if (value.length < 6) {
                            return 'รหัสผ่านต้องมีอย่างน้อย 6 ตัวอักษร';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () async {
                            if (formKey.currentState?.validate() != true)
                              return;
                            FocusScope.of(context).unfocus();
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                            final result = await authCtrl.login(
                              emailCtrl.text.trim(),
                              passwordCtrl.text.trim(),
                            );
                            Navigator.of(context).pop();
                            if (result['success'] == true) {
                              Get.snackbar(
                                'สำเร็จ',
                                'เข้าสู่ระบบสำเร็จ!',
                                backgroundColor: Colors.green.shade100,
                                colorText: Colors.green,
                                duration: const Duration(seconds: 1),
                                snackPosition: SnackPosition.TOP,
                              );
                              Future.delayed(
                                const Duration(milliseconds: 300),
                                () {
                                  Get.offAllNamed('/home');
                                },
                              );
                            } else {
                              Get.snackbar(
                                'การเข้าสู่ระบบล้มเหลว',
                                result['errorMessage'] ?? 'เกิดข้อผิดพลาด',
                                backgroundColor: Colors.red.shade100,
                                colorText: Colors.red,
                                duration: const Duration(seconds: 2),
                                snackPosition: SnackPosition.TOP,
                              );
                            }
                          },
                          child: const Text(
                            'เข้าสู่ระบบ',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'ยังไม่มีบัญชี ?',
                            style: TextStyle(fontSize: 15),
                          ),
                          TextButton(
                            onPressed: () => Get.toNamed('/register'),
                            child: const Text(
                              'สร้างบัญชีใหม่',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
