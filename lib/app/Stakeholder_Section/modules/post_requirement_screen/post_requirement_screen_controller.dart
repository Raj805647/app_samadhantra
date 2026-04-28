import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart' as http;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:samadhantra/app/Stakeholder_Section/modules/my_requirement/my_requirement_controller.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/profile_screen/profile_screen_controller.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/requiremnent_list_screen/requiremnent_list_screen_controller.dart';
import 'package:samadhantra/app/constant/app_camera_popup.dart';
import 'package:samadhantra/app/constant/custom_snackbar.dart';
import 'package:samadhantra/app/constant/token_storage_service.dart';
import 'package:samadhantra/app/data/api_service.dart';
import 'package:samadhantra/app/data/model/user_data_model.dart';
import 'package:samadhantra/app/utils/app_config.dart';
import 'dart:convert';

import '../../../data/model/stake_holder_model/my_requirements_model.dart'; // Add this import

class PostRequirementController extends GetxController {
  // Form controllers
  final titleController = TextEditingController();
  final problemController = TextEditingController();
  final outcomeController = TextEditingController();
  final budgetRangeController = TextEditingController(); // Single budget field
  final ApiService _apiService = ApiService();
  final ProfileController profileController = Get.put(ProfileController());

  Rx<MyRequirementData> requirementData = MyRequirementData().obs;
  // Form fields
  RxString selectedStakeholder = 'Startup'.obs;
  RxBool isSubmit = false.obs;
  RxString selectedRequirementTitle = ''.obs;
  RxString selectedTimeline = 'Within 30 days'.obs;
  RxString selectedLocation = ''.obs;
  RxString selectedUrgency = 'Flexible'.obs;

  // Budget - single value for API
  RxString budgetValue = ''.obs;

  @override
  onInit() {
    requirementData.value = Get.arguments ?? MyRequirementData();
    problemController.text = requirementData.value.problemDescription ?? '';
    outcomeController.text = requirementData.value.expectedOutcome ?? '';
    budgetRangeController.text = requirementData.value.budgetRange ?? '';

    selectedRequirementTitle.value =
        requirementData.value.requirementCategory ?? '';
    selectedStakeholder.value = requirementData.value.requirementCategory ?? '';
    selectedLocation.value = requirementData.value.preferredLocation ?? '';
    selectedUrgency.value = requirementData.value.requirementCategory ?? '';

    budgetValue.value = requirementData.value.budgetRange ?? '';
    selectedEngagementTypes.value = requirementData.value.engagementTypes ?? [];
    super.onInit();
  }

  String getFormattedBudget() {
    final text = budgetRangeController.text.trim();
    if (text.isEmpty) {
      // Return a default value or show error
      return ''; // Or set a default like '10000'
    }

    // Remove commas and format if needed
    return text.replaceAll(',', '');
  }

  // Engagement type (multiple selection)
  var selectedEngagementTypes = <String>[].obs;

  // Observable variables
  var attachments = <File>[].obs;
  var isLoading = false.obs;

  // Stakeholder types
  final stakeholders = [
    'Startup',
    'Small Business',
    'Enterprise',
    'Individual',
    'Non-Profit',
    'Government',
  ];

  // Requirement titles (match exactly with Postman)
  final requirementTitles = [
    'Business & Startup Services',
    'Technology & Digital Solutions',
    'Education & Skill Development',
    'Talent, Internship & Hiring',
    'Investment & Funding',
    'Legal, Compliance & Governance',
    'Marketing, Sales & Growth',
    'Infrastructure & Operations',
    'Research, Innovation & Consulting',
    'Government, CSR & Public Programs',
    'Other',
  ];

  // Timeline options
  final timelines = [
    'Immediate (Within 7 days)',
    'Within 30 days',
    '1 - 3 months',
    '3 - 6 months',
    'Flexible',
  ];

  // Engagement types (match exactly with Postman)
  final engagementTypes = [
    'One-time',
    'Short-term',
    'Long-term',
    'Subscription',
    'Pilot / PoC',
  ];

