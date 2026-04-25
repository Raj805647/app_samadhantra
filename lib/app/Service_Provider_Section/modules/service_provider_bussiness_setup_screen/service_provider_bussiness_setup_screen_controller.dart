// lib/app/modules/service_provider/controllers/service_provider_business_setup_controller.dart
import 'package:get/get.dart';

class ServiceProviderBusinessSetupController extends GetxController {
  var currentSetupStep = 0.obs;
  var isLoading = false.obs;

  // Portfolio
  var portfolioItems = <Map<String, dynamic>>[].obs;

  // Certifications
  var certifications = <Map<String, dynamic>>[].obs;

  // Payment Methods
  var paymentMethods = <Map<String, dynamic>>[].obs;

  // Bank Details
  var accountName = ''.obs;
  var accountNumber = ''.obs;
  var ifscCode = ''.obs;
  var bankName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  void loadInitialData() {
    // Load any existing data
  }

  void nextStep() {
    if (currentSetupStep.value < 3) {
      currentSetupStep.value++;
    } else {
      completeSetup();
    }
  }

  void previousStep() {
    if (currentSetupStep.value > 0) {
      currentSetupStep.value--;
    }
  }

  void addPortfolioItem(Map<String, dynamic> item) {
    portfolioItems.add(item);
  }

  void addCertification(Map<String, dynamic> cert) {
    certifications.add(cert);
  }

  void addPaymentMethod(Map<String, dynamic> method) {
    paymentMethods.add(method);
  }

  void completeSetup() async {
    isLoading.value = true;

    // Save all setup data
    await Future.delayed(Duration(seconds: 1));

    isLoading.value = false;

    Get.offAllNamed('/service-provider');
  }
}