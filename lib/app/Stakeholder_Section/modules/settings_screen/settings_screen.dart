// lib/app/modules/service_provider/views/service_provider_settings_screen.dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/settings_screen/settings_controller.dart';
import 'package:samadhantra/app/constant/custom_appbar.dart';
import 'package:samadhantra/app/constant/custom_textformfield.dart';
import 'package:samadhantra/app/constant/token_storage_service.dart';
import 'package:samadhantra/app/data/api_service.dart';
import 'package:samadhantra/app/global_routes/app_routes.dart';
import '../../../../firebase_service.dart';
import '../../../Service_Provider_Section/modules/service_provider_bottom_nav_screen/service_provider_bottom_nav_screen.dart';
import '../../../constant/app_color.dart';
import '../../../constant/app_logout_dialog.dart';

class SettingsScreen extends StatelessWidget {
  final controller = Get.put(SettingsController());
  SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: () => controller.profileController.getUserProfile(),
        child: SingleChildScrollView(
          child: Obx(
            () => Column(
              children: [
                // Profile Header Section
                _buildProfileHeader(context),

                // Settings Sections
                _buildSection(
                  context,
                  title: 'Account',
                  icon: Icons.person_outline,
                  children: [
                    _buildSettingItem(
                      context,
                      icon: Icons.person_outline,
                      title: 'Profile Settings',
                      subtitle: 'Update your profile information',
                      onTap: () => Get.toNamed(AppRoutes.profileScreen),
                      trailing: Icons.arrow_forward_ios,
                    ),
                    _buildSettingItem(
                      context,
                      icon: Icons.lock_outline,
                      title: 'Change Password',
                      subtitle: 'Update your password',
                      onTap: () => _changePassword(),
                      trailing: Icons.arrow_forward_ios,
                    ),
                    _buildSettingItem(
                      context,
                      icon: Icons.post_add_outlined,
                      title: 'My Requirements',
                      subtitle: 'View your posted requirements',
                      onTap: () => Get.toNamed(AppRoutes.myRequirements),
                      trailing: Icons.arrow_forward_ios,
                    ),
                    _buildSettingItem(
                      context,
                      icon: Icons.gavel_outlined,
                      title: 'My Bids',
                      subtitle: 'View & manage your submitted bids',
                      onTap: () => Get.toNamed(AppRoutes.messageScreen),
                      trailing: Icons.arrow_forward_ios,
                    )
                  ],
                ),

                _buildSection(
                  context,
                  title: 'Preferences',
                  icon: Icons.tune,
                  children: [
                    _buildSettingItem(
                      context,
                      icon: Icons.language,
                      title: 'Language',
                      subtitle: controller.preferredLanguage.value,
                      // onTap: () => _selectLanguage(),
                      onTap: () => _rateApp(),
                      trailing: Icons.arrow_drop_down,
                      showTrailingAsIcon: true,
                    ),
                    _buildSettingItem(
                      context,
                      icon: Icons.article_outlined,
                      title: 'Blogs',
                      subtitle: 'Read latest AI & tech blogs',
                      onTap: () => Get.toNamed(AppRoutes.blogScreen),
                      trailing: Icons.arrow_forward_ios,
                    ),
                    _buildSettingItem(
                      context,
                      icon: Icons.event_outlined,
                      title: 'Events',
                      subtitle: 'Explore upcoming events',
                      onTap: () => Get.toNamed(AppRoutes.eventScreen),
                      trailing: Icons.arrow_forward_ios,
                    ),
                  ],
                ),

                _buildSection(
                  context,
                  title: 'Privacy & Security',
                  icon: Icons.security_outlined,
                  children: [
                    _buildSettingItem(
                      context,
                      icon: Icons.help_outline,
                      title: 'FAQ',
                      subtitle: 'Frequently asked questions',
                      onTap: () => Get.toNamed(AppRoutes.faqScreen),
                      trailing: Icons.arrow_forward_ios,
                    ),
                    _buildSettingItem(
                      context,
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy Policy',
                      subtitle: 'View our privacy policy',
                      onTap: () => Get.toNamed(AppRoutes.privacyPolicyScreen),
                      trailing: Icons.arrow_forward_ios,
                    ),
                    _buildSettingItem(
                      context,
                      icon: Icons.description_outlined,
                      title: 'Terms of Service',
                      subtitle: 'View terms and conditions',
                      onTap: () => Get.toNamed(AppRoutes.termsConditionsScreen),
                      trailing: Icons.arrow_forward_ios,
                    ),
                  ],
                ),

                _buildSection(
                  context,
                  title: 'Support',
                  icon: Icons.support_agent,
                  children: [
                    _buildSettingItem(
                      context,
                      icon: Icons.headset_mic,
                      title: 'Help & Support',
                      subtitle: 'Get help and contact support',
                      onTap: ()=> _showSupportOptions(context),
                      trailing: Icons.arrow_forward_ios,
                    ),
                    _buildSettingItem(
                      context,
                      icon: Icons.feedback_outlined,
                      title: 'Send Feedback',
                      subtitle: 'Share your feedback with us',
                      onTap: () => _sendFeedback(),
                      trailing: Icons.arrow_forward_ios,
                    ),
                    _buildSettingItem(
                      context,
                      icon: Icons.share_outlined,
                      title: 'Share App',
                      subtitle: 'Share with friends and colleagues',
                      onTap: () => controller.shareAppUrl(),
                      trailing: Icons.arrow_forward_ios,
                    ),
                    _buildSettingItem(
                      context,
                      icon: Icons.star_outline,
                      title: 'Rate App',
                      subtitle: 'Rate us on app store',
                      onTap: () => controller.openPlayStoreForRating(),
                      trailing: Icons.arrow_forward_ios,
                    ),
                  ],
                ),

                // Logout Button
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => showLogoutDialog(
                      onLogout: () async {
                        TokenService.clearAll();
                        controller.deleteGetDeviceToken();
                        Get.offAllNamed(AppRoutes.login);
                      },
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade50,
                      foregroundColor: Colors.red.shade700,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.red.shade200),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.logout, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Log Out',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Version Info
                Padding(
                  padding: EdgeInsets.only(bottom: 24),
                  child: Text(
                    'Version 1.0.0',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSupportOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Email Support'),
                subtitle: const Text('support@samadhantra.com'),
                onTap: () {
                  Navigator.pop(context);
                  controller.contactSupportByEmail();
                },
              ),
              ListTile(
                leading: const Icon(Icons.phone),
                title: const Text('Call Support'),
                subtitle: const Text('+91 9644553196'),
                onTap: () {
                  Navigator.pop(context);
                  controller.contactSupportByPhone();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.appColor, AppColors.appColor2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 55,
            backgroundColor: Colors.white,
            backgroundImage:
                controller
                        .profileController
                        .profileData
                        .value
                        .profilePhotoUrl !=
                    null
                ? NetworkImage(
                    'https://api.samadhantra.com${controller.profileController.profileData.value.profilePhotoUrl}',
                  )
                : null,
            child:
                controller
                        .profileController
                        .profileData
                        .value
                        .profilePhotoUrl ==
                    null
                ? Icon(Icons.person, size: 48, color: theme.primaryColor)
                : SizedBox.shrink(),
          ),
          SizedBox(height: 12),
          Text(
            controller.profileController.profileData.value.fullName ?? '',
            style: theme.textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            controller.profileController.profileData.value.email ?? '',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    final theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.only(top: 16, left: 16, right: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                Icon(icon, size: 20, color: theme.primaryColor),
                SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.textTheme.titleMedium?.color,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, indent: 20, endIndent: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    IconData? trailing,
    bool showTrailingAsIcon = false,
  }) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: theme.primaryColor),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (subtitle.isNotEmpty)
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.textTheme.bodySmall?.color?.withOpacity(
                            0.7,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              if (trailing != null)
                showTrailingAsIcon
                    ? Icon(
                        trailing,
                        size: 20,
                        color: theme.textTheme.bodySmall?.color,
                      )
                    : Icon(
                        trailing,
                        size: 16,
                        color: theme.textTheme.bodySmall?.color,
                      ),
            ],
          ),
        ),
      ),
    );
  }

