import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/razorpay_screen/payment_screen.dart';
import 'package:samadhantra/app/constant/app_button.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'package:samadhantra/app/constant/app_images.dart';
import 'package:samadhantra/app/constant/app_strings.dart';
import 'package:samadhantra/app/constant/app_style.dart';
import 'package:samadhantra/app/constant/app_textstyle.dart';
import 'package:samadhantra/app/constant/custom_snackbar.dart';
import 'package:samadhantra/app/constant/custom_textformfield.dart';
import 'package:samadhantra/app/constant/validators.dart';
import 'package:samadhantra/app/global_routes/app_routes.dart';
import 'login_screen_controller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginScreenController controller = Get.put(LoginScreenController());

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
                      SizedBox(height: AppStyle.heightPercent(context, 3)),

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
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.appColor.withOpacity(0.2),
                                    AppColors.appColor.withOpacity(0.05),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.appColor.withOpacity(0.4),
                                    blurRadius: 16,
                                    spreadRadius: 3,
                                  ),
                                ],
                              ),
                              child: Center(
                                child: CircleAvatar(
                                  radius: 32,
                                  backgroundColor: Colors.white,
                                  child: Image.asset(
                                    AppImageAssets.samadhantraImage,
                                    width: 40,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: AppStyle.heightPercent(context, 1.2),
                            ),
                            Text(
                              AppStrings.appName,
                              style: AppTextStyles.heading2.copyWith(
                                color: AppColors.appColor,
                              ),
                            ),
                            SizedBox(
                              height: AppStyle.heightPercent(context, 1.2),
                            ),
                            Text(
                              AppStrings.welcomeBack,
                              style: AppTextStyles.body.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: AppStyle.heightPercent(context, 2)),

                      // Login Form
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.login,
                              style: AppTextStyles.heading1.copyWith(
                                color: AppColors.appColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: AppStyle.heightPercent(context, 2),
                            ),
                            Text(
                              AppStrings.signInToYourAccount,
                              style: AppTextStyles.body.copyWith(
                                color: Colors.grey,
                              ),
                            ),

                            SizedBox(
                              height: AppStyle.heightPercent(context, 2),
                            ),

                            // Phone/Email Toggle
                            // Obx(
                            //   () => Container(
                            //     decoration: BoxDecoration(
                            //       color: AppColors.appColor.withOpacity(0.05),
                            //       borderRadius: BorderRadius.circular(12),
                            //       border: Border.all(
                            //         color: AppColors.appColor.withOpacity(0.2),
                            //       ),
                            //     ),
                            //     child: Row(
                            //       children: [
                            //         Expanded(
                            //           child: _buildToggleButton(
                            //             'Phone',
                            //             Icons.phone,
                            //             controller.isPhoneLogin.value,
                            //             () {
                            //               if (!controller.isPhoneLogin.value) {
                            //                 controller.toggleLoginMethod();
                            //               }
                            //             },
                            //           ),
                            //         ),
                            //         Expanded(
                            //           child: _buildToggleButton(
                            //             'Email',
                            //             Icons.email,
                            //             !controller.isPhoneLogin.value,
                            //             () {
                            //               if (controller.isPhoneLogin.value) {
                            //                 controller.toggleLoginMethod();
                            //               }
                            //             },
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),

                            // SizedBox(
                            //   height: AppStyle.heightPercent(context, 2),
                            // ),

                            // Phone or Email Field based on toggle
                            // Obx(() {
                              // if (controller.isPhoneLogin.value) {
                              //   return CustomTextFormField(
                              //     hintText: "Enter your phone number",
                              //     labelText: "Phone Number",
                              //     prefixIcon: Icons.phone_outlined,
                              //     controller: controller.phoneController,
                              //     keyboardType: TextInputType.phone,
                              //     validator: controller.validatePhone,
                              //     textInputAction: TextInputAction.next,
                              //     inputFormatters: [
                              //       FilteringTextInputFormatter.digitsOnly,
                              //     ],
                              //     maxLength: 10,
                              //   );
                              // } else {
                              //    return
                                  Column(
                                  children: [
                                    CustomTextFormField(
                                      hintText: "Enter your email",
                                      labelText: "Email Address",
                                      prefixIcon: Icons.email_outlined,
                                      controller: controller.emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      validator: controller.validateEmail,
                                      textInputAction: TextInputAction.next,
                                    ),
                                    SizedBox(
                                      height: AppStyle.heightPercent(
                                        context,
                                        2,
                                      ),
                                    ),

                                    // Password Field
                                    CustomTextFormField(
                                      hintText: 'Password',
                                      labelText: 'Password',
                                      controller: controller.passwordController,
                                      isPassword: true,
                                      prefixIcon: Icons.lock_outline,
                                      validator: Validators.password,
                                    ),
                                  ],
                                ),
                              // }
                            // }),

                            SizedBox(
                              height: AppStyle.heightPercent(context, 1.8),
                            ),

                            // Remember Me & Forgot Password
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(
                                  () => Row(
                                    children: [
                                      Checkbox(
                                        value: controller.rememberMe.value,
                                        onChanged: (value) =>
                                            controller.rememberMe.value =
                                                value ?? false,
                                        activeColor: AppColors.appColor,
                                      ),
                                      Text(
                                        AppStrings.rememberMe,
                                        style: AppTextStyles.caption.copyWith(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Get.toNamed(AppRoutes.forgotPassword);
                                  },
                                  child: Text(
                                    AppStrings.forgotPassword,
                                    style: AppTextStyles.title.copyWith(
                                      color: AppColors.appColor,
                                      fontSize: 13.sp,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(
                              height: AppStyle.heightPercent(context, 3),
                            ),

                            // Login Button
                            // Obx(
                            //   () => AppButton(
                            //     title: !controller.isPhoneLogin.value
                            //         ? AppStrings.login
                            //         : AppStrings.sendOtp,
                            //     icon: Icons.login,
                            //     isLoading: controller.isLoading.value,
                            //     onPressed: () {
                            //       if (controller.formKey.currentState!
                            //           .validate()) {
                            //         controller.login();
                            //         // Get.toNamed(AppRoutes.bottomnavScreen);
                            //         return;
                            //       }
                            //     },
                            //   ),
                            // ),
                            Obx(
                                  () => AppButton(
                                title: AppStrings.login,
                                icon: Icons.login,
                                isLoading: controller.isLoading.value,
                                onPressed: () {
                                  if (controller.formKey.currentState!
                                      .validate()) {
                                    controller.login();
                                    // Get.toNamed(AppRoutes.bottomnavScreen);
                                    return;
                                  }
                                },
                              ),
                            ),
                            SizedBox(
                              height: AppStyle.heightPercent(context, 1),
                            ),
                            // SizedBox(
                            //   width: double.infinity,
                            //   height: 46,
                            //   child: OutlinedButton(
                            //     onPressed: () {},
                            //     style: OutlinedButton.styleFrom(
                            //       backgroundColor: Colors.white,
                            //       foregroundColor: Colors.black87,
                            //       side: BorderSide(color: Colors.grey.shade300),
                            //       shape: RoundedRectangleBorder(
                            //         borderRadius: BorderRadius.circular(10),
                            //       ),
                            //     ),
                            //     child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.center,
                            //       children: [
                            //         Image.asset(
                            //           AppImageAssets.googleImage,
                            //           height: 22,
                            //         ),
                            //         SizedBox(width: 10),
                            //         Text(
                            //           'Continue with Google',
                            //           style: AppTextStyles.title.copyWith(
                            //             fontSize: 13.sp,
                            //             color: Colors.grey,
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),

                      SizedBox(height: AppStyle.heightPercent(context, 3)),

                      // Sign Up Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.dontHaveAnAccount,
                            style: AppTextStyles.title.copyWith(
                              fontSize: 13.sp,
                              color: Colors.black,
                            ),
                          ),
                          TextButton(
                            onPressed: controller.goToSignUp,
                            child: const Text(
                              AppStrings.signUp,
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: AppColors.appColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
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

  Widget _buildUserTypeButton(
    String title,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.appColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.white : Colors.grey[600],
              size: 20,
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: AppTextStyles.body.copyWith(
                color: isSelected ? AppColors.white : Colors.grey[600],
                fontSize: 11.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleButton(
    String title,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.appColor : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.white : AppColors.appColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: AppTextStyles.body.copyWith(
                color: isSelected ? AppColors.white : AppColors.appColor,
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
