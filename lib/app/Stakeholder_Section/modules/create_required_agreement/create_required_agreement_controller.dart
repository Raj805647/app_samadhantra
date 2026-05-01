import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:samadhantra/app/constant/token_storage_service.dart';
import 'package:samadhantra/app/utils/app_config.dart';
import 'package:signature/signature.dart';

class CreateRequiredAgreementController extends GetxController {
  final SignatureController signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  RxDouble contractAmount = 0.0.obs;
  RxDouble remainingAmount = 0.0.obs;

  // Text Controllers
  final scopeDescriptionController = TextEditingController();
  final specificationsDeliverablesController = TextEditingController();
  final deliveryLocationController = TextEditingController();
  final contractAmountController = TextEditingController();
  final applicableTaxesController = TextEditingController();
  final milestone1AmountController = TextEditingController();
  final milestone2AmountController = TextEditingController();
  final milestone3AmountController = TextEditingController();
  final deliveryStartDateController = TextEditingController();
  final expectedCompletionDateController = TextEditingController();
  final jurisdictionCourtController = TextEditingController();

  // Observable values
  final totalPayableAmount = 0.0.obs;
  final isLoading = false.obs;

  // Timeline values
  final reqBidId = "".obs;
  final milestone1Timeline = "".obs;
  final requirementId = "".obs;
  final providerUserID = "".obs;
  final milestone2Timeline = "As per progress".obs;
  final milestone3Timeline = "On completion".obs;

  @override
  void onInit() {
    super.onInit();
    // Add listeners to auto-calculate total
    requirementId.value = Get.arguments['reqId'];
    reqBidId.value = Get.arguments['reqBidId'];
    providerUserID.value = Get.arguments['providerUserID'];
    // contractAmountController.addListener(calculateTotalPayable);
    // applicableTaxesController.addListener(calculateTotalPayable);
  }

  void calculateRemainingAmount() {
    final total = double.tryParse(contractAmountController.text) ?? 0;

    final m1 = double.tryParse(milestone1AmountController.text) ?? 0;
    final m2 = double.tryParse(milestone2AmountController.text) ?? 0;
    final m3 = double.tryParse(milestone3AmountController.text) ?? 0;

    contractAmount.value = total;

    final used = m1 + m2 + m3;
    remainingAmount.value = total - used;
  }

  @override
  void onClose() {
    // Dispose all controllers
    scopeDescriptionController.dispose();
    specificationsDeliverablesController.dispose();
    deliveryLocationController.dispose();
    contractAmountController.dispose();
    applicableTaxesController.dispose();
    milestone1AmountController.dispose();
    milestone2AmountController.dispose();
    milestone3AmountController.dispose();
    deliveryStartDateController.dispose();
    expectedCompletionDateController.dispose();
    jurisdictionCourtController.dispose();
    super.onClose();
  }

  void calculateTotalPayable() {
    double contractAmount = double.tryParse(contractAmountController.text) ?? 0;
    double applicableTaxes = double.tryParse(applicableTaxesController.text) ?? 0;
    totalPayableAmount.value = contractAmount + applicableTaxes;
  }

  Future<void> submitAgreement() async {
    // Validate all fields
    if (!_validateFields()) {
      return;
    }

    isLoading.value = true;

    try {
      // Prepare request body
      final userToken = await TokenService.getAccessToken();
      final image = await signatureController.toPngBytes();
      final signatureBase64 =
      image != null ? base64Encode(image) : "";
      print('akdjfnjkasdbkfjas=> ${requirementId.value}');
      Map<String, dynamic> requestBody = {
        "provider_user_id": providerUserID.value,
        "requirement_bid_id": reqBidId.value,
        "scope_description": scopeDescriptionController.text,
        "specifications_deliverables": specificationsDeliverablesController.text,
        "delivery_location": deliveryLocationController.text,
        "contract_amount": contractAmountController.text,
        "applicable_taxes": applicableTaxesController.text,
        "total_payable_amount": '${totalPayableAmount.value}',
        "milestone_1_amount": milestone1AmountController.text,
        "milestone_2_amount": milestone2AmountController.text,
        "milestone_3_amount": milestone3AmountController.text,
        "milestone_1_timeline": milestone1Timeline.value,
        "milestone_2_timeline": milestone2Timeline.value,
        "milestone_3_timeline": milestone3Timeline.value,
        "delivery_start_date": deliveryStartDateController.text,
        "expected_completion_date": expectedCompletionDateController.text,
        "jurisdiction_court": jurisdictionCourtController.text,
        "requester_signature": signatureBase64,
        "facilitator_signatory": "Samadhantra Authorized Signatory"
      };
      print(requestBody);

      // TODO: Make your API call here
      final url = Uri.parse('${AppConfig.baseUrl}/requirements/${requirementId.value}/agreements');
      print(url);
      final response = await http.post(url, body: jsonEncode(requestBody),headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "bearer $userToken",
      });
      print('adfbsdabfhbsda');
      print(url);
      print(response.statusCode);
      print(response.body);
      if(response.statusCode == 200){
        // For demo, just show success
        Get.back();
        Get.snackbar(
          "Success",
          "Agreement created successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }

    } catch (e) {
      print('adfkjbsdabf=> $e');
      Get.snackbar(
        "Error",
        "Failed to create agreement: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateFields() {
    if (scopeDescriptionController.text.isEmpty) {
      _showError("Scope Description is required");
      return false;
    }
    if (specificationsDeliverablesController.text.isEmpty) {
      _showError("Specifications & Deliverables is required");
      return false;
    }
    if (deliveryLocationController.text.isEmpty) {
      _showError("Delivery Location is required");
      return false;
    }
    if (contractAmountController.text.isEmpty) {
      _showError("Contract Amount is required");
      return false;
    }
    if (deliveryStartDateController.text.isEmpty) {
      _showError("Delivery Start Date is required");
      return false;
    }
    if (expectedCompletionDateController.text.isEmpty) {
      _showError("Expected Completion Date is required");
      return false;
    }
    if (jurisdictionCourtController.text.isEmpty) {
      _showError("Jurisdiction Court is required");
      return false;
    }
    return true;
  }

  void _showError(String message) {
    Get.snackbar(
      "Validation Error",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}