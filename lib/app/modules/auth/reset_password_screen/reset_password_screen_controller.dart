import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ResetPasswordScreenController extends GetxController {

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxBool isLoading = false.obs;
  // final ApiService _apiService = ApiService();
  late String email;

  @override
  void onInit() {
    super.onInit();
    // final args = Get.arguments;
    // email = args["email"];
  }

  // Future<void> resetPasswordApi() async {
  //   try {
  //     isLoading.value = true;
  //
  //     // ✅ BUILD BODY - Only email is required
  //     Map<String, dynamic> body = {
  //       "email": email,
  //       "new_password": passwordController.text,
  //     };
  //
  //     final response = await _apiService.post(
  //       AppConfig.resetPasswordUrl, // Make sure to add this in AppConfig
  //       data: body,
  //     );
  //
  //     // ✅ SAFELY HANDLE RESPONSE TYPE
  //     if (response.data is! Map<String, dynamic>) {
  //       throw "Invalid response format from server";
  //     }
  //
  //     final Map<String, dynamic> resetPasswordData = response.data;
  //
  //     print("✅ FORGOT PASSWORD RESPONSE => $resetPasswordData");
  //
  //     // ✅ EXTRACT SUCCESS MESSAGE OR OTP BASED ON YOUR API RESPONSE
  //     final message =
  //         resetPasswordData["message"] ??
  //             "Password reset instructions sent to your email";
  //
  //     final success = resetPasswordData["status"];
  //
  //     CommonSnackBar.show(
  //       message: message,
  //       title: "Success",
  //       type: SnackType.success,
  //     );
  //
  //     if(success == "success"){
  //       Get.offAllNamed(
  //         AppRoutes.login,
  //       );
  //     }
  //
  //   } catch (e, stackTrace) {
  //     debugPrint("❌ FORGOT PASSWORD ERROR: $e");
  //     debugPrint("❌ STACK TRACE: $stackTrace");
  //
  //     CommonSnackBar.show(
  //       message: e.toString(),
  //       title: "Forgot Password Failed",
  //       type: SnackType.error,
  //     );
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

}

