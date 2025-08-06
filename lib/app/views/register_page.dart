import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authCtrl = Get.find<AuthController>();
    final nameCtrl = TextEditingController();
    final emailCtrl = TextEditingController();
    final passwordCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
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
                      const Text(
                        'สร้างบัญชีใหม่',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: nameCtrl,
                        decoration: InputDecoration(
                          labelText: 'ชื่อผู้ใช้',
                          prefixIcon: const Icon(Icons.person_outline),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณากรอกชื่อผู้ใช้';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
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
                            if (formKey.currentState?.validate() != true) return;
                            FocusScope.of(context).unfocus();
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => const Center(child: CircularProgressIndicator()),
                            );
                            try {
                              final result = await authCtrl.register(
                                nameCtrl.text.trim(),
                                emailCtrl.text.trim(),
                                passwordCtrl.text.trim(),
                              );
                              Get.back(); // ปิด dialog loading
                              if (result['success'] == true) {
                                Get.offAllNamed(
                                  '/login',
                                  arguments: {
                                    'successMessage': 'สร้างบัญชีผู้ใช้เรียบร้อยแล้ว ! กรุณาเข้าสู่ระบบ.',
                                  },
                                );
                              } else {
                                Get.snackbar(
                                  'ข้อผิดพลาด',
                                  result['errorMessage'] ?? 'เกิดข้อผิดพลาด',
                                  backgroundColor: Colors.red.shade100,
                                  colorText: Colors.red,
                                  snackPosition: SnackPosition.TOP,
                                );
                              }
                            } catch (e) {
                              Get.back(); // ปิด dialog loading กรณี error
                              Get.snackbar(
                                'ข้อผิดพลาด',
                                'เกิดข้อผิดพลาด: $e',
                                backgroundColor: Colors.red.shade100,
                                colorText: Colors.red,
                                snackPosition: SnackPosition.TOP,
                              );
                            }
                          },
                          child: const Text(
                            'สมัครสมาชิก',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'มีบัญชีอยู่แล้ว ?',
                            style: TextStyle(fontSize: 15),
                          ),
                          TextButton(
                            onPressed: () => Get.offAllNamed('/login'),
                            child: const Text(
                              'เข้าสู่ระบบ',
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
