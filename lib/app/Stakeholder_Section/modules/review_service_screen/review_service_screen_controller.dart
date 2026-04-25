// controllers/review_service_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/constant/custom_snackbar.dart';
import 'package:samadhantra/app/data/model/stake_review_model.dart';

class ReviewServiceController extends GetxController {
  final RxDouble selectedRating = 0.0.obs;
  final TextEditingController commentController = TextEditingController();
  final RxList<String> selectedTags = <String>[].obs;
  final RxBool wouldRecommend = true.obs;
  final RxBool isLoading = false.obs;
  final RxBool isSubmitting = false.obs;

  // Available tags for selection
  final List<String> availableTags = [
    'Excellent Service',
    'On-time Delivery',
    'Great Communication',
    'High Quality Work',
    'Professional',
    'Good Value',
    'Responsive',
    'Creative Solution',
    'Attention to Detail',
    'Easy to Work With',
  ];

  // Assignment details
  final RxString assignmentId = ''.obs;
  final RxString assignmentTitle = ''.obs;
  final RxString providerId = ''.obs;
  final RxString providerName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    getAssignmentDetails();
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }

  void getAssignmentDetails() {
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      assignmentId.value = args['assignmentId']?.toString() ?? '';
      assignmentTitle.value = args['assignmentTitle']?.toString() ?? 'Completed Assignment';
      providerId.value = args['providerId']?.toString() ?? '';
      providerName.value = args['providerName']?.toString() ?? 'Service Provider';
    }
  }

  void setRating(double rating) {
    selectedRating.value = rating;
  }

  void toggleTag(String tag) {
    if (selectedTags.contains(tag)) {
      selectedTags.remove(tag);
    } else {
      if (selectedTags.length < 3) {
        selectedTags.add(tag);
      } else {
        Get.snackbar(
          'Maximum Tags',
          'You can select up to 3 tags only',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    }
  }

  bool validateForm() {
    if (selectedRating.value == 0.0) {
      Get.snackbar(
        'Rating Required',
        'Please select a rating',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (commentController.text.trim().isEmpty) {
      Get.snackbar(
        'Comment Required',
        'Please write your review',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (commentController.text.trim().length < 10) {
      Get.snackbar(
        'Review Too Short',
        'Please write at least 10 characters',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }

  Future<void> submitReview() async {
    if (!validateForm()) return;

    try {
      isSubmitting.value = true;

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Create review object
      final review = Review(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        assignmentId: assignmentId.value,
        assignmentTitle: assignmentTitle.value,
        providerId: providerId.value,
        providerName: providerName.value,
        rating: selectedRating.value,
        comment: commentController.text.trim(),
        tags: selectedTags,
        reviewDate: DateTime.now(),
        wouldRecommend: wouldRecommend.value,
        createdAt: DateTime.now(),
      );

      // Here you would save to your backend
      print('Review submitted: ${review.id}');
        CustomSnackBar.success("Review Submitted!");
      // Show success message
      // Get.snackbar(
      //   'Review Submitted!',
      //   'Thank you for your feedback',
      //   snackPosition: SnackPosition.BOTTOM,
      //   backgroundColor: Colors.green,
      //   colorText: Colors.white,
      //   duration: const Duration(seconds: 3),
      // );
      print("done");

      // Navigate back with success
      Get.back(result: true);

    } catch (e) {
      Get.snackbar(
        'Submission Failed',
        'Failed to submit review: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubmitting.value = false;
    }
  }

  void clearForm() {
    selectedRating.value = 0.0;
    commentController.clear();
    selectedTags.clear();
    wouldRecommend.value = true;
  }

  String get ratingDescription {
    if (selectedRating.value >= 4.5) return 'Excellent';
    if (selectedRating.value >= 4.0) return 'Very Good';
    if (selectedRating.value >= 3.0) return 'Good';
    if (selectedRating.value >= 2.0) return 'Fair';
    if (selectedRating.value >= 1.0) return 'Poor';
    return 'Not Rated';
  }

  Color get ratingDescriptionColor {
    if (selectedRating.value >= 4.5) return Colors.green;
    if (selectedRating.value >= 4.0) return Colors.lightGreen;
    if (selectedRating.value >= 3.0) return Colors.orange;
    if (selectedRating.value >= 2.0) return Colors.orange[300]!;
    if (selectedRating.value >= 1.0) return Colors.red;
    return Colors.grey;
  }
}