import 'package:get/get.dart';

class ForgotOtpScreenController extends GetxController {
  RxList<String> otp = List<String>.filled(6, "").obs;

  void setDigit(int index, String value) {
    otp[index] = value;
  }

  String get otpCode => otp.join();

  RxBool isLoading = false.obs;
  // final ApiService _apiService = ApiService();
  RxBool isEmail = false.obs;
  RxString type = "".obs;
  RxString value = "".obs;


  @override
  void onInit() {
    super.onInit();
    // final args = Get.arguments;
    // isEmail.value = args['isEmail'];
    // type.value = args['type'];
    // value.value = args['value'];
  }

  // Future<void> forgotPasswordOtpApi() async {
  //   try {
  //     isLoading.value = true;
  //
  //     // -------- INPUT VARIABLE (email or phone) --------
  //     String input = value.trim();  // your input field
  //     String otp = otpCode.trim();
  //
  //     // -------- EMAIL / PHONE VALIDATION --------
  //     if (isEmail.value) {
  //       if (input.isEmpty) throw "Please enter your email address";
  //       if (!GetUtils.isEmail(input)) throw "Please enter a valid email address";
  //     } else {
  //       if (input.isEmpty) throw "Please enter your mobile number";
  //       if (input.length != 10) throw "Please enter a valid 10-digit mobile number";
  //     }
  //
  //     // -------- OTP VALIDATION --------
  //     if (otp.isEmpty) throw "Please enter OTP";
  //     if (otp.length < 4) throw "OTP must be at least 4 digits";
  //
  //     // -------- REQUEST BODY --------
  //     Map<String, dynamic> body = {
  //       isEmail.value ? "email" : "phone": input,
  //       "otp": otp,
  //     };
  //
  //     // -------- API CALL --------
  //     final response = await _apiService.post(
  //       AppConfig.forgotPasswordOtpUrl,
  //       data: body,
  //     );
  //
  //     if (response.data is! Map<String, dynamic>) {
  //       throw "Invalid response format from server";
  //     }
  //
  //     final Map<String, dynamic> res = response.data;
  //     print("OTP VERIFY RESPONSE => $res");
  //
  //     final String message = res["message"] ?? "OTP verified successfully";
  //     final String? resetToken = res["data"]?["reset_token"];
  //
  //     // -------- SUCCESS --------
  //     if (res["status"] == "success") {
  //       CommonSnackBar.show(
  //         message: message,
  //         title: "Success",
  //         type: SnackType.success,
  //       );
  //
  //       // -------- NAVIGATE TO RESET PASSWORD --------
  //       Get.toNamed(
  //         AppRoutes.resetPassword,
  //         arguments: {
  //           isEmail.value ? "email" : "phone": input,
  //           "reset_token": resetToken,
  //         },
  //       );
  //     } else {
  //       CommonSnackBar.show(
  //         message: message,
  //         title: "Error",
  //         type: SnackType.error,
  //       );
  //     }
  //
  //   } catch (e, stackTrace) {
  //     debugPrint("❌ OTP VERIFY ERROR: $e");
  //     debugPrint("❌ STACK TRACE: $stackTrace");
  //
  //     CommonSnackBar.show(
  //       message: e.toString(),
  //       title: "OTP Verification Failed",
  //       type: SnackType.error,
  //     );
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }



}
