// lib/app/modules/service_provider/controllers/service_provider_submit_proposal_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class ServiceProviderSubmitProposalController extends GetxController {
  var isLoading = false.obs;
  var requirementId = ''.obs;

  // Form fields
  var proposedAmount = ''.obs;
  var timeline = ''.obs;
  var description = ''.obs;
  var portfolioItems = <String>[].obs;
  var attachments = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    requirementId.value = Get.arguments ?? '';
  }

  void addPortfolioItem(String item) {
    portfolioItems.add(item);
  }

  void addAttachment(String filePath) {
    attachments.add(filePath);
  }

  void submitProposal() async {
    if (proposedAmount.isEmpty || timeline.isEmpty || description.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all required fields',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    // Simulate API call
    await Future.delayed(Duration(seconds: 2));

    isLoading.value = false;

    Get.snackbar(
      'Success',
      'Proposal submitted successfully',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    Get.until((route) => route.settings.name == '/service-provider/proposals');
  }
}