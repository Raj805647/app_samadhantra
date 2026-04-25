import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/data/model/stake_review_model.dart';

class ProviderRatingsController extends GetxController {
  final RxList<ProviderRating> providers = <ProviderRating>[].obs;
  final RxList<ProviderRating> filteredProviders = <ProviderRating>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = 'all'.obs;
  final RxDouble minRating = 0.0.obs;
  final Rx<ProviderRating?> selectedProvider = null.obs;

  final List<String> categories = [
    'all',
    'mobile',
    'web',
    'design',
    'erp',
    'marketing',
    'consulting'
  ];

  final Map<String, String> categoryLabels = {
    'all': 'All Categories',
    'mobile': 'Mobile Development',
    'web': 'Web Development',
    'design': 'UI/UX Design',
    'erp': 'ERP Solutions',
    'marketing': 'Digital Marketing',
    'consulting': 'Business Consulting',
  };

  final Map<String, IconData> categoryIcons = {
    'mobile': Icons.phone_android,
    'web': Icons.web,
    'design': Icons.design_services,
    'erp': Icons.business,
    'marketing': Icons.ads_click,
    'consulting': Icons.business_center,
  };

  @override
  void onInit() {
    super.onInit();
    loadProviders();
  }

  Future<void> loadProviders() async {
    try {
      isLoading.value = true;

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      providers.value = [
        ProviderRating(
          providerId: 'provider_001',
          providerName: 'Tech Solutions Inc.',
          providerImage: '',
          providerCategory: 'mobile',
          averageRating: 4.8,
          totalReviews: 124,
          ratingDistribution: {5: 80, 4: 30, 3: 10, 2: 3, 1: 1},
          completedProjects: 156,
          experience: '7+ years',
          location: 'Bangalore, India',
          about: 'Specialized in Flutter and React Native mobile applications with extensive experience in e-commerce and enterprise apps.',
          recentReviews: [
            Review(
              id: 'r1',
              assignmentId: 'a1',
              assignmentTitle: 'E-commerce App',
              providerId: 'provider_001',
              providerName: 'Tech Solutions Inc.',
              rating: 5.0,
              comment: 'Excellent work! Delivered ahead of schedule with great quality.',
              reviewDate: DateTime.now().subtract(const Duration(days: 5)),
            ),
            Review(
              id: 'r2',
              assignmentId: 'a2',
              assignmentTitle: 'Fitness Tracking App',
              providerId: 'provider_001',
              providerName: 'Tech Solutions Inc.',
              rating: 4.5,
              comment: 'Great communication and professional approach.',
              reviewDate: DateTime.now().subtract(const Duration(days: 15)),
            ),
          ],
        ),
        ProviderRating(
          providerId: 'provider_002',
          providerName: 'Design Studio Pro',
          providerImage: '',
          providerCategory: 'design',
          averageRating: 4.3,
          totalReviews: 89,
          ratingDistribution: {5: 45, 4: 30, 3: 10, 2: 3, 1: 1},
          completedProjects: 112,
          experience: '5+ years',
          location: 'Mumbai, India',
          about: 'Award-winning UI/UX design agency specializing in user-centered design for web and mobile applications.',
          isFavorite: true,
        ),
        ProviderRating(
          providerId: 'provider_003',
          providerName: 'Web Masters',
          providerImage: '',
          providerCategory: 'web',
          averageRating: 4.6,
          totalReviews: 156,
          ratingDistribution: {5: 100, 4: 40, 3: 12, 2: 3, 1: 1},
          completedProjects: 189,
          experience: '8+ years',
          location: 'Delhi, India',
          about: 'Full-stack web development agency with expertise in React, Node.js, and modern web technologies.',
        ),
        ProviderRating(
          providerId: 'provider_004',
          providerName: 'ERP Solutions Ltd.',
          providerImage: '',
          providerCategory: 'erp',
          averageRating: 4.9,
          totalReviews: 67,
          ratingDistribution: {5: 60, 4: 5, 3: 2, 2: 0, 1: 0},
          completedProjects: 78,
          experience: '10+ years',
          location: 'Pune, India',
          about: 'Enterprise resource planning specialists with deep expertise in SAP, Oracle, and custom ERP solutions.',
        ),
        ProviderRating(
          providerId: 'provider_005',
          providerName: 'Digital Innovators',
          providerImage: '',
          providerCategory: 'mobile',
          averageRating: 4.1,
          totalReviews: 45,
          ratingDistribution: {5: 20, 4: 15, 3: 8, 2: 1, 1: 1},
          completedProjects: 56,
          experience: '4+ years',
          location: 'Chennai, India',
          about: 'Innovative mobile app development company focusing on cutting-edge technologies and user experience.',
        ),
        ProviderRating(
          providerId: 'provider_006',
          providerName: 'Marketing Gurus',
          providerImage: '',
          providerCategory: 'marketing',
          averageRating: 4.7,
          totalReviews: 92,
          ratingDistribution: {5: 70, 4: 18, 3: 3, 2: 1, 1: 0},
          completedProjects: 120,
          experience: '6+ years',
          location: 'Hyderabad, India',
          about: 'Digital marketing experts specializing in SEO, social media, and content marketing strategies.',
        ),
      ];

      applyFilters();

    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load providers: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilters() {
    List<ProviderRating> result = providers;

    // Apply category filter
    if (selectedCategory.value != 'all') {
      result = result.where((provider) => provider.providerCategory == selectedCategory.value).toList();
    }

    // Apply rating filter
    result = result.where((provider) => provider.averageRating >= minRating.value).toList();

    // Apply search filter
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      result = result.where((provider) {
        return provider.providerName.toLowerCase().contains(query) ||
            provider.providerCategory.toLowerCase().contains(query) ||
            provider.about.toLowerCase().contains(query);
      }).toList();
    }

    // Sort by rating (highest first)
    result.sort((a, b) => b.averageRating.compareTo(a.averageRating));

    filteredProviders.value = result;
  }

  void setCategory(String category) {
    selectedCategory.value = category;
    applyFilters();
  }

  void setMinRating(double rating) {
    minRating.value = rating;
    applyFilters();
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  void viewProviderDetails(ProviderRating provider) {
    selectedProvider.value = provider;
    Get.toNamed('/provider-details', arguments: {'providerId': provider.providerId});
  }

  void toggleFavorite(String providerId) {
    final index = providers.indexWhere((p) => p.providerId == providerId);
    if (index != -1) {
      // Create updated provider with toggled favorite status
      final provider = providers[index];
      final updatedProvider = ProviderRating(
        providerId: provider.providerId,
        providerName: provider.providerName,
        providerImage: provider.providerImage,
        providerCategory: provider.providerCategory,
        averageRating: provider.averageRating,
        totalReviews: provider.totalReviews,
        ratingDistribution: provider.ratingDistribution,
        completedProjects: provider.completedProjects,
        experience: provider.experience,
        location: provider.location,
        about: provider.about,
        recentReviews: provider.recentReviews,
        isFavorite: !provider.isFavorite,
      );

      providers[index] = updatedProvider;
      applyFilters();
    }
  }

  void refreshProviders() {
    loadProviders();
  }

  double get highestRating {
    if (providers.isEmpty) return 0.0;
    return providers.map((p) => p.averageRating).reduce((a, b) => a > b ? a : b);
  }

  double get averageRatingAcrossProviders {
    if (providers.isEmpty) return 0.0;
    final total = providers.fold(0.0, (sum, provider) => sum + provider.averageRating);
    return total / providers.length;
  }
}