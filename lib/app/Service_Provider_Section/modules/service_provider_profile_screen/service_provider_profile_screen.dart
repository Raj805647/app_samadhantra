// lib/app/modules/service_provider/views/service_provider_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:samadhantra/app/Service_Provider_Section/modules/service_provider_profile_screen/service_provider_profile_screen_controller.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'package:samadhantra/app/constant/app_logout_dialog.dart';
import 'package:samadhantra/app/global_routes/app_routes.dart';

class ServiceProviderProfileScreen extends StatelessWidget {
  final ServiceProviderProfileController controller =
  Get.put(ServiceProviderProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        final profile = controller.profile;

        return SingleChildScrollView(
          child: Column(
            children: [
              // Profile Header
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue[700],
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.business,
                        size: 50,
                        color: Colors.blue[700],
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      profile['businessName'],
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      profile['email'],
                      style: TextStyle(color: Colors.white70),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildRatingBadge(profile['rating']),
                        SizedBox(width: 16),
                        _buildStatBadge(
                          icon: Icons.assignment_turned_in,
                          value: profile['completedProjects'].toString(),
                          label: 'Projects',
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Profile Actions
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Quick Info
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'About',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(profile['description']),
                            SizedBox(height: 16),
                            Row(
                              children: [
                                Icon(Iconsax.call, size: 16, color: Colors.grey[600]),
                                SizedBox(width: 8),
                                Text(profile['phone']),
                              ],
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Iconsax.calendar, size: 16, color: Colors.grey[600]),
                                SizedBox(width: 8),
                                Text('Member since ${profile['memberSince']}'),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: 16),

                    // Services
                    _buildSectionCard(
                      title: 'My Services',
                      icon: Iconsax.shop,
                      onTap: controller.manageServices,
                      items: profile['services'],
                    ),

                    // Menu Items
                    _buildMenuCard(),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildRatingBadge(double rating) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.amber[700],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(Icons.star, size: 16, color: Colors.white),
          SizedBox(width: 4),
          Text(
            rating.toString(),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildStatBadge({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.white),
          SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    List<String>? items,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }

  Widget _buildMenuCard() {
    return Card(
      child: Column(
        children: [
          _buildMenuItem(
            icon: Iconsax.edit,
            title: 'Edit Profile',
            onTap: controller.editProfile,
          ),
          Divider(height: 0),
          _buildMenuItem(
            icon: Iconsax.briefcase,
            title: 'Portfolio',
            onTap: controller.viewPortfolio,
          ),
          Divider(height: 0),
          _buildMenuItem(
            icon: Iconsax.note_text,
            title: 'Certifications',
            onTap: controller.viewCertifications,
          ),
          Divider(height: 0),
          _buildMenuItem(
            icon: Iconsax.wallet,
            title: 'Earnings & Payments',
            onTap: controller.viewEarnings,
          ),
          Divider(height: 0),
          _buildMenuItem(
            icon: Iconsax.star,
            title: 'Reviews & Ratings',
            onTap: controller.viewReviews,
          ),
          Divider(height: 0),
          _buildMenuItem(
            icon: Iconsax.setting,
            title: 'Settings',
            onTap: () => Get.toNamed('/service-provider/settings'),
          ),
          Divider(height: 0),
          _buildMenuItem(
            icon: Iconsax.logout,
            title: 'Logout',
            onTap: (){
                showLogoutDialog(onLogout: (){
                  Get.offAllNamed(AppRoutes.login);
                } );

            },
            color: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.grey[700]),
      title: Text(title, style: TextStyle(color: color)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: color),
      onTap: onTap,
    );
  }
}