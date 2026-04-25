import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ServiceProviderEditProfileController extends GetxController {
  var isLoading = false.obs;
  var isSaving = false.obs;

  // Form fields
  var businessName = ''.obs;
  var email = ''.obs;
  var phone = ''.obs;
  var website = ''.obs;
  var description = ''.obs;
  var address = ''.obs;
  var city = ''.obs;
  var state = ''.obs;
  var pincode = ''.obs;
  var businessType = ''.obs;
  var yearsOfExperience = ''.obs;
  var teamSize = ''.obs;

  // Profile image
  var profileImagePath = ''.obs;
  var profileImageUrl = ''.obs;

  // Services
  var selectedServices = <String>[].obs;

  // Lists for dropdowns
  var businessTypes = <String>[
    'Individual',
    'Partnership',
    'Private Limited',
    'LLP',
    'Proprietorship',
    'Startup',
    'Other'
  ].obs;

  var teamSizes = <String>[
    '1 (Solo)',
    '2-5',
    '6-10',
    '11-20',
    '21-50',
    '51-100',
    '100+'
  ].obs;

  var experienceYears = <String>[
    'Less than 1 year',
    '1-2 years',
    '3-5 years',
    '6-10 years',
    '10+ years'
  ].obs;

  var availableServices = <String>[
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

  @override
  void onInit() {
    super.onInit();
    loadProfileData();
  }

  void loadProfileData() async {
    isLoading.value = true;

    // Simulate API call to load profile data
    await Future.delayed(Duration(seconds: 1));

    // Sample data - replace with actual API data
    businessName.value = 'Tech Solutions Inc.';
    email.value = 'contact@techsolutions.com';
    phone.value = '+91 9876543210';
    website.value = 'www.techsolutions.com';
    description.value = 'We provide top-notch digital solutions with 5+ years of experience. Specialized in Flutter, React, and Node.js development.';
    address.value = '123 Tech Park, Sector 5';
    city.value = 'Bangalore';
    state.value = 'Karnataka';
    pincode.value = '560001';
    businessType.value = 'Private Limited';
    yearsOfExperience.value = '3-5 years';
    teamSize.value = '6-10';

    selectedServices.value = [
      'Web Development',
      'Mobile App Development',
      'UI/UX Design',
      'Digital Marketing'
    ];

    profileImageUrl.value = ''; // URL from backend

    isLoading.value = false;
  }

  void toggleService(String service) {
    if (selectedServices.contains(service)) {
      selectedServices.remove(service);
    } else {
      selectedServices.add(service);
    }
  }

  void updateProfileImage(String path) {
    profileImagePath.value = path;
    // In real app, upload to server and get URL
  }

  void removeProfileImage() {
    profileImagePath.value = '';
    profileImageUrl.value = '';
  }

  bool validateForm() {
    if (businessName.value.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Business name is required',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (email.value.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Email is required',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (phone.value.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Phone number is required',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (selectedServices.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Select at least one service',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }

  void saveProfile() async {
    if (!validateForm()) {
      return;
    }

    isSaving.value = true;

    // Prepare data for API
    final profileData = {
      'businessName': businessName.value,
      'email': email.value,
      'phone': phone.value,
      'website': website.value,
      'description': description.value,
      'address': address.value,
      'city': city.value,
      'state': state.value,
      'pincode': pincode.value,
      'businessType': businessType.value,
      'yearsOfExperience': yearsOfExperience.value,
      'teamSize': teamSize.value,
      'services': selectedServices.toList(),
      'profileImage': profileImagePath.value.isNotEmpty ? profileImagePath.value : profileImageUrl.value,
    };

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    isSaving.value = false;

    Get.snackbar(
      'Success',
      'Profile updated successfully',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    // Go back to profile screen
    Get.back(result: true);
  }

  void cancelEdit() {
    Get.defaultDialog(
      title: 'Discard Changes',
      middleText: 'Are you sure you want to discard all changes?',
      textConfirm: 'Discard',
      textCancel: 'Continue Editing',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        Get.back();
      },
    );
  }

  void resetForm() {
    Get.defaultDialog(
      title: 'Reset Form',
      middleText: 'Are you sure you want to reset all fields to original values?',
      textConfirm: 'Reset',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      onConfirm: () {
        loadProfileData();
        Get.back();
      },
    );
  }
}