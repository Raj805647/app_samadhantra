import 'package:get/get.dart';
import 'package:flutter/material.dart';

import '../../../constant/token_storage_service.dart';
import '../../../data/api_service.dart';
import '../../../data/model/assignment_details_response.dart';
import '../../../utils/app_config.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AssignmentDetailsController extends GetxController {
  final apiService = ApiService();

  /// DATA
  Rx<AssignmentDetailsData> assignmentDetails = AssignmentDetailsData().obs;

  /// STATE
  final isLoading = false.obs;
  final isSubmitting = false.obs;

  /// INPUTS
  final rating = 0.0.obs;
  final commentController = TextEditingController();

  /// PARAMS
  final agreementId = ''.obs;
  final progress = 0.obs; // ✅ use double (0–100)

  @override
  void onInit() {
    super.onInit();

    agreementId.value = Get.arguments['agreement_id'] ?? '';
    progress.value = Get.arguments['progress'];

    fetchAssignmentDetails();
  }

  /// ---------------------------
  /// FETCH DETAILS
  /// ---------------------------
  Future<void> fetchAssignmentDetails() async {
    try {
      isLoading(true);

      final url =
          '${AppConfig.baseUrl}${AppConfig.actionAssignment(agreementId.value)}';

      final response = await apiService.get(url);

      if (response.statusCode == 200) {
        assignmentDetails.value =
            AssignmentDetailsData.fromJson(response.data['data']);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load data");
    } finally {
      isLoading(false);
    }
  }

  /// ---------------------------
  /// COMMON REVIEW API
  /// ---------------------------
  Future<void> _submitReview({
    required String endpoint,
    required Map<String, dynamic> body,
  }) async {
    if (rating.value == 0) {
      Get.snackbar("Error", "Please select rating");
      return;
    }

    try {
      isSubmitting(true);

      final token = await TokenService.getAccessToken() ?? '';

      final url = '${AppConfig.baseUrl}$endpoint';

      final response = await apiService.post(
        url,
        data: body,
        headers: {
          'Content-Type': 'application/json', // ✅ fixed
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        Get.back(); // close bottom sheet/dialog
        Get.snackbar("Success", "Review submitted");
        _resetForm();
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isSubmitting(false); // ✅ correct placement
    }
  }

  /// ---------------------------
  /// REVIEW TYPES
  /// ---------------------------

  void submitInitialReview() {
    _submitReview(
      endpoint: AppConfig.actionInitialReview(agreementId.value),
      body: {
        "milestone_percent": progress.value,
        "rating": rating.value,
        "comment": commentController.text,
      },
    );
  }

  void submitFinalRequesterReview() {
    _submitReview(
      endpoint: AppConfig.actionFinalRequesterReview(agreementId.value),
      body: {
        "rating": rating.value,
        "comment": commentController.text,
      },
    );
  }

  void submitFinalProviderReview() {
    _submitReview(
      endpoint: AppConfig.actionFinalProviderReview(agreementId.value),
      body: {
        "rating": rating.value,
        "comment": commentController.text,
      },
    );
  }

  /// ---------------------------
  /// RESET FORM
  /// ---------------------------
  void _resetForm() {
    rating.value = 0;
    commentController.clear();
  }

  @override
  void onClose() {
    commentController.dispose();
    super.onClose();
  }
}