// controllers/my_reviews_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/data/model/stake_review_model.dart';

class MyReviewsController extends GetxController {
  final RxList<Review> reviews = <Review>[].obs;
  final RxList<Review> filteredReviews = <Review>[].obs;
  final RxBool isLoading = false.obs;
  final RxString selectedFilter = 'all'.obs;
  final RxString searchQuery = ''.obs;

  final List<String> filters = ['all', 'recent', 'positive', 'negative'];
  final Map<String, String> filterLabels = {
    'all': 'All Reviews',
    'recent': 'Recent',
    'positive': 'Positive (4+)',
    'negative': 'Needs Improvement',
  };

  @override
  void onInit() {
    super.onInit();
    loadReviews();
  }

  Future<void> loadReviews() async {
    try {
      isLoading.value = true;

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      reviews.value = [
        Review(
          id: '1',
          assignmentId: '1',
          assignmentTitle: 'Mobile App Development',
          providerId: 'provider_001',
          providerName: 'Tech Solutions Inc.',
          rating: 4.8,
          comment: 'Excellent work! The team delivered a high-quality mobile app ahead of schedule. Great communication throughout the project.',
          tags: ['Excellent Service', 'On-time Delivery', 'Great Communication'],
          reviewDate: DateTime.now().subtract(const Duration(days: 5)),
          wouldRecommend: true,
        ),
        Review(
          id: '2',
          assignmentId: '2',
          assignmentTitle: 'UI/UX Design',
          providerId: 'provider_002',
          providerName: 'Design Studio Pro',
          rating: 3.5,
          comment: 'Good design work but there were some delays in delivery. The final result was satisfactory.',
          tags: ['Creative', 'Good Value'],
          reviewDate: DateTime.now().subtract(const Duration(days: 12)),
          wouldRecommend: true,
        ),
        Review(
          id: '3',
          assignmentId: '3',
          assignmentTitle: 'Website Redesign',
          providerId: 'provider_003',
          providerName: 'Web Masters',
          rating: 2.5,
          comment: 'The website looks good but there were several bugs that needed fixing. Response time could be better.',
          tags: ['Needs Improvement'],
          reviewDate: DateTime.now().subtract(const Duration(days: 20)),
          wouldRecommend: false,
        ),
        Review(
          id: '4',
          assignmentId: '4',
          assignmentTitle: 'ERP System Integration',
          providerId: 'provider_004',
          providerName: 'ERP Solutions Ltd.',
          rating: 5.0,
          comment: 'Outstanding service! The team was professional, knowledgeable, and delivered beyond expectations. Highly recommended!',
          tags: ['Professional', 'High Quality', 'Excellent Service'],
          reviewDate: DateTime.now().subtract(const Duration(days: 35)),
          wouldRecommend: true,
        ),
        Review(
          id: '5',
          assignmentId: '5',
          assignmentTitle: 'E-commerce Platform',
          providerId: 'provider_005',
          providerName: 'Digital Commerce Experts',
          rating: 4.2,
          comment: 'Very satisfied with the e-commerce platform. Good support after deployment as well.',
          tags: ['Responsive', 'Good Support'],
          reviewDate: DateTime.now().subtract(const Duration(days: 50)),
          wouldRecommend: true,
        ),
      ];

      applyFilters();

    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load reviews: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void applyFilters() {
    List<Review> result = reviews;

    // Apply rating filter
    if (selectedFilter.value == 'positive') {
      result = result.where((review) => review.rating >= 4.0).toList();
    } else if (selectedFilter.value == 'negative') {
      result = result.where((review) => review.rating < 3.0).toList();
    } else if (selectedFilter.value == 'recent') {
      result = result.where((review) {
        return review.reviewDate.isAfter(DateTime.now().subtract(const Duration(days: 30)));
      }).toList();
    }

    // Apply search filter
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      result = result.where((review) {
        return review.providerName.toLowerCase().contains(query) ||
            review.assignmentTitle.toLowerCase().contains(query) ||
            review.comment.toLowerCase().contains(query);
      }).toList();
    }

    // Sort by date (newest first)
    result.sort((a, b) => b.reviewDate.compareTo(a.reviewDate));

    filteredReviews.value = result;
  }

  void setFilter(String filter) {
    selectedFilter.value = filter;
    applyFilters();
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  double get averageRating {
    if (reviews.isEmpty) return 0.0;
    final total = reviews.fold(0.0, (sum, review) => sum + review.rating);
    return total / reviews.length;
  }

  int get totalReviews => reviews.length;

  Map<int, int> get ratingDistribution {
    final distribution = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (final review in reviews) {
      final rating = review.rating.floor();
      if (distribution.containsKey(rating)) {
        distribution[rating] = distribution[rating]! + 1;
      }
    }
    return distribution;
  }

  void refreshReviews() {
    loadReviews();
  }
}