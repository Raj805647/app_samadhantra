import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/constant/app_button.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'package:samadhantra/app/constant/app_style.dart';
import 'package:samadhantra/app/global_routes/app_routes.dart';

class OtpScreenController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<TextEditingController> otpController = TextEditingController().obs;
  final FocusNode otpFocusNode = FocusNode();

  @override
  void onInit() {
    super.onInit();
  }

  // void showLottiePopup(BuildContext context) {
  //   Get.dialog(
  //     Dialog(
  //       backgroundColor: Colors.transparent,
  //       child: Container(
  //         constraints: const BoxConstraints(maxWidth: 300, maxHeight: 400),
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.circular(20),
  //         ),
  //         child: Padding(
  //           padding: const EdgeInsets.all(24.0),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               // Lottie Animation Container
  //               Container(
  //                 height: 150,
  //                 width: 150,
  //                 decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(75),
  //                   color: Colors.grey[50],
  //                 ),
  //                 child: ClipRRect(
  //                   borderRadius: BorderRadius.circular(75),
  //                   child: Image.asset('assets/images/checkMark.gif'),
  //                 ),
  //               ),
  //
  //               const SizedBox(height: 20),
  //
  //               // Success Text
  //               const Text(
  //                 'Your account has been successfully verified!',
  //                 style: TextStyle(
  //                   fontSize: 20,
  //                   fontWeight: FontWeight.bold,
  //                   color: AppColors.black,
  //                   // fontFamily: AppFonts.fontFamily,
  //                 ),
  //                 textAlign: TextAlign.center,
  //               ),
  //
  //               const SizedBox(height: 8),
  //
  //               const Text(
  //                 'Please waiting for admin approval',
  //                 style: TextStyle(
  //                   fontSize: 14,
  //                   color: Colors.grey,
  //                   // fontFamily: AppFonts.fontFamily,
  //                 ),
  //                 textAlign: TextAlign.center,
  //               ),
  //
  //               const SizedBox(height: 24),
  //
  //               // OK Button
  //               SizedBox(
  //                 width: double.infinity,
  //                 height: AppStyle.heightPercent(context, 6),
  //                 child: AppButton(
  //                   onPressed: () {
  //                       Get.offAllNamed(AppRoutes.bottomnavScreen);
  //                   },
  //                   title: "OK",
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //     barrierDismissible: false,
  //   );
  // }
}
