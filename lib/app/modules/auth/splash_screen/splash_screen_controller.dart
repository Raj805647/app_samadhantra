import 'package:get/get.dart';
import 'package:samadhantra/app/constant/token_storage_service.dart';
import 'dart:async';
import 'package:samadhantra/app/global_routes/app_routes.dart';

import '../../../../firebase_service.dart';
import '../../../Service_Provider_Section/modules/service_provider_bottom_nav_screen/service_provider_bottom_nav_screen.dart';

class SplashScreenController extends GetxController {
  @override
  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }
  Future<void> checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2)); // Splash delay

    String? token = await TokenService.getAccessToken();
    print('asdkjbfjkdsabhf');
    print(token);


    if (token != null && token.isNotEmpty) {
      // ✅ Token exists → Home
      Get.offAllNamed(AppRoutes.bottomnavScreen);

    } else {
      // ❌ Token not found → Login

      Get.offAllNamed(AppRoutes.login);
    }
  }

}
