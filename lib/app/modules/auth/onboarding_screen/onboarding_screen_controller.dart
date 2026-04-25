import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/constant/app_images.dart';
import 'package:samadhantra/app/data/services/shared_pref_service.dart';
import 'package:samadhantra/app/global_routes/app_routes.dart';
import 'onboarding_model.dart';

class OnboardingController extends GetxController {

  final pageController = PageController();
  Rx<int> currentPageIndex = 0.obs;

  // Update current index when page scrolls
  void updatePageIndicator(int index) {
    currentPageIndex.value = index;
  }

  // Jump to the specific dot selected page
  void dotNavigationClick(int index) {
    currentPageIndex.value = index;
    pageController.jumpToPage(index);
  }

  // Update current index and jump to next page
  void nextPage() {
    if (currentPageIndex.value == 2) {
      // If last page, navigate to main app
      PrefService.setNotFirstTime();
      Get.offAllNamed(AppRoutes.login);
    } else {
      int page = currentPageIndex.value + 1;
      pageController.jumpToPage(page);
    }
  }

  // Skip all onboarding screens
  void skipPage() {
    currentPageIndex.value = 2;
    PrefService.setNotFirstTime();
    Get.offAllNamed(AppRoutes.login);
  }

  // List of onboarding pages
  final List<OnboardingModel> onboardingPages = [
    OnboardingModel(
      image: AppImageAssets.onBoarding1Image,
      title: 'Welcome to Samadhantra',
      description: 'Your complete solution for all your needs with seamless integration.',
    ),
    OnboardingModel(
      image: AppImageAssets.onboarding2Image,
      title: 'Smart Solutions',
      description: 'Experience intelligent features designed to simplify your daily tasks.',
    ),
    OnboardingModel(
      image: AppImageAssets.onboarding3Image,
      title: 'Get Started',
      description: 'Join thousands of users who trust Samadhantra for their requirements.',
    ),
  ];

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}