import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'package:samadhantra/app/constant/app_images.dart';
import 'package:samadhantra/app/constant/app_strings.dart';
import 'package:samadhantra/app/constant/custom_textformfield.dart';
import 'package:samadhantra/app/constant/validators.dart';
import 'package:samadhantra/app/global_routes/app_routes.dart';
import 'reset_password_screen_controller.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final ResetPasswordScreenController controller = Get.put(ResetPasswordScreenController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
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
        backgroundColor: Colors.transparent,
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.1,
              vertical: size.height * 0.12,
            ),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: AlignmentGeometry.topLeft,
                    child: Text(
                      AppStrings.resetPassword,
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white
                      ),
                    ),
                  ),
                  SizedBox(height: 70.h),
                  Text(
                    AppStrings.password,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.sp,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  CustomTextFormField(
                    // keyboardType: TextInputType.emailAddress,
                    validator: Validators.password,
                    hintText: AppStrings.password,
                    controller: controller.passwordController,
                    prefixIcon: Icons.lock,
                  ),
                  SizedBox(height: 15.h),
                  Text(
                    AppStrings.confirmPassword,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.sp,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  CustomTextFormField(
                    // isPassword: true,
                    validator:(value) => Validators.confirmPassword(value,controller.passwordController.text),
                    hintText: AppStrings.confirmPassword,
                    controller: controller.confirmPasswordController,
                    prefixIcon: Icons.lock,
                  ),
                  SizedBox(height: 18.h),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      // backgroundColor: Colors.tealAccent.shade700,
                      backgroundColor: AppColors.appColor,
                      onPressed: () {
                        if (controller.formKey.currentState!.validate()) {
                          Get.offAllNamed(AppRoutes.login);
                          // controller.resetPasswordApi();
                        }
                      },
                      mini: false,
                      child: Icon(Icons.arrow_forward, color: Colors.white),
                    ),
                  ),

              ],),
            ),
          ),
        ),
      ),
    );
  }
}
