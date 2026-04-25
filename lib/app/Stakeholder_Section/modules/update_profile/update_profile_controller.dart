import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:http/http.dart' as http;
import 'package:samadhantra/app/Stakeholder_Section/modules/profile_screen/profile_screen_controller.dart';
import 'package:samadhantra/app/data/model/user_data_model.dart';
import 'package:flutter/material.dart';

import '../../../constant/app_camera_popup.dart';
import '../../../constant/custom_snackbar.dart';
import '../../../data/api_service.dart';
import '../../../utils/app_config.dart';
import '../../../utils/widgets/map_controller.dart';

class UpdateProfileController extends GetxController {
  final profileController = Get.put(ProfileController());
  final MapController mapController = Get.put(MapController());
  final RxBool isLoading = false.obs;
  final RxBool isUploadingLogo = false.obs;

  final companyLogo = Rx<File?>(null);
  final companyLogoUrl = ''.obs;

  Rx<ProfileData> profileData = ProfileData().obs;
  var userData = Rx<Map<String, dynamic>?>(null);
  final ApiService _apiService = ApiService();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final aboutController = TextEditingController();
  final skillsController = TextEditingController();
  final collegeController = TextEditingController();
  final degreeController = TextEditingController();
  final customCategory = TextEditingController();
  final customSubCategory = TextEditingController();
  final describeYourNeed = TextEditingController();
  final objective = TextEditingController();

  final specializationController = TextEditingController();
  final keySkillsController = TextEditingController();
  final customSubCategoryController = TextEditingController();
  final objectiveController = TextEditingController();
  final customCategoryController = TextEditingController();
  final describeYourNeedController = TextEditingController();

  RxList<String> selectedCategories = <String>[].obs;
  RxList<String> selectedSubCategories = <String>[].obs;

  List<String> categoryList = [
    'Business & Startup Services',
    'Technology & Digital Solutions',
    'Education & Skill Development',
    'Talent, Internship & Hiring',
    'Investment & Funding',
    'Legal, Compliance & Governance',
    'Marketing, Sales & Growth',
    'Infrastructure & Operations'
        'Research, Innovation & Consulting',
    'Government, CSR & Public Programs',
    'Other'
  ];

  List<String> subCategoryList = [
    'Company incorporation',
    'MSME registration',
    'Business advisory',
    'Financial planning',
    'Process consulting',
    'Event',
    'Website & app development',
    'SaaS products',
    'ERP / CRM / HRMS',
    'AI & data analytics',
    'Cybersecurity',
    'Cloud & hosting',
    'Certification programs',
    'Faculty development',
    'Industry-aligned curriculum',
    'Online / offline training',
    'Skill assessment'
        'Foreign university collaboration',
    'Internships',
    'Apprenticeships',
    'Freelance projects',
    'Full-time hiring',
    'Campus placements',
    'Angel funding',
    'Venture capital',
    'Government grants',
    'CSR funding',
    'Pitch & fundraising support',
    'IP & patent filing',
    'Contracts & agreements',
    'GST & taxation',
    'Audit & compliance',
    'Regulatory advisory',
    'Branding & design',
    'IT hardware',
    'Office setup',
    'Market research',
    'PR & communications',
    'Performance marketing',
    'R&D projects',
    'Supply chain services',
    'Facility management',
    'Cloud infrastructure',
    'Other'
  ];

  @override
  void onInit() {
    // TODO: implement onInit
    profileData.value = Get.arguments;
    _updateController();
    super.onInit();
  }

  void _updateController() {
    nameController.text = profileData.value.fullName ?? '';
    emailController.text = profileData.value.email ?? '';
    phoneController.text = profileData.value.phoneNumber ?? '';
    addressController.text = profileData.value.address ?? '';
    aboutController.text = profileData.value.aboutYourself ?? '';
    skillsController.text = profileData.value.keySkills ?? '';
    collegeController.text = profileData.value.collegeName ?? '';
    degreeController.text = profileData.value.degree ?? '';

    // category.text = profileData.value.category ?? '';
    // subCategory.text = profileData.value.subCategory ?? '';
    describeYourNeed.text = profileData.value.describeYourNeed ?? '';
    objective.text = profileData.value.objective ?? '';
    specializationController.text = profileData.value.specialization ?? '';
    keySkillsController.text = profileData.value.keySkills ?? '';
    customSubCategoryController.text = profileData.value.customSubCategory ?? '';
    objectiveController.text = profileData.value.objective ?? '';
    customCategoryController.text = profileData.value.customCategory ?? '';
    describeYourNeedController.text = profileData.value.describeYourNeed ?? '';
  }

