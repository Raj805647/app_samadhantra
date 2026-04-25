import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/assignment_screen/assignment_screen_controller.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/profile_screen/profile_screen_controller.dart';
import 'package:samadhantra/app/constant/token_storage_service.dart';
import 'package:samadhantra/app/data/model/user_data_model.dart';

class BottomNavController extends GetxController {
  final RxInt currentIndex = 0.obs;
  final RxBool showOptions = false.obs;
  final RxInt centerTabIndex = 0.obs;

  final profileController = Get.put(ProfileController());

  @override
  onInit()async{
    profileController.getUserProfile();
    super.onInit();
  }

  bool get isAssignmentTab => currentIndex.value == 2;

  final List<BottomNavItem> navItems = [
    BottomNavItem(label: 'Home', icon: Iconsax.home, activeIcon: Iconsax.home),
    BottomNavItem(
      label: 'Requirements',
      icon: Iconsax.document_text,
      activeIcon: Iconsax.document_text,
    ),
    BottomNavItem(
      label: 'Assignments',
      icon: Iconsax.book,
      activeIcon: Iconsax.book_1,
    ),
    BottomNavItem(
      label: 'Messages',
      icon: Iconsax.message,
      activeIcon: Iconsax.message,
    ),
    BottomNavItem(
      label: 'Profile',
      icon: Iconsax.user,
      activeIcon: Iconsax.user,
    ),
  ];

  void changeTab(int index) {
    currentIndex.value = index;

    if (index == 2) {
      showOptions.value = true; // show floating buttons
    } else {
      showOptions.value = false;
    }
  }

  void selectCenterOption(int tab) {
    centerTabIndex.value = tab;
    currentIndex.value = 2;
    showOptions.value = false; // hide after selection
  }
}

class BottomNavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  BottomNavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}
