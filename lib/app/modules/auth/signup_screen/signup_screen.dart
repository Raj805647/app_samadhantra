import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/constant/app_button.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'package:samadhantra/app/constant/app_images.dart';
import 'package:samadhantra/app/constant/app_strings.dart';
import 'package:samadhantra/app/constant/app_style.dart';
import 'package:samadhantra/app/constant/app_textstyle.dart';
import 'package:samadhantra/app/constant/custom_textformfield.dart';
import 'package:samadhantra/app/constant/validators.dart';
import 'signup_screen_controller.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final SignupScreenController controller = Get.put(SignupScreenController());

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
                              style: AppTextStyles.heading2.copyWith(color: AppColors.appColor),
                            ),
                            SizedBox(
                              height: AppStyle.heightPercent(context, 1.2),
                            ),
                            Text(
                              AppStrings.createYourAccount,
                              style: AppTextStyles.body.copyWith(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: AppStyle.heightPercent(context, 3)),

                      // Signup Form
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
                              AppStrings.signUp,
                              style: AppTextStyles.heading1.copyWith(color: AppColors.appColor),
                            ),
                            SizedBox(height: AppStyle.heightPercent(context, 2)),
                            Text(
                              AppStrings.fillInYourDetailsToGetStarted,
                              style: AppTextStyles.body.copyWith(color: Colors.grey),
                            ),

                            SizedBox(height: AppStyle.heightPercent(context, 2)),

                            // Full Name Field
                            CustomTextFormField(
                              hintText: "Enter your full name",
                              labelText: "Full Name",
                              prefixIcon: Icons.person_outline,
                              controller: controller.fullNameController,
                              keyboardType: TextInputType.name,
                              validator: controller.validateFullName,
                              textInputAction: TextInputAction.next,
                            ),

                            SizedBox(height: AppStyle.heightPercent(context, 2)),

                            // Email Field
                            CustomTextFormField(
                              hintText: "Enter your email",
                              labelText: "Email Address",
                              prefixIcon: Icons.email_outlined,
                              controller: controller.emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: controller.validateEmail,
                              textInputAction: TextInputAction.next,
                            ),

                            SizedBox(height: AppStyle.heightPercent(context, 2)),

                            // Phone Number Field
                            CustomTextFormField(
                              hintText: "Enter your phone number",
                              labelText: "Phone Number",
                              prefixIcon: Icons.phone_outlined,
                              controller: controller.phoneController,
                              keyboardType: TextInputType.phone,
                              validator: controller.validatePhone,
                              textInputAction: TextInputAction.next,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              maxLength: 10,
                            ),

                            // SizedBox(height: AppStyle.heightPercent(context, 2)),
                            // PlaceSearchWidget(
                            //   controller: controller,
                            //   validator: Validators.requiredField,
                            // ),
                            SizedBox(height: AppStyle.heightPercent(context, 2)),
                            CustomTextFormField(
                              hintText: 'Password',
                              labelText: 'Password',
                              controller: controller.passwordController,
                              isPassword: true,
                              prefixIcon: Icons.lock_outline,
                              validator: Validators.password,
                            ),

                            SizedBox(height: AppStyle.heightPercent(context, 2)),

                            CustomTextFormField(
                              hintText: 'Confirm Password',
                              labelText: 'Confirm Password',
                              controller: controller.confirmPasswordController,
                              isPassword: true,
                              prefixIcon: Icons.lock_outline,
                              validator:(value)=> Validators.confirmPassword(value, controller.passwordController.text),
                            ),

                            // Confirm Password Field

                            SizedBox(height: AppStyle.heightPercent(context, 2)),

                            // Terms and Conditions
                            Obx(
                              () => Row(
                                children: [
                                  Checkbox(
                                    value: controller.acceptTerms.value,
                                    onChanged: (value) =>
                                        controller.acceptTerms.value =
                                            value ?? false,
                                    activeColor: AppColors.appColor,
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () => controller.toggleTerms(),
                                      child: RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                          children: [
                                            const TextSpan(
                                              text: AppStrings.iAgreeToThe,
                                            ),
                                            TextSpan(
                                              text: AppStrings.termsAndConditions,
                                              style: TextStyle(
                                                color: AppColors.appColor,
                                                fontWeight: FontWeight.w600,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                            const TextSpan(text: AppStrings.and),
                                            TextSpan(
                                              text: AppStrings.privacyPolicy,
                                              style: TextStyle(
                                                color: AppColors.appColor,
                                                fontWeight: FontWeight.w600,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: AppStyle.heightPercent(context, 2)),

                            // Signup Button
                            Obx(
                                  () => AppButton(
                                title: AppStrings.signUp,
                                isLoading: controller.isLoading.value,
                                onPressed: controller.signup,
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
                            //       mainAxisAlignment:
                            //       MainAxisAlignment.center,
                            //       children: [
                            //         Image.asset(AppImageAssets.googleImage,height: 22,),
                            //         SizedBox(width: 10),
                            //         Text(
                            //           'Continue with Google',
                            //           style: TextStyle(
                            //             fontSize: 14.5,
                            //             fontWeight: FontWeight.w500,
                            //             color: Colors.black87,
                            //           ),
                            //         ),
                            //       ],
                            //     ),
                            //   ),
                            // ),

                          ],
                        ),
                      ),

                      SizedBox(height: AppStyle.heightPercent(context, 2)),

                      // Login Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.alreadyHaveAnAccount,
                            style: TextStyle(
                              color: AppColors.black,
                            ),
                          ),
                          TextButton(
                            onPressed: () => Get.back(),
                            child: const Text(
                              AppStrings.login,
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: AppColors.appColor,
                                fontWeight: FontWeight.w600,
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
              style: AppTextStyles.body.copyWith(color: isSelected ? AppColors.white : Colors.grey[600],fontSize: 11.sp),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