  // Form key
  final formKey = GlobalKey<FormState>();

  Future<void> postRequirementApi(BuildContext context) async {
    print('post function');

    try {
      isLoading.value = true;

      // Get access token
      final String? accessToken = await TokenService.getAccessToken();
      if (accessToken == null || accessToken.isEmpty) {
        CustomSnackBar.error('Please login to post a requirement');
        isLoading.value = false;
        return;
      }

      // Get user ID
      final userId = profileController.profileData.value?.id?.toString();
      if (userId == null || userId.isEmpty) {
        CustomSnackBar.error('User ID not found');
        isLoading.value = false;
        return;
      }

      final budgetText = budgetRangeController.text.trim();
      if (budgetText.isEmpty) {
        CustomSnackBar.error('Please enter budget range');
        isLoading.value = false;
        return;
      }

      // Format budget
      final formattedBudget = budgetText
          .replaceAll('₱', '')
          .replaceAll(',', '')
          .replaceAll(' ', '')
          .trim();

      if (formattedBudget.isEmpty) {
        CustomSnackBar.error('Please enter a valid budget');
        isLoading.value = false;
        return;
      }

      final body = {
        "user_id": profileController.profileData.value?.id.toString(),
        "requirement_category": selectedRequirementTitle.value.trim(),
        "problem_description": problemController.text.trim(),
        "expected_outcome": outcomeController.text.trim(),
        "timeline": selectedTimeline.value.trim(),
        "budget_range": formattedBudget,
        "preferred_location": selectedLocation.value.trim(),
        "engagement_types": selectedEngagementTypes.toList(),
      };

      debugPrint("📦 REQUEST BODY => ${jsonEncode(body)}");

      final response = await _apiService.post(
        AppConfig.postRequirementUrl,
        data: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data['status'] == true) {
          // Clear form
          clearForm();

          // Show success message
          CustomSnackBar.success(
            data['message'] ?? 'Requirement posted successfully',
          );

          // Wait a bit for snackbar to show
          await Future.delayed(const Duration(milliseconds: 800));

          // Use Post Frame Callback to ensure UI is ready
          WidgetsBinding.instance.addPostFrameCallback((_) {
            // Close any open dialogs/snackbars first
            if (Get.isDialogOpen == true) Get.back();
            if (Get.isSnackbarOpen == true) Get.closeCurrentSnackbar();
            if (Get.isBottomSheetOpen == true) Get.back();

            // Navigate back to previous screen
            final reqList = Get.put(MyRequirementController());
            reqList.fetchRequirements();
            Get.back(result: true);
            Navigator.of(context, rootNavigator: true).pop(true);
            // Refresh requirements list on the previous screen
            try {
              Get.find<RequirementsController>().refreshRequirements();
            } catch (e) {
              debugPrint("Could not refresh requirements: $e");
            }
          });
        } else {
          CustomSnackBar.error(data['message'] ?? 'Failed to post requirement');
        }
      } else if (response.statusCode == 422) {
        handleValidationErrors(response.data);
      } else {
        CustomSnackBar.error('Server error: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint("❌ Post Requirement Error: $e");
      CustomSnackBar.error('Failed to post requirement. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  void handleValidationErrors(dynamic responseData) {
    try {
      debugPrint("📥 Validation Errors: $responseData");

      if (responseData is Map) {
        // Check for errors field
        if (responseData['errors'] != null) {
          final errors = responseData['errors'];
          String errorMessage = '';

          errors.forEach((key, value) {
            if (value is List) {
              errorMessage += '${value.first}\n';
            } else {
              errorMessage += '$value\n';
            }
          });

          if (errorMessage.isNotEmpty) {
            CustomSnackBar.error(errorMessage.trim());
            return;
          }
        }

        // Check for message field
        if (responseData['message'] != null) {
          CustomSnackBar.error(responseData['message']);
          return;
        }
      }

      CustomSnackBar.error('Validation failed. Please check your inputs.');
    } catch (e) {
      CustomSnackBar.error('Validation error occurred');
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    problemController.dispose();
    outcomeController.dispose();
    budgetRangeController.dispose();
    super.onClose();
  }

  // Set budget from controller
  void setBudgetValue(String value) {
    budgetValue.value = value;
  }

  // Toggle engagement type
  void toggleEngagementType(String type) {
    if (selectedEngagementTypes.contains(type)) {
      selectedEngagementTypes.remove(type);
    } else {
      selectedEngagementTypes.add(type);
    }
  }

  // Add attachment
  Future<void> addAttachment() async {
    try {
      final File? file = await AppCameraDialog.show();
      if (file != null) {
        attachments.add(file);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to add attachment');
    }
  }

  // Remove attachment
  void removeAttachment(int index) {
    attachments.removeAt(index);
  }

  bool validateForm() {
    if (selectedRequirementTitle.value.isEmpty) {
      CustomSnackBar.error('Please select a requirement title');
      return false;
    }
    if (problemController.text.trim().isEmpty) {
      CustomSnackBar.error('Please describe your problem/need');
      return false;
    }
    if (outcomeController.text.trim().isEmpty) {
      CustomSnackBar.error('Please describe the expected outcome');
      return false;
    }
    if (selectedEngagementTypes.isEmpty) {
      CustomSnackBar.error('Please select at least one engagement type');
      return false;
    }
    if (budgetValue.value.trim().isEmpty) {
      CustomSnackBar.error('Please enter budget range');
      return false;
    }
    return true;
  }

  // Submit requirement
  Future<void> submitRequirement() async {
    if (!validateForm()) return;

    // Call the API
    // await postRequirementApi(conte);
  }

    Future<void> updateRequirementList() async {
      try {
        isSubmit.value = true;
        final userToken = await TokenService.getAccessToken();
        final url = Uri.parse(
          '${AppConfig.baseUrl}${AppConfig.updateRequirement}/${requirementData.value.id}',
        );

        final response = await http.put(
          url,
          headers: {"Content-Type": "application/json", "Authorization": "Bearer $userToken"},
          body: jsonEncode(_buildRequestBody()),
        );

        final data = jsonDecode(response.body);
        print('adskjjbfsdabjfasd');
        print(url);
        print(_buildRequestBody());
        print(data['message']);
        print(response.statusCode);

        if (response.statusCode == 200 && data['status'] == true) {
          Get.back();
          CustomSnackBar.success('Requirements updated successfully');
        } else {
          CustomSnackBar.error(data['message'] ?? 'Failed to update requirements');
        }
      } catch (e) {
        CustomSnackBar.error('Failed to update requirements.');
        debugPrint("Update Requirement Error: $e");
      } finally {
        isSubmit.value = false;
      }
    }

  Map<String, dynamic> _buildRequestBody() {
    return {
      "requirement_category": selectedRequirementTitle.value,
      "problem_description": problemController.text,
      "expected_outcome": outcomeController.text,
      "timeline": selectedTimeline.value,
      "budget_range": budgetValue.value,
      "preferred_location": selectedLocation.value,
      "engagement_types": selectedEngagementTypes,
      "status": "created",
    };
  }


  // Clear form
  void clearForm() {
    selectedStakeholder.value = 'Startup';
    selectedRequirementTitle.value = '';
    problemController.clear();
    outcomeController.clear();
    selectedTimeline.value = 'Within 30 days';
    budgetValue.value = '';
    selectedLocation.value = '';
    selectedEngagementTypes.clear();
    selectedUrgency.value = 'Flexible';
    attachments.clear();
  }

  // Helper to format budget display (for UI only)
  String get budgetDisplay {
    if (budgetValue.value.isEmpty) return 'Enter Budget';
    return '₱ ${_formatNumber(budgetValue.value)}';
  }

  String _formatNumber(String number) {
    if (number.isEmpty) return '0';
    final num = int.tryParse(number) ?? 0;
    return num.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (match) => '${match[1]},',
    );
  }
}
