import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/constant/app_button.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'package:samadhantra/app/data/model/stake_holder_model/get_user_type_model.dart';
import 'package:samadhantra/app/modules/auth/role_selection_screen/role_selection_screen_controller.dart';
import 'package:samadhantra/app/utils/app_config.dart';

class RoleSelectionScreen extends StatelessWidget {
  RoleSelectionScreen({super.key});

  final RoleSelectionController controller = Get.put(RoleSelectionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back Button
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 18,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),

                // Header
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.getUserTypeApi();
                      },
                      child: Text(
                        'Select Your Role',
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Choose the category that best describes you',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),
                Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return _buildRoleGrid();
                }),

                const SizedBox(height: 40),

                // Continue Button
                Obx(() => _buildContinueButton()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleGrid() {
    return Obx(
      () => GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        itemCount: controller.userTypes.length,
        itemBuilder: (context, index) {
          final role = controller.userTypes[index];
          controller.subscriptionAmount = role.subscriptionAmountInr;
          return Obx(
            () => _buildRoleCard(
              role,
              controller.selectedRole.value?.value == role.value,
              role.subscriptionAmountInr ?? 0,
            ),
          );
        },
      ),
    );
  }

  Widget _buildRoleCard(UserTypes role, bool isSelected, int amount) {
    print('akjdfjkd=> ${role.label}');
    return GestureDetector(
      onTap: () => controller.selectRole(role),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.appColor.withOpacity(0.12),
              AppColors.appColor.withOpacity(0.04),
            ],
          )
              : const LinearGradient(
            colors: [Colors.white, Colors.white],
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isSelected
                ? AppColors.appColor
                : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.appColor.withOpacity(0.18)
                  : Colors.black.withOpacity(0.06),
              blurRadius: isSelected ? 18 : 10,
              spreadRadius: isSelected ? 1 : 0,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 72,
              height: 72,
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected
                      ? AppColors.appColor.withOpacity(0.3)
                      : Colors.grey.shade200,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: (role.iconUrl != null &&
                    role.iconUrl!.isNotEmpty)
                    ? Image.network(
                  '${AppConfig.imageBaseUrl}${role.iconUrl}',
                  fit: BoxFit.cover,
                )
                    : Image.asset(
                  'assets/images/samadhantra_applogo.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),

            Text(
              role.label ?? "",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isSelected
                    ? AppColors.appColor
                    : Colors.black87,
                letterSpacing: 0.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 6),

            Text(
              role.value ?? "",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: isSelected
                    ? AppColors.appColor.withOpacity(0.85)
                    : Colors.grey.shade600,
                height: 1.35,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 12),

            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: isSelected ? 1 : 0,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.appColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Selected",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton() {
    final isEnabled = controller.selectedRole.value != null;

    return Opacity(
      opacity: isEnabled ? 1 : 0.6,
      child: AppButton(
        title: 'Continue',
        onPressed: isEnabled ? controller.continueWithRole : null,
      ),
    );
  }
}
