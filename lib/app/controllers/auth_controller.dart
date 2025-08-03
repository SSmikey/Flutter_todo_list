import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  final _box = GetStorage();
  final isLoggedIn = false.obs;

  @override
  void onInit() {
    super.onInit();
    isLoggedIn.value = _box.read('loggedIn') ?? false;
  }

  // Login ด้วยอีเมลและรหัสผ่าน ถ้าสำเร็จจะไปหน้า home_page.dart ทันที
  void login(String email, String password) {
    if (email == 'admin' && password == '1234') {
      isLoggedIn.value = true;
      _box.write('loggedIn', true);
      Get.offAllNamed('/home'); // ไปหน้า home_page.dart ทันที
    } else {
      Get.snackbar('Error', 'Invalid credentials');
    }
  }

  void logout() {
    isLoggedIn.value = false;
    _box.write('loggedIn', false);
    Get.offAllNamed('/login');
  }
}

