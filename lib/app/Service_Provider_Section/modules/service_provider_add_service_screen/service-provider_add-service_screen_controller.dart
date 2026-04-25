// lib/app/modules/service_provider/controllers/service_provider_add_service_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:samadhantra/app/data/model/service_service_model.dart';
import 'package:samadhantra/app/global_routes/app_routes.dart';

class ServiceProviderAddServiceController extends GetxController {
  var isLoading = false.obs;
  var isSubmitting = false.obs;
  var currentStep = 0.obs;

  // Form Fields
  var serviceDescription = ''.obs;
  var selectedCategory = ''.obs;
  var hourlyRate = ''.obs;
  var dailyRate = ''.obs;
  var projectRate = ''.obs;
  var selectedPricingModel = 'Hourly'.obs;
  var experienceLevel = 'Intermediate'.obs;
  var deliveryDays = '7'.obs;
  var tags = <String>[].obs;
  var skills = <String>[].obs;
  var isActive = true.obs;
  var isFeatured = false.obs;

  final serviceNameController = TextEditingController();
  final serviceDescriptionController = TextEditingController();

  // Lists for dropdowns
  var categories = <String>[
    'Web Development',
    'Mobile App Development',
    'UI/UX Design',
    'Graphic Design',
    'Digital Marketing',
    'SEO',
    'Content Writing',
    'Video Editing',
    'Consulting',
    'E-commerce Development',
    'Cloud Services',
    'Data Analytics',
    'IT Support',
    'Software Testing',
    'Other'
  ].obs;

  var pricingModels = <String>[
    'Hourly',
    'Daily',
    'Project-based',
    'Monthly',
  ].obs;

  var experienceLevels = <String>[
    'Beginner',
    'Intermediate',
    'Advanced',
    'Expert'
  ].obs;

  var deliveryOptions = <String>[
    '1',
    '3',
    '5',
    '7',
    '10',
    '14',
    '21',
    '30',
    '45',
    '60',
    'Custom'
  ].obs;

  var availableSkills = <String>[
    'Flutter',
    'React',
    'Node.js',
    'Python',
    'Java',
    'JavaScript',
    'HTML/CSS',
    'UI/UX Design',
    'Figma',
    'Adobe Photoshop',
    'SEO',
    'Content Writing',
    'Digital Marketing',
    'Social Media',
    'Project Management',
    'Communication',
    'Problem Solving',
    'Team Collaboration',
    'Client Management',
    'Time Management'
  ].obs;

