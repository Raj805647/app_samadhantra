// lib/app/modules/service_provider/views/service_provider_home_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:samadhantra/app/Service_Provider_Section/modules/service_provider_bottom_nav_screen/service_provider_bottom_nav_screen_controller.dart';
import 'package:samadhantra/app/Service_Provider_Section/modules/service_provider_home_screen/service_provider_home_screen_controller.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'package:samadhantra/app/constant/custom_appbar.dart';
import 'package:samadhantra/app/global_routes/app_routes.dart';

class ServiceProviderHomeScreen extends StatelessWidget {
  final ServiceProviderHomeController controller =
  Get.put(ServiceProviderHomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: "Dashboard",actions: [
        IconButton(
              icon: Icon(Iconsax.notification,color: AppColors.white,),
              onPressed: () => Get.toNamed(AppRoutes.serviceProviderNotifications),
            ),
      ],isBackButton: false,),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats Section
            _buildStatsSection(),
            SizedBox(height: 24),

            // Quick Actions
            _buildQuickActions(),
            SizedBox(height: 24),

            // Recent Opportunities
            _buildRecentOpportunities(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Iconsax.document,
            value: controller.activeProposals.value.toString(),
            label: 'Active Proposals',
            color: Colors.blue,
          ),
          _buildStatItem(
            icon: Iconsax.task_square,
            value: controller.activeAssignments.value.toString(),
            label: 'Assignments',
            color: Colors.green,
          ),
          _buildStatItem(
            icon: Iconsax.coin,
            value: '₹${controller.totalEarnings.value}',
            label: 'Earnings',
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 30),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                icon: Iconsax.search_favorite_14,
                label: 'Browse Opportunities',
                onTap: () => Get.find<ServiceProviderMainController>().changeTabIndex(1),
                color: Colors.blue,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                icon: Iconsax.task_square,
                label: 'My Assignments',
                onTap: () => Get.find<ServiceProviderMainController>().changeTabIndex(3),
                color: Colors.green,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentOpportunities() {
    return Container(
      padding: const EdgeInsets.all(16),
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
          /// -------- Header --------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Opportunities',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                onPressed: () => Get
                    .find<ServiceProviderMainController>()
                    .changeTabIndex(1),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.appColor,
                ),
                child: const Text(
                  'View All',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// -------- Cards --------
          Obx(
                () => Column(
              children: List.generate(
                controller.recentOpportunities.length,
                    (index) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _buildOpportunityCard(
                    controller.recentOpportunities[index],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildOpportunityCard(Map<String, dynamic> opportunity) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.business_center, color: Colors.blue),
        ),
        title: Text(
          opportunity['title'],
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text('Budget: ${opportunity['budget']}'),
            Text('Category: ${opportunity['category']}'),
            Text('Posted: ${opportunity['posted']}'),
          ],
        ),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => Get.toNamed(
          AppRoutes.serviceProviderRequirementDetails,
          arguments: opportunity['id'],
        ),
      ),
    );
  }
}