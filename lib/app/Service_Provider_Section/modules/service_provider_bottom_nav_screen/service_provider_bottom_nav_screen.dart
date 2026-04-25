import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:samadhantra/app/Service_Provider_Section/modules/service_provider_assignment_screen/service_provider_assignment_screen.dart';
import 'package:samadhantra/app/Service_Provider_Section/modules/service_provider_bottom_nav_screen/service_provider_bottom_nav_screen_controller.dart';
import 'package:samadhantra/app/Service_Provider_Section/modules/service_provider_home_screen/service_provider_home_screen.dart';
import 'package:samadhantra/app/Service_Provider_Section/modules/service_provider_opportunities_screen/service_provider_opportunities_screen.dart';
import 'package:samadhantra/app/Service_Provider_Section/modules/service_provider_profile_screen/service_provider_profile_screen.dart';
import 'package:samadhantra/app/Service_Provider_Section/modules/service_provider_proposal_screen/service_provider_proposal_screen.dart';
import 'package:samadhantra/app/constant/app_color.dart';

class ServiceProviderMainScreen extends StatelessWidget {
  ServiceProviderMainScreen({super.key});

  final ServiceProviderMainController controller =
  Get.put(ServiceProviderMainController());

  final List<Widget> _screens = [
    ServiceProviderHomeScreen(),
    ServiceProviderOpportunitiesScreen(),
    ServiceProviderProposalsScreen(),
    ServiceProviderAssignmentsScreen(),
    ServiceProviderProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Obx(() => _screens[controller.currentIndex.value]),
      bottomNavigationBar: Obx(() => _buildCurvedBottomBar()),
    );
  }

  Widget _buildCurvedBottomBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.white, // ✅ IMPORTANT
          selectedFontSize: 10.sp,
          currentIndex: controller.currentIndex.value,
          onTap: controller.changeTabIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.appColor,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Iconsax.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.search_normal),
              label: 'Opportunities',
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.document_text),
              label: 'Proposals',
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.task_square),
              label: 'Assignments',
            ),
            BottomNavigationBarItem(
              icon: Icon(Iconsax.user),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

}
