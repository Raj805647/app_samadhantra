import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/profile_screen/profile_screen_controller.dart';
import 'package:samadhantra/app/constant/app_circularprogress_indicator.dart';
import 'package:samadhantra/app/global_routes/app_routes.dart';

import '../../../constant/app_color.dart';
import '../../../constant/custom_appbar.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final controller = Get.find<ProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: "Profile",
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: AppColors.white),
            onPressed: () {
              Get.toNamed(AppRoutes.updateProfileScreen, arguments: controller.profileData.value);
              controller.getUserProfile();
              },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) return Center(child: CustomProgressIndicator());
        return SingleChildScrollView(
          child: Column(
            children: [
              // Profile Header with Photo
              _buildProfileHeader(),

              // Main Content
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // About Section
                    _buildSectionTitle("About Me"),
                    _buildInfoCard(
                      icon: Icons.person_outline,
                      title: "About Yourself",
                      content:
                          controller.profileData.value.aboutYourself ??
                          "Not provided",
                    ),

                    // Contact Information
                    _buildSectionTitle("Contact Information"),
                    _buildContactInfo(),

                    // Professional Details
                    _buildSectionTitle("Professional Details"),
                    _buildProfessionalInfo(),

                    // Educational Background
                    _buildSectionTitle("Education"),
                    _buildEducationInfo(),

                    // Skills & Experience
                    _buildSectionTitle("Skills & Experience"),
                    _buildSkillsExperience(),

                    // Categories & Preferences
                    _buildSectionTitle("Categories & Preferences"),
                    _buildCategoriesInfo(),

                    const SizedBox(height: 20),

                    // // Account Status
                    // _buildAccountStatus(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Profile Photo
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.appColor, width: 3),
              boxShadow: [
                BoxShadow(
                  color: AppColors.appColor.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Obx(()=> ClipOval(
                child: controller.profileData.value.profilePhotoUrl != null
                    ? Image.network(
                        'https://api.samadhantra.com${controller.profileData.value.profilePhotoUrl}',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildProfilePlaceholder();
                        },
                      )
                    : _buildProfilePlaceholder(),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Name
          Text(
            controller.profileData.value.fullName ?? "User Name",
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),

          // User Type Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.appColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getUserTypeIcon(controller.profileData.value.userType),
                  size: 16,
                  color: AppColors.appColor,
                ),
                const SizedBox(width: 6),
                Text(
                  controller.profileData.value.userType
                          ?.toString()
                          .toUpperCase() ??
                      "USER",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.appColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildProfilePlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Icon(Icons.person, size: 50, color: Colors.grey[400]),
      ),
    );
  }

  Widget _buildVerificationBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.orange[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Profile Not Verified",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.orange[700],
                  ),
                ),
                Text(
                  "Verify your profile to unlock all features",
                  style: TextStyle(fontSize: 12, color: Colors.orange[600]),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              // Navigate to verification screen
            },
            style: TextButton.styleFrom(foregroundColor: Colors.orange[700]),
            child: const Text("Verify Now"),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: AppColors.appColor,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.appColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.appColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildContactRow(
            Icons.email_outlined,
            "Email",
            controller.profileData.value.email,
          ),
          _buildDivider(),
          _buildContactRow(
            Icons.phone_outlined,
            "Phone",
            controller.profileData.value.phoneNumber,
          ),
          _buildDivider(),
          _buildContactRow(
            Icons.location_on_outlined,
            "Address",
            controller.profileData.value.address,
          ),
          _buildDivider(),
          _buildContactRow(
            Icons.location_city,
            "City",
            "${controller.profileData.value.city}, ${controller.profileData.value.state}",
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String label, String? value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 12),
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
        ),
        Expanded(
          child: Text(
            value ?? "Not provided",
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Divider(color: Colors.grey[200]),
    );
  }

  Widget _buildProfessionalInfo() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInfoRow("Objective", controller.profileData.value.objective),
          _buildDivider(),
          _buildInfoRow(
            "Need Description",
            controller.profileData.value.describeYourNeed,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
        ),
        Expanded(
          child: Text(
            value ?? "Not provided",
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  Widget _buildEducationInfo() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildEducationRow(
            Icons.school_outlined,
            "College",
            controller.profileData.value.collegeName,
          ),
          _buildDivider(),
          _buildEducationRow(
            Icons.menu_book_outlined,
            "Degree",
            controller.profileData.value.degree,
          ),
          _buildDivider(),
          _buildEducationRow(
            Icons.auto_awesome_outlined,
            "Specialization",
            controller.profileData.value.specialization,
          ),
        ],
      ),
    );
  }

  Widget _buildEducationRow(IconData icon, String label, String? value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.appColor),
        const SizedBox(width: 12),
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: TextStyle(fontSize: 13, color: Colors.grey[600]),
          ),
        ),
        Expanded(
          child: Text(
            value ?? "Not provided",
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsExperience() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Key Skills",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _buildSkillChips(controller.profileData.value.keySkills),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const SizedBox(height: 16),
          const Text(
            "Experience & Projects",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            controller.profileData.value.experienceProjects ??
                "No experience provided",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSkillChips(String? skillsString) {
    if (skillsString == null || skillsString.isEmpty) {
      return [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            "No skills listed",
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ),
      ];
    }

    return skillsString.split(',').map((skill) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.appColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.appColor.withOpacity(0.2)),
        ),
        child: Text(
          skill.trim(),
          style: TextStyle(
            fontSize: 12,
            color: AppColors.appColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }).toList();
  }

  Widget _buildCategoriesInfo() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCategoryChips(
            "Categories",
            controller.profileData.value.category,
          ),
          const SizedBox(height: 16),
          _buildCategoryChips(
            "Sub Categories",
            controller.profileData.value.subCategory,
          ),
          const SizedBox(height: 16),
          _buildPreferenceRow(),
        ],
      ),
    );
  }

  Widget _buildCategoryChips(String title, List? items) {
    if (items == null || items.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items.map((item) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.appColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.appColor.withOpacity(0.2)),
              ),
              child: Text(
                item.toString(),
                style: TextStyle(fontSize: 12, color: AppColors.appColor),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPreferenceRow() {
    return Row(
      children: [
        Icon(Icons.work_outline, size: 18, color: AppColors.appColor),
        const SizedBox(width: 8),
        Text(
          "Preferred Mode",
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            controller.profileData.value.preferredMode
                    ?.toString()
                    .toUpperCase() ??
                "NOT SPECIFIED",
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.green[700],
            ),
          ),
        ),
      ],
    );
  }

  IconData _getUserTypeIcon(String? userType) {
    switch (userType?.toLowerCase()) {
      case 'student':
        return Icons.school;
      case 'professional':
        return Icons.work;
      case 'business':
        return Icons.business;
      default:
        return Icons.person;
    }
  }

}
