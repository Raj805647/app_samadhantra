import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/constant/app_button.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'package:samadhantra/app/constant/app_images.dart';
import 'package:samadhantra/app/constant/app_strings.dart';
import 'package:samadhantra/app/constant/app_style.dart';
import 'package:samadhantra/app/constant/app_textstyle.dart';
import 'package:samadhantra/app/constant/custom_textformfield.dart';

import 'forgot_password_screen_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final ForgotPasswordScreenController controller = Get.put(
    ForgotPasswordScreenController(),
  );

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
        backgroundColor: AppColors.transparent,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(AppStyle.heightPercent(context, 2)),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),

                      // App Logo and Title
                      Container(
                        padding: EdgeInsets.all(
                          AppStyle.heightPercent(context, 2),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: AppColors.appColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              child: const Icon(
                                Icons.lock_reset,
                                size: 40,
                                color: AppColors.appColor,
                              ),
                            ),
                            SizedBox(height: AppStyle.heightPercent(context, 2)),
                             Text(
                              AppStrings.resetPassword,
                              style: AppTextStyles.heading2.copyWith(color: AppColors.appColor),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              AppStrings.enterYourEmailToResetPassword,
                              style: AppTextStyles.body.copyWith(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Forgot Password Form
                      Container(
                        padding: EdgeInsets.all(
                          AppStyle.heightPercent(context, 3),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                             Text(
                              AppStrings.forgotPassword,

                               style: AppTextStyles.heading2.copyWith(color: AppColors.appColor),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Don't worry! It happens. Please enter your email address and we'll send you a reset link.",
                              style: AppTextStyles.body.copyWith(color: Colors.grey),
                            ),
                            const SizedBox(height: 32),

                            // Email Field
                            CustomTextFormField(
                              hintText: "Enter your email address",
                              labelText: "Email Address",
                              prefixIcon: Icons.email_outlined,
                              controller: controller.emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: controller.validateEmail,
                              textInputAction: TextInputAction.done,
                              onFieldSubmitted: (_) => controller.sendResetLink(),
                            ),

                            SizedBox(height: AppStyle.heightPercent(context, 3)),

                            // Send Reset Link Button
                            Obx(
                                  () => AppButton(
                                title: AppStrings.sendResetLInk,
                                isLoading: controller.isLoading.value,
                                onPressed: controller.sendResetLink,
                              ),
                            ),


                            SizedBox(height: AppStyle.heightPercent(context, 2)),

                            // Back to Login
                            Center(
                              child: TextButton(
                                onPressed: () => Get.back(),
                                child: const Text(
                                  AppStrings.backToLogin,
                                  style: TextStyle(
                                    color: AppColors.appColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Help Section
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3F2FD), // soft blue background
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.blue.shade200,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.help_outline_rounded,
                                color: Colors.blue.shade700,
                                size: 28,
                              ),
                            ),

                            const SizedBox(height: 16),

                            Text(
                              "Need Help?",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.blue.shade800,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              "If you're having trouble resetting your password, please contact your school administrator for assistance.",
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.4,
                                color: Colors.blue.shade700,
                              ),
                              textAlign: TextAlign.center,
                            ),

                            const SizedBox(height: 20),

                            SizedBox(
                              width: double.infinity,
                              height: 44,
                              child: ElevatedButton.icon(
                                onPressed: controller.contactSupport,
                                icon: const Icon(Icons.support_agent_rounded, size: 18),
                                label: const Text(
                                  AppStrings.contactSupport,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade700,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: AppStyle.heightPercent(context, 2)),
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
