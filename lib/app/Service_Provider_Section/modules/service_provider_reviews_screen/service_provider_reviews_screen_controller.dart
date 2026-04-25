// lib/app/modules/service_provider/controllers/service_provider_reviews_controller.dart
import 'package:get/get.dart';

class ServiceProviderReviewsController extends GetxController {
  var reviews = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var averageRating = 4.8.obs;
  var totalReviews = 42.obs;
  var ratingDistribution = {}.obs;

  @override
  void onInit() {
    super.onInit();
    loadReviews();
    calculateStats();
  }

  void loadReviews() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 1));

    reviews.value = [
      {
        'id': '1',
        'clientName': 'ABC Enterprises',
        'clientPhoto': '',
        'rating': 5,
        'date': '2024-01-15',
        'comment': 'Excellent work! Delivered before deadline with high quality.',
        'project': 'Mobile App Development',
        'projectType': 'Technology',
        'response': 'Thank you for your kind words!',
        'responseDate': '2024-01-16',
      },
      {
        'id': '2',
        'clientName': 'XYZ Corp',
        'clientPhoto': '',
        'rating': 4,
        'date': '2024-01-10',
        'comment': 'Good communication and timely delivery. Would work again.',
        'project': 'Logo Design',
        'projectType': 'Design',
        'response': '',
        'responseDate': null,
      },
      {
        'id': '3',
        'clientName': 'Startup Co.',
        'clientPhoto': '',
        'rating': 5,
        'date': '2024-01-05',
        'comment': 'Professional team, great attention to detail.',
        'project': 'Website Redesign',
        'projectType': 'Web Development',
        'response': 'We appreciate your feedback!',
        'responseDate': '2024-01-06',
      },
    ];

    isLoading.value = false;
  }

  void calculateStats() {
    if (reviews.isEmpty) return;

    double total = 0;
    Map<int, int> distribution = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};

    for (var review in reviews) {
      total += review['rating'];
      distribution[review['rating']] = (distribution[review['rating']] ?? 0) + 1;
    }

    averageRating.value = total / reviews.length;
    totalReviews.value = reviews.length;
    ratingDistribution.value = distribution;
  }

  void addResponse(String reviewId, String response) {
    final index = reviews.indexWhere((review) => review['id'] == reviewId);
    if (index != -1) {
      reviews[index]['response'] = response;
      reviews[index]['responseDate'] = DateTime.now().toString().split(' ')[0];
      reviews.refresh();
      Get.snackbar('Success', 'Response added');
    }
  }

  void deleteResponse(String reviewId) {
    final index = reviews.indexWhere((review) => review['id'] == reviewId);
    if (index != -1) {
      reviews[index]['response'] = '';
      reviews[index]['responseDate'] = null;
      reviews.refresh();
      Get.snackbar('Success', 'Response deleted');
    }
  }

  List<Map<String, dynamic>> getReviewsByRating(int rating) {
    return reviews.where((review) => review['rating'] == rating).toList();
  }
}