  Future<void> pickAndUploadProfilePhoto() async {
    try {
      final File? imageFile = await AppCameraDialog.show();

      if (imageFile != null) {
        // Update local preview immediately
        companyLogo.value = imageFile;

        // Upload to server
        await updateProfilePhotoUrlApi(imageFile.path);
      }
    } catch (e) {
      CustomSnackBar.error('Failed to pick image: $e');
    }
  }

  Future<void> updateProfilePhotoUrlApi(String imagePath) async {
    try {
      isLoading.value = true;

      final formData = dio.FormData.fromMap({
        'profile_photo': await dio.MultipartFile.fromFile(imagePath),
      });

      final response = await _apiService.patch(
        AppConfig.updateProfilePhotoUrl,
        data: formData,
      );

      if (response != null && response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['status'] == true) {
          userData.value = {
            ...?userData.value,
            ...data['data'] ?? {'profile_photo': imagePath},
          };

          Get.back();
          update();
          profileController.getUserProfile();
          CustomSnackBar.success(
            data['message'] ??
                'Profile photo updated successfully',
          );

          CustomSnackBar.success(
            data['message'] ??
                'Profile photo updated successfully',
          );

          // Navigate back if needed
        } else {
          CustomSnackBar.error(
            data['message'] ?? 'Failed to update profile photo',
          );
        }
      } else if (response != null && response.statusCode == 422) {
        // Handle validation errors
        final errors = response.data?['errors'];
        if (errors != null) {
          final errorMessage = errors.values.first?.first;
          CustomSnackBar.error(errorMessage ?? 'Validation error');
        }
      } else {
        CustomSnackBar.error(
          'Failed to update profile photo. Status code: ${response?.statusCode}',
        );
      }
    } on SocketException {
      CustomSnackBar.error('No internet connection');
    } finally {
      isLoading.value = false;
    }
  }
  Map<String, dynamic> _buildProfilePayload() {
    return {
      "full_name": nameController.text.trim(),
      "address": addressController.text.trim(),
      "about_yourself": aboutController.text.trim(),
      "objective": objectiveController.text.trim(),
      "describe_your_need": describeYourNeedController.text.trim(),

      "category": selectedCategories,
      "sub_category": selectedSubCategories,

      "custom_category": customCategoryController.text.trim(),
      "custom_sub_category": customSubCategoryController.text.trim(),

      "college_name": collegeController.text.trim(),
      "degree": degreeController.text.trim(),
      "specialization": specializationController.text.trim(),
      "key_skills": keySkillsController.text.trim(),
    };
  }

  Future<void> updateProfile() async {
    try {
      isLoading.value = true;

      /// Build request body
      final Map<String, dynamic> payload = _buildProfilePayload();

      /// API Call
      final response = await _apiService.patch(
        AppConfig.updateProfileUrl,
        data: payload,
      );

      /// Handle response
      _handleUpdateResponse(response);
    } on SocketException {
      CustomSnackBar.error('No internet connection');
    } catch (e) {
      debugPrint("Update Profile Error: $e");
      CustomSnackBar.error('Something went wrong');
    } finally {
      isLoading.value = false;
    }
  }

  void _handleUpdateResponse(response) {
    final statusCode = response.statusCode;
    final data = response.data;

    if (statusCode == 200) {
      if (data != null && data['success'] == true) {

        /// Update local user data
        userData.value = {
          ...?userData.value,
          ...(data['data'] ?? {}),
        };

        /// Refresh profile
        profileController.getUserProfile();

        CustomSnackBar.success(
          data['message'] ?? 'Profile updated successfully',
        );

        Get.back();
        update();

      } else {
        Get.back();
        profileController.getUserProfile();
        CustomSnackBar.success(
          data?['message'] ?? 'Failed to update profile',
        );
      }
    }

    /// Validation error
    else if (statusCode == 422) {
      final errors = data?['errors'];

      if (errors != null && errors.isNotEmpty) {
        final firstError = errors.values.first;

        if (firstError is List && firstError.isNotEmpty) {
          CustomSnackBar.error(firstError.first.toString());
        } else {
          CustomSnackBar.error("Validation error");
        }
      }
    }

    /// Other errors
    else {
      CustomSnackBar.error(
        "Failed to update profile (${response.statusCode})",
      );
    }
  }
}
