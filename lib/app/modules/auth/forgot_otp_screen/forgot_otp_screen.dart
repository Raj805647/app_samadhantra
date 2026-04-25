import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'package:samadhantra/app/constant/app_images.dart';
import 'package:samadhantra/app/constant/app_strings.dart';
import 'package:samadhantra/app/constant/app_style.dart';
import 'package:samadhantra/app/global_routes/app_routes.dart';
import 'forgot_otp_screen_controller.dart';

class ForgotOtpScreen extends StatelessWidget {
  final ForgotOtpScreenController controller = Get.put(ForgotOtpScreenController());

  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());

  ForgotOtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppImageAssets.loginImage),
          fit: BoxFit.cover,
        ),
      ),

      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          iconTheme: const IconThemeData(
            color: Colors.white, // 👈 back arrow color
          ),
          elevation: 0,
        ),
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: AppStyle.heightPercent(context, 8)),

                  Text(
                    AppStrings.forgotOtp,
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),

                  SizedBox(height: AppStyle.heightPercent(context, 5)),

                  Text(
                    AppStrings.enterTheSixDigitCodeSentToYourMobile,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.white.withOpacity(0.8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  SizedBox(height: AppStyle.heightPercent(context, 8)),

                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(6, (index) => _otpBox(index)),
                    ),
                  ),

                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        Get.offAllNamed(AppRoutes.login);
                      },
                      style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(
                          AppColors.appColor, // ✅ TEXT COLOR FIXED
                        ),
                        textStyle: MaterialStateProperty.all(
                          TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      child: Text(AppStrings.backToLogin),
                    ),
                  ),


                  // Spacer(),

                  Center(
                    child: FloatingActionButton(
                      // backgroundColor: Color(0xFF00C27A),
                      backgroundColor: AppColors.appColor,
                      onPressed: () {
                        Get.toNamed(AppRoutes.resetPassword);
                        // String code = controller.otpCode;
                        // controller.forgotPasswordOtpApi();
                        // if (code.length != 6) {
                        //   CommonSnackBar.show(message: AppStrings.enterValidSixDigitOtp,title: AppStrings.error,type: SnackType.error);
                        //   return;
                        // }
                        // CommonSnackBar.show(message: "Entered: $code",title: "OTP",type: SnackType.success);
                      },
                      child: Icon(Icons.arrow_forward, color: Colors.white),
                    ),
                  ),

                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================= OTP TEXT FIELD BOX =================
  Widget _otpBox(int index) {
    return Container(
      height: 55,
      width: 45,
      child: TextField(
        focusNode: focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),

        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: Colors.grey.shade200,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),

        // ------------ On Number Input ------------
        onChanged: (value) {
          if (value.isNotEmpty) {
            controller.setDigit(index, value);

            // Move to next field automatically
            if (index < 5) {
              FocusScope.of(Get.context!).requestFocus(focusNodes[index + 1]);
            }
          } else {
            // Backspace moves to previous field
            if (index > 0) {
              FocusScope.of(Get.context!).requestFocus(focusNodes[index - 1]);
            }
          }
        },
      ),
    );
  }
}
