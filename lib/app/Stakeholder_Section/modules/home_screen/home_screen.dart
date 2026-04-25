import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/bottom_nav_screen/bottom_nav_screen_controller.dart';
import 'package:samadhantra/app/constant/app_button.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'package:samadhantra/app/constant/app_style.dart';
import 'package:samadhantra/app/constant/app_textstyle.dart';
import 'package:samadhantra/app/constant/custom_appbar.dart';
import 'package:samadhantra/app/constant/token_storage_service.dart';
import 'package:samadhantra/app/data/model/stake_requirement_model.dart';
import 'package:samadhantra/app/data/model/user_data_model.dart';
import 'package:samadhantra/app/global_routes/app_routes.dart';
import '../../../data/model/announcements_acitve_list_response.dart';
import 'home_screen_controller.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final HomeScreenController controller = Get.put(HomeScreenController());

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await _showExitDialog(context);
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Dashboard",
          isBackButton: false,
          actions: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: IconButton(
                onPressed: () => Get.toNamed(AppRoutes.notificationScreen),
                icon: const Icon(
                  Iconsax.notification,
                  size: 18,
                  color: AppColors.white,
                ),
                splashRadius: 22,
              ),
            ),
            SizedBox(width: 10),
          ],
        ),
        backgroundColor: Colors.grey[50],
        body: RefreshIndicator(
          onRefresh: () => controller.loadDashboardData(),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildStatsCards(context),
                const SizedBox(height: 24),

                AppButton(
                  title: "Post New Requirement",
                  icon: Iconsax.add,
                  onPressed: () {
                    controller.navigateToPostRequirement();
                  },
                ),

                const SizedBox(height: 24),
                _buildRecentRequirements(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _showExitDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Exit App"),
            content: const Text("Are you sure you want to exit?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("No"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Yes"),
              ),
            ],
          ),
        ) ??
        false;
  }

  Widget _buildStatsCards(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            title: 'Active Projects',
            value: controller.activeProjects.value.toString(),
            icon: Icons.rocket_launch,
            color: Colors.green,
            context: context,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            title: 'Completed',
            value: controller.completedProjects.value.toString(),
            icon: Icons.check_circle,
            color: Colors.blue,
            context: context,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            title: 'In Review',
            value: controller.inReviewProjects.value.toString(),
            icon: Icons.reviews,
            color: Colors.orange,
            context: context,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required BuildContext context,
  }) {
    return Container(
      height: AppStyle.heightPercent(context, 18),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 18.h),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyle(fontSize: 10.sp, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildPostRequirementButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: controller.navigateToPostRequirement,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.appColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 5,
          shadowColor: AppColors.appColor.withOpacity(0.3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add, size: 22),
            const SizedBox(width: 10),
            Text(
              'Post New Requirement',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildRecentRequirements() {
    return Obx(() {
      if (controller.isLoading.value) {
        return Center(child: CircularProgressIndicator());
      }
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          children: [
            controller.recentRequirements
                    .where((req) => req.id != controller.userid.value)
                    .take(controller.recentRequirements.length)
                    .isNotEmpty
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Recent Requirements',
                        style: AppTextStyles.title.copyWith(fontSize: 16.sp),
                      ),
                      TextButton(
                        onPressed: () =>
                            Get.find<BottomNavController>().changeTab(1),
                        child: Text(
                          'View All',
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.appColor,
                            fontSize: 12.sp,
                          ),
                        ),
                      ),
                    ],
                  )
                : SizedBox.shrink(),
            SizedBox(height: 16),
            Column(
              children: controller.recentRequirements
                  .where(
                    (requirement) =>
                        requirement.requirementUserId !=
                        controller.userid.value,
                  )
                  .take(3)
                  .map((requirement) => _buildRequirementCard(requirement))
                  .toList(),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildRequirementCard(AnnouncementData requirement) {
    controller.reqId.value = requirement.requirementId ?? '';
    print('adsbfhbsdabhfbsda');
    print(requirement.id);
    print(controller.userid);
    return GestureDetector(
      onTap: () => Get.toNamed(
        '/requirementDetails',
        arguments: requirement.requirementId,
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              /// Background gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.white, Colors.grey.shade50],
                  ),
                ),
              ),

              /// Main content
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade200, width: 1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 🔹 TITLE + STATUS + ICON
                    Row(
                      children: [
                        /// Category icon
                        Container(
                          padding: const EdgeInsets.all(8),
                          margin: const EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                            color: statusColor(
                              requirement.isActive ?? false,
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            _getCategoryIcon(
                              requirement.requirementCategory ?? '',
                            ),
                            size: 18,
                            color: statusColor(requirement.isActive ?? false),
                          ),
                        ),

                        /// Title
                        Expanded(
                          child: Text(
                            requirement.requirementCategory ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                              letterSpacing: 0.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                        /// Status badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor(
                              requirement.isActive ?? false,
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: statusColor(
                                requirement.isActive ?? false,
                              ).withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: statusColor(
                                    requirement.isActive ?? false,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                requirement.isActive! ? 'Active' : 'Inactive',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: statusColor(
                                    requirement.isActive ?? false,
                                  ),
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    /// 🔹 DESCRIPTION with icon
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.description_outlined,
                          size: 16,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            requirement.problemDescription ??
                                "No description provided",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade700,
                              height: 1.4,
                              letterSpacing: 0.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    /// 🔹 FOOTER INFO with better visual hierarchy
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          /// Location
                          Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              requirement.preferredLocation!.isEmpty
                                  ? 'Bhopal'
                                  : requirement.preferredLocation ?? '',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              /// Optional: Decorative corner accent
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        statusColor(
                          requirement.isActive ?? false,
                        ).withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(40),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper function to get category icon
  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'plumbing':
        return Icons.plumbing;
      case 'electrical':
        return Icons.electrical_services;
      case 'cleaning':
        return Icons.cleaning_services;
      case 'painting':
        return Icons.format_paint;
      case 'carpentry':
        return Icons.handyman;
      case 'moving':
        return Icons.local_shipping;
      default:
        return Icons.category_outlined;
    }
  }

  Color statusColor(bool isActive) {
    return isActive ? Colors.green : Colors.grey;
  }
}
