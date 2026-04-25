import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/constant/app_button.dart';
import 'package:samadhantra/app/constant/app_color.dart';

import 'onboarding_model.dart';
import 'onboarding_screen_controller.dart';


class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});

  final OnboardingController controller = Get.put(OnboardingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Page View
            PageView.builder(
              controller: controller.pageController,
              onPageChanged: controller.updatePageIndicator,
              itemCount: controller.onboardingPages.length,
              itemBuilder: (context, index) {
                final page = controller.onboardingPages[index];
                return _buildPageContent(page, index);
              },
            ),

            // Skip Button (Top Right)
            Positioned(
              top: 20,
              right: 20,
              child: Obx(() => AnimatedOpacity(
                opacity: controller.currentPageIndex.value < 2 ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: TextButton(
                  onPressed: controller.skipPage,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.appColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                  ),
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      // fontFamily: AppFonts.fontFamily,
                    ),
                  ),
                ),
              )),
            ),

            // Bottom Section (Dots + Button)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    // Progress Dots
                    Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        controller.onboardingPages.length,
                            (index) => _buildDotIndicator(
                          index,
                          controller.currentPageIndex.value,
                        ),
                      ),
                    )),

                     SizedBox(height: 25.h),

                    // Next/Get Started Button
                    Obx(() => _buildActionButton(controller.currentPageIndex.value)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageContent(OnboardingModel page, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated Image Container
          Container(
            height: Get.height * 0.4,
            margin: const EdgeInsets.only(bottom: 40),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Container(
                key: ValueKey(index),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.appColor.withOpacity(0.2),
                      blurRadius: 30,
                      spreadRadius: 5,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    page.image,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Container(
                      decoration: BoxDecoration(
                        color: AppColors.appColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.school,
                        size: 120,
                        color: AppColors.appColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Title with Animation
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Container(
              key: ValueKey('title_$index'),
              margin: const EdgeInsets.only(bottom: 16),
              child: Text(
                page.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                  height: 1.2,
                ),
              ),
            ),
          ),

          // Description with Animation
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Container(
              key: ValueKey('desc_$index'),
              child: Text(
                page.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
            ),
          ),

          // Decorative Elements
          const SizedBox(height: 40),
          // _buildDecorativeElements(index),
        ],
      ),
    );
  }

  Widget _buildDotIndicator(int index, int currentIndex) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: currentIndex == index ? 32 : 8,
      decoration: BoxDecoration(
        color: currentIndex == index
            ? AppColors.appColor
            : AppColors.appColor.withOpacity(0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildActionButton(int currentIndex) {
    return AppButton(title: currentIndex == 2 ? 'Get Started' : 'Next',onPressed: controller.nextPage,);
    //   SizedBox(
    //   width: double.infinity,
    //   child: ElevatedButton(
    //     onPressed: controller.nextPage,
    //     style: ElevatedButton.styleFrom(
    //       backgroundColor: AppColors.appColor,
    //       foregroundColor: Colors.white,
    //       padding: const EdgeInsets.symmetric(vertical: 18),
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(15),
    //       ),
    //       elevation: 5,
    //       shadowColor: AppColors.appColor.withOpacity(0.4),
    //     ),
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       children: [
    //         Text(
    //           currentIndex == 2 ? 'Get Started' : 'Next',
    //           style: TextStyle(
    //             fontSize: 18,
    //             fontWeight: FontWeight.w600,
    //           ),
    //         ),
    //         if (currentIndex < 2) ...[
    //           const SizedBox(width: 8),
    //           Icon(
    //             Icons.arrow_forward_ios,
    //             size: 18,
    //             color: Colors.white,
    //           ),
    //         ] else ...[
    //           const SizedBox(width: 8),
    //           Icon(
    //             Icons.check_circle_outline,
    //             size: 20,
    //             color: Colors.white,
    //           ),
    //         ],
    //       ],
    //     ),
    //   ),
    // );
  }
}