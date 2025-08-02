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

  void login(String username, String password) {
    if (username == 'admin' && password == '1234') {
      isLoggedIn.value = true;
      _box.write('loggedIn', true);
      Get.offAllNamed('/home');
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