  var availableTags = <String>[
    'Mobile',
    'Web',
    'Design',
    'Development',
    'Marketing',
    'SEO',
    'Content',
    'Video',
    'E-commerce',
    'Cloud',
    'Consulting',
    'Analytics',
    'Support',
    'Testing',
    'Responsive',
    'Cross-platform',
    'Scalable',
    'Secure',
    'Fast',
    'Reliable'
  ].obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with default values
    selectedCategory.value = categories.isNotEmpty ? categories[0] : '';
    experienceLevel.value = experienceLevels[1];
    deliveryDays.value = deliveryOptions[3]; // 7 days
  }

  void nextStep() {
    if (validateCurrentStep()) {
      if (currentStep.value < 2) {
        currentStep.value++;
      } else {
        submitService();
      }
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  bool validateCurrentStep() {
    switch (currentStep.value) {
      case 0: // Basic Info
        if (serviceNameController.value.text.isEmpty) {
          Get.snackbar(
            'Validation Error',
            'Service name is required',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return false;
        }
        if (serviceDescriptionController.value.text.isEmpty) {
          Get.snackbar(
            'Validation Error',
            'Service description is required',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return false;
        }
        if (selectedCategory.value.isEmpty) {
          Get.snackbar(
            'Validation Error',
            'Please select a category',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return false;
        }
        return true;

      case 1: // Pricing & Details
        if (selectedPricingModel.value == 'Hourly' && hourlyRate.value.isEmpty) {
          Get.snackbar(
            'Validation Error',
            'Hourly rate is required',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return false;
        }
        if (selectedPricingModel.value == 'Daily' && dailyRate.value.isEmpty) {
          Get.snackbar(
            'Validation Error',
            'Daily rate is required',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return false;
        }
        if (selectedPricingModel.value == 'Project-based' && projectRate.value.isEmpty) {
          Get.snackbar(
            'Validation Error',
            'Project rate is required',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return false;
        }
        if (skills.isEmpty) {
          Get.snackbar(
            'Validation Error',
            'Please add at least one skill',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return false;
        }
        return true;

      case 2: // Additional Info
        return true; // All fields are optional

      default:
        return false;
    }
  }

  void toggleSkill(String skill) {
    if (skills.contains(skill)) {
      skills.remove(skill);
    } else {
      skills.add(skill);
    }
  }

  void toggleTag(String tag) {
    if (tags.contains(tag)) {
      tags.remove(tag);
    } else {
      tags.add(tag);
    }
  }

  void addCustomTag(String tag) {
    if (tag.isNotEmpty && !tags.contains(tag)) {
      tags.add(tag);
    }
  }

  void addCustomSkill(String skill) {
    if (skill.isNotEmpty && !skills.contains(skill)) {
      skills.add(skill);
    }
  }

  void updatePricing() {
    // Auto-calculate other rates based on selected pricing model
    if (selectedPricingModel.value == 'Hourly' && hourlyRate.value.isNotEmpty) {
      double hourly = double.tryParse(hourlyRate.value) ?? 0;
      dailyRate.value = (hourly * 8).toStringAsFixed(0); // 8 hours per day
      projectRate.value = (hourly * 40).toStringAsFixed(0); // 40 hours per week
    } else if (selectedPricingModel.value == 'Daily' && dailyRate.value.isNotEmpty) {
      double daily = double.tryParse(dailyRate.value) ?? 0;
      hourlyRate.value = (daily / 8).toStringAsFixed(0); // 8 hours per day
      projectRate.value = (daily * 5).toStringAsFixed(0); // 5 days per week
    } else if (selectedPricingModel.value == 'Project-based' && projectRate.value.isNotEmpty) {
      double project = double.tryParse(projectRate.value) ?? 0;
      hourlyRate.value = (project / 40).toStringAsFixed(0); // 40 hours per project
      dailyRate.value = (project / 5).toStringAsFixed(0); // 5 days per project
    }
  }

  void submitService() async {
    if (!validateForm()) {
      return;
    }

    isSubmitting.value = true;

    // Prepare service data
    final serviceData = ServiceModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: serviceNameController.value.text,
      description: serviceDescription.value,
      hourlyRate: double.tryParse(hourlyRate.value) ?? 0,
      dailyRate: double.tryParse(dailyRate.value) ?? 0,
      projectRate: double.tryParse(projectRate.value) ?? 0,
      category: selectedCategory.value,
      tags: tags.toList(),
      isActive: isActive.value,
      isFeatured: isFeatured.value,
      createdAt: DateTime.now(),
      skills: skills.toList(),
      experienceLevel: experienceLevel.value,
      deliveryDays: int.tryParse(deliveryDays.value) ?? 7, icon: 'Icons.abc',
    );

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    isSubmitting.value = false;

    Get.snackbar(
      'Success',
      'Service added successfully',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    // Navigate back to services list
    Get.offNamed(AppRoutes.serviceProviderManageServices);
  }

  bool validateForm() {
    if (serviceNameController.value.text.isEmpty) {
      Get.snackbar('Error', 'Service name is required');
      return false;
    }
    if (serviceDescription.value.isEmpty) {
      Get.snackbar('Error', 'Service description is required');
      return false;
    }
    if (selectedCategory.value.isEmpty) {
      Get.snackbar('Error', 'Please select a category');
      return false;
    }
    if (skills.isEmpty) {
      Get.snackbar('Error', 'Please add at least one skill');
      return false;
    }
    return true;
  }

  void resetForm() {
    Get.defaultDialog(
      title: 'Reset Form',
      middleText: 'Are you sure you want to reset all fields?',
      textConfirm: 'Reset',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      onConfirm: () {
        serviceNameController.text= '';
        serviceDescription.value = '';
        selectedCategory.value = categories[0];
        hourlyRate.value = '';
        dailyRate.value = '';
        projectRate.value = '';
        selectedPricingModel.value = 'Hourly';
        experienceLevel.value = 'Intermediate';
        deliveryDays.value = '7';
        tags.clear();
        skills.clear();
        isActive.value = true;
        isFeatured.value = false;
        currentStep.value = 0;
        Get.back();
      },
    );
  }

  void saveAsDraft() {
    Get.defaultDialog(
      title: 'Save as Draft',
      middleText: 'Save this service as draft?',
      textConfirm: 'Save Draft',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      onConfirm: () {
        // Save draft logic
        Get.back();
        Get.snackbar(
          'Draft Saved',
          'Service saved as draft',
          backgroundColor: Colors.blue,
          colorText: Colors.white,
        );
        Get.back();
      },
    );
  }

  void cancelAddService() {
    Get.defaultDialog(
      title: 'Cancel',
      middleText: 'Are you sure you want to cancel? All unsaved changes will be lost.',
      textConfirm: 'Yes, Cancel',
      textCancel: 'Continue Editing',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        Get.back();
      },
    );
  }

  double get calculatedHourlyRate {
    if (selectedPricingModel.value == 'Hourly') {
      return double.tryParse(hourlyRate.value) ?? 0;
    } else if (selectedPricingModel.value == 'Daily') {
      return (double.tryParse(dailyRate.value) ?? 0) / 8;
    } else if (selectedPricingModel.value == 'Project-based') {
      return (double.tryParse(projectRate.value) ?? 0) / 40;
    }
    return 0;
  }

  double get calculatedDailyRate {
    if (selectedPricingModel.value == 'Hourly') {
      return (double.tryParse(hourlyRate.value) ?? 0) * 8;
    } else if (selectedPricingModel.value == 'Daily') {
      return double.tryParse(dailyRate.value) ?? 0;
    } else if (selectedPricingModel.value == 'Project-based') {
      return (double.tryParse(projectRate.value) ?? 0) / 5;
    }
    return 0;
  }

  double get calculatedProjectRate {
    if (selectedPricingModel.value == 'Hourly') {
      return (double.tryParse(hourlyRate.value) ?? 0) * 40;
    } else if (selectedPricingModel.value == 'Daily') {
      return (double.tryParse(dailyRate.value) ?? 0) * 5;
    } else if (selectedPricingModel.value == 'Project-based') {
      return double.tryParse(projectRate.value) ?? 0;
    }
    return 0;
  }
}