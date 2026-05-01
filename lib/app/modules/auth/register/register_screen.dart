import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/modules/auth/register/register_controller.dart';

import '../../../constant/app_button.dart';
import '../../../constant/app_color.dart';
import '../../../constant/app_images.dart';
import '../../../constant/app_strings.dart';
import '../../../constant/app_style.dart';
import '../../../constant/app_textstyle.dart';
import '../../../constant/custom_textformfield.dart';
import '../../../constant/validators.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final RegisterController controller = Get.put(RegisterController());

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
          onTap: () => FocusScope.of(context).unfocus(),
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

                      /// 🔷 Logo + App Name Card (Same as Login)
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
                                ),
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
                                height:
                                AppStyle.heightPercent(context, 1.2)),
                            Text(
                              AppStrings.appName,
                              style: AppTextStyles.heading2.copyWith(
                                color: AppColors.appColor,
                              ),
                            ),
                            SizedBox(
                                height:
                                AppStyle.heightPercent(context, 1.2)),
                            Text(
                              "Create your account",
                              style: AppTextStyles.body.copyWith(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: AppStyle.heightPercent(context, 2)),

                      /// 🔷 Register Form Card
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
                          children: [
                            /// 🔹 Name
                            CustomTextFormField(
                              hintText: "Enter your name",
                              labelText: "Full Name",
                              prefixIcon: Icons.person_outline,
                              controller: controller.nameController,
                              textInputAction: TextInputAction.next,
                              validator: (value)=>Validators.name(value,fieldName: 'name'),
                            ),

                            SizedBox(height: AppStyle.heightPercent(context, 2)),

                            /// 🔹 Email
                            CustomTextFormField(
                              hintText: "Enter your email",
                              labelText: "Email Address",
                              prefixIcon: Icons.email_outlined,
                              controller: controller.emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              validator: (value)=>Validators.email(value),

                            ),

                            SizedBox(height: AppStyle.heightPercent(context, 2)),

                            /// 🔹 Phone
                            CustomTextFormField(
                              hintText: "Enter your phone number",
                              labelText: "Phone Number",
                              prefixIcon: Icons.phone_outlined,
                              controller: controller.phoneController,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                              validator: (value)=>Validators.mobile(value),
                            ),

                            SizedBox(height: AppStyle.heightPercent(context, 2)),

                            /// 🔹 City
                            CustomTextFormField(
                              hintText: "Enter your city",
                              labelText: "City",
                              prefixIcon: Icons.location_city_outlined,
                              controller: controller.cityController,
                              textInputAction: TextInputAction.next,
                            ),

                            SizedBox(height: AppStyle.heightPercent(context, 2)),

                            /// 🔹 State
                            CustomTextFormField(
                              hintText: "Enter your state",
                              labelText: "State",
                              prefixIcon: Icons.map_outlined,
                              controller: controller.stateController,
                              textInputAction: TextInputAction.next,
                            ),

                            SizedBox(height: AppStyle.heightPercent(context, 2)),

                            /// 🔹 Password
                            CustomTextFormField(
                              hintText: "Password",
                              labelText: "Password",
                              controller: controller.passwordController,
                              isPassword: true,
                              prefixIcon: Icons.lock_outline,
                              validator: Validators.password,
                            ),

                            SizedBox(height: AppStyle.heightPercent(context, 2)),

                            /// 🔹 Confirm Password
                            CustomTextFormField(
                              hintText: "Confirm Password",
                              labelText: "Confirm Password",
                              controller: controller.confirmPasswordController,
                              isPassword: true,
                              prefixIcon: Icons.lock_outline,
                              validator: (value) {
                                if (value != controller.passwordController.text) {
                                  return "Passwords do not match";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: AppStyle.heightPercent(context, 3)),

                      /// 🔷 Already have account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account?",
                            style: AppTextStyles.title.copyWith(
                              fontSize: 13.sp,
                              color: Colors.black,
                            ),
                          ),
                          TextButton(
                            onPressed: (){},
                            child: const Text(
                              "Login",
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
}
