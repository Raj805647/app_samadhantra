// lib/app/modules/service_provider/controllers/service_provider_profile_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/global_routes/app_routes.dart';

class ServiceProviderProfileController extends GetxController {
  var profile = {}.obs;
  var isLoading = false.obs;
  var stats = {}.obs;
  var recentActivity = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
    loadStats();
    loadRecentActivity();
  }

  void loadProfile() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 1));

    profile.value = {
      'id': 'SP001',
      'businessName': 'Tech Solutions Inc.',
      'email': 'contact@techsolutions.com',
      'phone': '+91 9876543210',
      'website': 'www.techsolutions.com',
      'services': ['Web Development', 'Mobile Apps', 'UI/UX Design', 'Consulting'],
      'rating': 4.8,
      'totalReviews': 42,
      'completedProjects': 56,
      'memberSince': '2023-01-15',
      'description': 'We provide top-notch digital solutions with 5+ years of experience. Specialized in Flutter, React, and Node.js development.',
      'address': '123 Tech Park, Sector 5',
      'city': 'Bangalore',
      'state': 'Karnataka',
      'pincode': '560001',
      'businessType': 'Private Limited',
      'yearsOfExperience': 5,
      'teamSize': '10-50',
      'verificationStatus': 'Verified',
      'badges': ['Top Rated', 'Fast Delivery', 'Great Communication'],
    };

    isLoading.value = false;
  }

  void loadStats() {
    stats.value = {
      'activeAssignments': 3,
      'pendingProposals': 5,
      'completedProjects': 56,
      'totalEarnings': 1250000,
      'avgRating': 4.8,
      'responseRate': 95,
      'onTimeDelivery': 92,
    };
  }

  void loadRecentActivity() {
    recentActivity.value = [
      {
        'type': 'proposal_submitted',
        'title': 'Submitted proposal for E-commerce Project',
        'time': '2 hours ago',
        'status': 'Pending',
      },
      {
        'type': 'milestone_completed',
        'title': 'Completed UI Design milestone',
        'time': '1 day ago',
        'project': 'Mobile App Development',
      },
      {
        'type': 'payment_received',
        'title': 'Received payment of ₹25,000',
        'time': '2 days ago',
        'amount': 25000,
      },
      {
        'type': 'new_review',
        'title': 'Received 5-star review from ABC Corp',
        'time': '3 days ago',
        'rating': 5,
      },
    ];
  }

  void editProfile() {
    Get.toNamed(AppRoutes.serviceProviderEditProfile);
  }

  void manageServices() {
    Get.toNamed(AppRoutes.serviceProviderManageServices);
  }

  void viewPortfolio() {
    Get.toNamed(AppRoutes.serviceProviderPortfolio);
  }

  void viewCertifications() {
    Get.toNamed(AppRoutes.serviceProviderCertifications);
  }

  void viewEarnings() {
    Get.toNamed(AppRoutes.serviceProviderEarnings);
  }

  void viewReviews() {
    Get.toNamed(AppRoutes.serviceProviderReviews);
  }

  void viewAnalytics() {
    Get.toNamed('/service-provider/analytics');
  }

  void viewSettings() {
    Get.toNamed(AppRoutes.serviceProviderSettings);
  }

  void logout() {
    Get.defaultDialog(
      title: 'Logout',
      middleText: 'Are you sure you want to logout?',
      textConfirm: 'Yes, Logout',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      onConfirm: () {
        // Clear session data
        Get.offAllNamed('/login');
      },
    );
  }
}