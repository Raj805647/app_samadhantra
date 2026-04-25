import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:samadhantra/app/constant/app_button.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'package:samadhantra/app/constant/app_images.dart';
import 'package:samadhantra/app/constant/app_strings.dart';
import 'package:samadhantra/app/constant/app_style.dart';
import 'package:samadhantra/app/global_routes/app_routes.dart';
import 'package:timer_button/timer_button.dart';
import 'otp_screen_controller.dart';
import 'package:get/get.dart';

class OtpScreen extends StatelessWidget {
  OtpScreen({super.key});
  final controller = Get.put(OtpScreenController());
  @override
  Widget build(BuildContext context) {
    // final String isPhone =
    //     Get.arguments?['isStackholder'];
    // print("jiiiiiiiii${isPhone}");
    // Custom pin theme
    final defaultPinTheme = PinTheme(
      width: AppStyle.widthPercent(context, 13),
      height: AppStyle.widthPercent(context, 13),
      textStyle: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.black,
      ),
      decoration: BoxDecoration(
        color: AppColors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.greyCA.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: AppColors.greyCA.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: AppColors.appColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.appColor.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: AppColors.appColor.withOpacity(0.1),
        border: Border.all(color: AppColors.appColor, width: 2),
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        height: AppStyle.heightPercent(context, 100),
        width: AppStyle.widthPercent(context, 100),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AppImageAssets.loginImage),
            fit: BoxFit.fill,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: AppStyle.heightPercent(context, 5)),
              Row(
                children: [
                  SizedBox(width: AppStyle.widthPercent(context, 5)),
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      width: AppStyle.widthPercent(context, 8),
                      height: AppStyle.heightPercent(context, 8),
                      decoration: BoxDecoration(
                        color: AppColors.white.withOpacity(0.95),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.black.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                          BoxShadow(
                            color: AppColors.appColor.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                        border: Border.all(
                          color: AppColors.appColor.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: AppColors.black,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppStyle.heightPercent(context, 3)),
              // App Logo with Animation
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 1000),
                tween: Tween(begin: 0.0, end: 1.0),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.white,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.appColor.withOpacity(0.3),
                            spreadRadius: 3,
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                          BoxShadow(
                            color: AppColors.greyCA.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          AppImageAssets.splashBgImage,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: AppStyle.heightPercent(context, 2)),

              // App Title with Gradient
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [AppColors.black, AppColors.black],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: const Text(
                  AppStrings.verifyOtp,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              SizedBox(height: AppStyle.heightPercent(context, 2)),

              Container(
                width: AppStyle.widthPercent(context, 80),
                height: AppStyle.heightPercent(context, 5),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: AppColors.white.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child:  Text(
                  AppStrings.enterThe6DigitCodeSentToYourPhone,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.white,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: AppStyle.heightPercent(context, 5)),

              // OTP Input Container
              Container(
                width: AppStyle.widthPercent(context, 90),
                height: AppStyle.heightPercent(context, 40),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.appColor.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                    BoxShadow(
                      color: AppColors.greyCA.withOpacity(0.1),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: AppStyle.heightPercent(context, 2)),
                    // OTP Title
                    SizedBox(
                      width: AppStyle.widthPercent(context, 80),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.white.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.security,
                              color: AppColors.appColor,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            AppStrings.enterVerificationCode,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: AppStyle.heightPercent(context, 4)),

                    // OTP Pin Input
                    SizedBox(
                      width: AppStyle.widthPercent(context, 80),
                      child: Pinput(
                        length: 6,
                        controller: controller.otpController.value,
                        focusNode: controller.otpFocusNode,
                        defaultPinTheme: defaultPinTheme,
                        focusedPinTheme: focusedPinTheme,
                        keyboardType: TextInputType.number,
                        submittedPinTheme: submittedPinTheme,
                        pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                        showCursor: true,
                        onCompleted: (pin) => () {},
                        onChanged: (value) {
                          if (value.length == 6) {
                            FocusScope.of(context).unfocus();
                          }
                        },
                      ),
                    ),
                    SizedBox(height: AppStyle.heightPercent(context, 4)),

                    SizedBox(
                      width: AppStyle.widthPercent(context, 80),
                      child: AppButton(
                        onPressed: () {
                          Get.offAllNamed(AppRoutes.bottomnavScreen);
                        },
                        title: AppStrings.verifyOtp,
                        icon: Icons.verified_user,
                      ),
                    ),
                    // Resend OTP
                    SizedBox(
                      width: AppStyle.widthPercent(context, 80),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            AppStrings.verifyOtp,
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 14,
                            ),
                          ),
                          TimerButton(
                            label: AppStrings.resend,
                            buttonType: ButtonType.textButton,
                            color: Colors.transparent,
                            disabledColor: Colors.transparent,
                            activeTextStyle: const TextStyle(
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              decorationStyle: TextDecorationStyle.solid,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.white,
                            ),
                            disabledTextStyle: const TextStyle(
                              color: AppColors.white,
                            ),
                            timeOutInSeconds: 30,
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppStyle.heightPercent(context, 4)),
            ],
          ),
        ),
      ),
    );
  }
}
