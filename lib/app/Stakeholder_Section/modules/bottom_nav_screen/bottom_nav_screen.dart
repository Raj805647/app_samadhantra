import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/assignment_screen/assignment_screen.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/home_screen/home_screen.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/message_screen/message_screen.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/requiremnent_list_screen/requiremnent_list_screen.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/settings_screen/settings_screen.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import '../active_target_list/active_target_list_screen.dart';
import 'bottom_nav_screen_controller.dart';

class BottomNavScreen extends StatelessWidget {
  BottomNavScreen({super.key});

  final BottomNavController controller = Get.put(BottomNavController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
            () => Stack(
          children: [

            /// Screens
            IndexedStack(
              index: controller.currentIndex.value,
              children: [
                 HomeScreen(),
                 RequirementsListScreen(),

                /// CENTER TAB SCREEN SWITCH
            AssignmentsScreen(),

                 // MessagesScreen(),
                SettingsScreen(),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(() => _buildBottomNavBar()),
    );
  }

  /// ================= BOTTOM FLOATING OPTIONS =================

  Widget _circleButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              color: AppColors.appColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.appColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white),
          ),
        ],
      ),
    );
  }

  /// ================= BOTTOM NAV BAR =================

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            children: controller.navItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isActive = controller.currentIndex.value == index;

              return Expanded(
                child: GestureDetector(
                  onTap: () => controller.changeTab(index),
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.appColor.withOpacity(0.1)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isActive ? item.activeIcon : item.icon,
                          color: isActive
                              ? AppColors.appColor
                              : Colors.grey[600],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: isActive
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: isActive
                                ? AppColors.appColor
                                : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}