  void _changePassword() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(Get.context!).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Change Password',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () {
                      Get.back();
                      controller.clearController();
                    },
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
              SizedBox(height: 20),
              CustomTextFormField(
                hintText: 'Current Password',
                controller: controller.currentPassword,
                obscureText: true,
              ),
              SizedBox(height: 16),
              CustomTextFormField(
                hintText: 'New Password',
                controller: controller.newPassword,
                obscureText: true,
              ),
              SizedBox(height: 16),
              CustomTextFormField(
                hintText: 'Confirm New Password',
                controller: controller.confirmPassword,
                obscureText: true,
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: Obx(
                      () => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.changePassword,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: controller.isLoading.value
                        ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                        : const Text('Update Password'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _selectLanguage() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Theme.of(Get.context!).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Language',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            SizedBox(height: 16),
            ...controller.languages.map((language) {
              return Obx(
                () => RadioListTile<String>(
                  title: Text(language),
                  value: language,
                  groupValue: controller.preferredLanguage.value,
                  onChanged: (value) {
                    controller.preferredLanguage.value = value.toString();
                    controller.updatePreferences();
                    Get.back();
                  },
                  activeColor: Theme.of(Get.context!).primaryColor,
                  contentPadding: EdgeInsets.symmetric(horizontal: 0),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  void _sendFeedback() {
    Get.dialog(
      AlertDialog(
        title: Text('Send Feedback'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'We value your feedback!',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            SizedBox(height: 16),
            CustomTextFormField(
              hintText: 'Enter Subject',
              controller: controller.subjectController,
            ),
            SizedBox(height: 16),
            CustomTextFormField(
              hintText: 'Enter Your Message',
              controller: controller.messageController,
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          Obx(
                () => ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () => controller.fetchFeedback(),
              child: controller.isLoading.value
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              )
                  : const Text('Send'),
            ),
          ),
        ],
      ),
    );
  }

  void _rateApp() {
    Get.snackbar(
      'Coming Soon',
      'functionality will be available soon',
      snackPosition: SnackPosition.BOTTOM,
      margin: EdgeInsets.all(16),
      borderRadius: 12,
      duration: Duration(seconds: 2),
    );
  }
}
