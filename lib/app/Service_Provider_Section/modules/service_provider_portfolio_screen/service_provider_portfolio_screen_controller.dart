// lib/app/modules/service_provider/controllers/service_provider_portfolio_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceProviderPortfolioController extends GetxController {
  var portfolioItems = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var selectedCategory = 'All'.obs;

  final List<String> categories = [
    'All',
    'Web Development',
    'Mobile Apps',
    'UI/UX Design',
    'Graphic Design',
    'Digital Marketing',
    'Other'
  ];

  @override
  void onInit() {
    super.onInit();
    loadPortfolio();
  }

  void loadPortfolio() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 1));

    portfolioItems.value = [
      {
        'id': '1',
        'title': 'E-commerce Website',
        'description': 'Complete e-commerce solution with payment integration',
        'category': 'Web Development',
        'client': 'ABC Retail',
        'year': '2023',
        'images': ['assets/images/login.png', 'assets/images/register.png'],
        'technologies': ['React', 'Node.js', 'MongoDB'],
        'duration': '3 months',
        'budget': '₹2,50,000',
        'results': 'Increased sales by 40%',
        'featured': true,
      },
      {
        'id': '2',
        'title': 'Fitness Mobile App',
        'description': 'Cross-platform fitness tracking application',
        'category': 'Mobile Apps',
        'client': 'FitLife Inc.',
        'year': '2023',
        'images': ['assets/images/register.png'],
        'technologies': ['Flutter', 'Firebase'],
        'duration': '4 months',
        'budget': '₹1,80,000',
        'results': '50K+ downloads',
        'featured': true,
      },
    ];

    isLoading.value = false;
  }

  void addPortfolioItem(Map<String, dynamic> item) {
    portfolioItems.add(item);
    Get.snackbar('Success', 'Portfolio item added');
  }

  void editPortfolioItem(String id, Map<String, dynamic> updates) {
    final index = portfolioItems.indexWhere((item) => item['id'] == id);
    if (index != -1) {
      portfolioItems[index].addAll(updates);
      portfolioItems.refresh();
      Get.snackbar('Success', 'Portfolio item updated');
    }
  }

  void deletePortfolioItem(String id) {
    Get.defaultDialog(
      title: 'Delete Portfolio Item',
      middleText: 'Are you sure you want to delete this portfolio item?',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      onConfirm: () {
        portfolioItems.removeWhere((item) => item['id'] == id);
        Get.back();
        Get.snackbar('Success', 'Portfolio item deleted');
      },
    );
  }

  void toggleFeatured(String id) {
    final index = portfolioItems.indexWhere((item) => item['id'] == id);
    if (index != -1) {
      portfolioItems[index]['featured'] = !portfolioItems[index]['featured'];
      portfolioItems.refresh();
    }
  }

  List<Map<String, dynamic>> get filteredPortfolio {
    if (selectedCategory.value == 'All') return portfolioItems;
    return portfolioItems.where((item) => item['category'] == selectedCategory.value).toList();
  }
}