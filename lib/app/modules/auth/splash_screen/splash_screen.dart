import 'package:flutter/material.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'package:samadhantra/app/constant/app_images.dart';
import 'package:samadhantra/app/constant/app_style.dart';
import 'package:samadhantra/app/modules/auth/splash_screen/splash_screen_controller.dart';
import 'package:get/get.dart';

class SplashScreen extends StatelessWidget {
  final SplashScreenController controller = Get.put(SplashScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(AppImageAssets.splashBgImage),
              fit: BoxFit.cover, // fills screen nicely
            ),
          ),
        ),
      )
    );
  }
}
