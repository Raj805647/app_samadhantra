import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/data/model/service_service_model.dart';
import 'package:samadhantra/app/global_routes/app_routes.dart';

class ServiceProviderServiceDetailsController extends GetxController {
  final ServiceModel service = Get.arguments;

  var isLoading = false.obs;
  var isEditing = false.obs;
  var isDeleting = false.obs;
  var activeTab = 'overview'.obs;

  final List<Map<String, dynamic>> stats = <Map<String, dynamic>>[].obs;
  final List<Map<String, dynamic>> reviews = <Map<String, dynamic>>[].obs;
  final List<Map<String, dynamic>> orders = <Map<String, dynamic>>[].obs;
  final List<Map<String, dynamic>> analytics = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadServiceDetails();
  }

  Future<void> loadServiceDetails() async {
    isLoading.value = true;

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    // Load stats
    stats.assignAll([
      {'title': 'Total Orders', 'value': '24', 'icon': 'receipt', 'change': '+12%', 'isPositive': true},
      {'title': 'Avg. Rating', 'value': '4.8', 'icon': 'star', 'change': '+0.2', 'isPositive': true},
      {'title': 'Completion Rate', 'value': '96%', 'icon': 'check_circle', 'change': '+4%', 'isPositive': true},
      {'title': 'Response Time', 'value': '2h', 'icon': 'schedule', 'change': '-30m', 'isPositive': true},
    ]);

    // Load reviews
    reviews.assignAll([
      {
        'id': '1',
        'userName': 'John Doe',
        'userAvatar': '',
        'rating': 5,
        'comment': 'Excellent service! Delivered before deadline with great quality.',
        'date': '2 days ago',
        'project': 'E-commerce Website',
      },
      {
        'id': '2',
        'userName': 'Sarah Miller',
        'userAvatar': '',
        'rating': 4,
        'comment': 'Good work but communication could be better.',
        'date': '1 week ago',
        'project': 'Mobile App UI',
      },
      {
        'id': '3',
        'userName': 'Robert Chen',
        'userAvatar': '',
        'rating': 5,
        'comment': 'Highly professional and skilled developer.',
        'date': '2 weeks ago',
        'project': 'API Integration',
      },
    ]);

    // Load recent orders
    orders.assignAll([
      {
        'id': 'ORD-001',
        'clientName': 'Tech Solutions Inc.',
        'status': 'completed',
        'amount': 45000,
        'date': '2024-01-15',
        'deliveryDays': 14,
      },
      {
        'id': 'ORD-002',
        'clientName': 'StartUp XYZ',
        'status': 'in_progress',
        'amount': 25000,
        'date': '2024-01-20',
        'deliveryDays': 7,
      },
      {
        'id': 'ORD-003',
        'clientName': 'Enterprise Corp',
        'status': 'pending',
        'amount': 75000,
        'date': '2024-01-25',
        'deliveryDays': 30,
      },
    ]);

    // Load analytics data
    analytics.assignAll([
      {'month': 'Jan', 'orders': 8, 'revenue': 120000},
      {'month': 'Feb', 'orders': 12, 'revenue': 180000},
      {'month': 'Mar', 'orders': 10, 'revenue': 150000},
      {'month': 'Apr', 'orders': 15, 'revenue': 225000},
      {'month': 'May', 'orders': 18, 'revenue': 270000},
      {'month': 'Jun', 'orders': 20, 'revenue': 300000},
    ]);

    isLoading.value = false;
  }

  void changeTab(String tab) {
    activeTab.value = tab;
  }

  void editService() {
    // Get.toNamed(
    //   AppRoutes.serviceProviderEditService,
    //   arguments: service,
    // );
  }

  void toggleServiceStatus() {
    // In a real app, this would call an API
    Get.back();
  }

  void toggleFeaturedStatus() {
    // In a real app, this would call an API
    Get.back();
  }

  void duplicateService() {
    Get.back();
    // Navigate to add service with pre-filled data
    Get.toNamed(
      AppRoutes.serviceProviderAddService,
      arguments: service.copyWith(name: '${service.name} (Copy)'),
    );
  }

  void deleteService() {
    isDeleting.value = true;
    Get.defaultDialog(
      title: 'Delete Service',
      middleText: 'Are you sure you want to delete "${service.name}"? This action cannot be undone.',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      onConfirm: () {
        // In a real app, call API to delete
        Get.back(); // Close dialog
        Get.back(); // Go back to services list
        Get.snackbar(
          'Service Deleted',
          '${service.name} has been deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
        );
      },
      onCancel: () {
        isDeleting.value = false;
      },
    );
  }

  void updatePricing(double hourly, double daily, double project) {
    // In a real app, call API to update
    Get.back();
    Get.snackbar(
      'Pricing Updated',
      'Service pricing has been updated successfully',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void shareService() {
    // Share service link
    Get.snackbar(
      'Share Link Copied',
      'Service link copied to clipboard',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void viewOrderDetails(String orderId) {
    Get.toNamed(
      '/service-provider/order-details',
      arguments: {'orderId': orderId, 'service': service},
    );
  }

  void viewClientProfile(String clientId) {
    Get.toNamed(
      '/service-provider/client-profile',
      arguments: clientId,
    );
  }

  int getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return 0xFF4CAF50;
      case 'in_progress':
        return 0xFFFF9800;
      case 'pending':
        return 0xFF2196F3;
      default:
        return 0xFF9E9E9E;
    }
  }


  String getStatusText(String status) {
    switch (status) {
      case 'completed':
        return 'Completed';
      case 'in_progress':
        return 'In Progress';
      case 'pending':
        return 'Pending';
      default:
        return 'Unknown';
    }
  }

  double get totalRevenue {
    return orders.fold(
      0.0,
          (sum, order) => sum + ((order['amount'] ?? 0) as num).toDouble(),
    );
  }


  double get averageRating {
    if (reviews.isEmpty) return 0;
    final total = reviews.fold(0, (sum, review) => sum + (review['rating'] as int));
    return total / reviews.length;
  }
}