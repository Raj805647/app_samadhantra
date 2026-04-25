import 'package:get/get.dart';

import 'forgot_password_screen_controller.dart';

class ForgotPasswordScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotPasswordScreenController>(() => ForgotPasswordScreenController());
  }
}
