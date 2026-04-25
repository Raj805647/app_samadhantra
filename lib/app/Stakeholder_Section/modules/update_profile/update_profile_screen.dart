import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/update_profile/update_profile_controller.dart';

import '../../../constant/app_color.dart';
import '../../../constant/custom_appbar.dart';
import '../../../constant/custom_textformfield.dart';

class UpdateProfileScreen extends StatelessWidget {
  UpdateProfileScreen({super.key});

  final controller = Get.find<UpdateProfileController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      appBar: CustomAppBar(title: "Update Profile"),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: _buildProfileImage()),

              const SizedBox(height: 30),

              /// Full Name
              CustomTextFormField(
                controller: controller.nameController,
                labelText: "Full Name",
                hintText: "Full Name",
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                controller: controller.emailController,
                labelText: "Email",
                hintText: "Email",
                readOnly: true,
              ),
              const SizedBox(height: 16),

              CustomTextFormField(
                controller: controller.phoneController,
                labelText: "Phone",
                hintText: "Phone",
                readOnly: true,
              ),
              const SizedBox(height: 16),

              /// Address
              CustomTextFormField(
                controller: controller.addressController,
                labelText: "Address",
                hintText: "Address",
              ),

              const SizedBox(height: 16),

              /// About Yourself
              CustomTextFormField(
                controller: controller.aboutController,
                labelText: "About Yourself",
                hintText: "About Yourself",
                maxLines: 3,
              ),

              const SizedBox(height: 16),

              /// Objective
              CustomTextFormField(
                controller: controller.objectiveController,
                labelText: "Objective",
                hintText: "Objective",
                readOnly: true,
              ),

              const SizedBox(height: 16),

              /// Describe Your Need
              CustomTextFormField(
                controller: controller.describeYourNeedController,
                labelText: "Describe Your Need",
                hintText: "Describe Your Need",
                maxLines: 3,
              ),

              const SizedBox(height: 20),

              /// CATEGORY MULTI SELECT
              const Text(
                "Category",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 10),

              _buildMultiCategory(),

              const SizedBox(height: 16),

              /// Custom Category (if Other)
              Obx(() {
                if (controller.selectedCategories.contains("Other")) {
                  return CustomTextFormField(
                    controller: controller.customCategoryController,
                    labelText: "Custom Category",
                    hintText: "Custom Category",
                  );
                }
                return const SizedBox();
              }),

              const SizedBox(height: 20),

              /// SUB CATEGORY
              const Text(
                "Sub Category",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 10),

              _buildMultiSubCategory(),

              const SizedBox(height: 16),

              /// Custom Sub Category
              Obx(() {
                if (controller.selectedSubCategories.contains("Other")) {
                  return CustomTextFormField(
                    controller: controller.customSubCategoryController,
                    labelText: "Custom Sub Category",
                    hintText: "Custom Sub Category",
                  );
                }
                return const SizedBox();
              }),

              const SizedBox(height: 16),

              /// College
              CustomTextFormField(
                controller: controller.collegeController,
                labelText: "College Name",
                hintText: "College Name",
              ),

              const SizedBox(height: 16),

              /// Degree
              CustomTextFormField(
                controller: controller.degreeController,
                labelText: "Degree",
                hintText: "Degree",
              ),

              const SizedBox(height: 16),

              /// Specialization
              CustomTextFormField(
                controller: controller.specializationController,
                labelText: "Specialization",
                hintText: "Specialization",
              ),

              const SizedBox(height: 16),

              /// Skills
              CustomTextFormField(
                controller: controller.keySkillsController,
                labelText: "Key Skills",
                hintText: "Key Skills",
              ),

              const SizedBox(height: 30),

              /// Update Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => controller.updateProfile(),
                  child: const Text("Update Profile"),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  /// Profile Image
  Widget _buildProfileImage() {
    return Obx(() {
      final image = controller.profileData.value.profilePhotoUrl ?? '';
      print('adkfbsdab => $image');

      return Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            height: 110,
            width: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.appColor,
                width: 2,
              ),
              image: controller.companyLogo.value != null
                  ? DecorationImage(
                image: FileImage(
                  File(controller.companyLogo.value!.path),
                ),
                fit: BoxFit.cover,
              )
                  : (image != null && image.isNotEmpty)
                  ? DecorationImage(
                image: NetworkImage(
                  'https://api.samadhantra.com$image',
                ),
                fit: BoxFit.cover,
              )
                  : null,
            ),
            child: (image == null || image.isEmpty) &&
                controller.companyLogo.value == null
                ? Center(
              child: Text(
                controller.profileData.value.fullName![0].toUpperCase(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.appColor,
                ),
              ),
            )
                : null,
          ),
          GestureDetector(
            onTap: () => controller.pickAndUploadProfilePhoto(),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.appColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Icon(Icons.edit, color: Colors.white, size: 18),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildMultiCategory() {
    final controller = Get.find<UpdateProfileController>();

    return Obx(() {
      return Wrap(
        spacing: 8,
        children: controller.categoryList.map((category) {
          final isSelected = controller.selectedCategories.contains(category);

          return FilterChip(
            label: Text(category),
            selected: isSelected,
            onSelected: (value) {
              if (value) {
                controller.selectedCategories.add(category);
              } else {
                controller.selectedCategories.remove(category);
              }
            },
          );
        }).toList(),
      );
    });
  }

  Widget _buildMultiSubCategory() {
    final controller = Get.find<UpdateProfileController>();

    return Obx(() {
      return Wrap(
        spacing: 8,
        children: controller.subCategoryList.map((sub) {
          final isSelected = controller.selectedSubCategories.contains(sub);

          return FilterChip(
            label: Text(sub),
            selected: isSelected,
            onSelected: (value) {
              if (value) {
                controller.selectedSubCategories.add(sub);
              } else {
                controller.selectedSubCategories.remove(sub);
              }
            },
          );
        }).toList(),
      );
    });
  }
}
