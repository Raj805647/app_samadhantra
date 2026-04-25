import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:samadhantra/app/Stakeholder_Section/modules/razorpay_screen/razorpay_controller.dart';
import 'package:samadhantra/app/constant/custom_snackbar.dart';
import 'package:samadhantra/app/constant/token_storage_service.dart';
import 'package:samadhantra/app/data/api_service.dart';
import 'package:samadhantra/app/data/model/stake_holder_model/create_payment_request_model.dart';
import 'package:samadhantra/app/data/model/stake_holder_model/dynamic_form_model.dart';
import 'package:samadhantra/app/data/model/stake_holder_model/registration_model.dart';
import 'package:samadhantra/app/data/model/user_data_model.dart';
import 'package:samadhantra/app/global_routes/app_routes.dart';
import 'package:samadhantra/app/modules/auth/signup_screen/signup_screen_controller.dart';
import 'package:samadhantra/app/utils/app_config.dart';


class CompleteProfileController extends GetxController {
  // Existing form fields (keep them for backward compatibility)
  final companyNameController = TextEditingController();
  final referenceController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final aboutController = TextEditingController();

  // Dynamic form fields - Temporary storage for UI
  final formData = <String, dynamic>{}.obs;
  final formResponse = Rxn<DynamicFormResponse>();
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Existing observable variables
  var selectedRole = ''.obs;
  var selectedAmount = 0.0.obs;
  var companyLogo = Rx<File?>(null);
  var companyLogoUrl = ''.obs;
  var isUploading = false.obs;

  final RazorpayController _controller = Get.find();

  // Validation
  final formKey = GlobalKey<FormState>();
  final ApiService _apiService = ApiService();

  // ========== REGISTRATION DATA ==========
  Rx<RegistrationModel> get registrationData =>
      SignupScreenController.to.registrationData;

  // Track current step
  final RxInt currentStep = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Get role and subscription amount from previous screen (role_selection)
    selectedRole.value = Get.arguments?['selectedRole']?.toString() ?? '';
    final subsAmount = Get.arguments?['subsAmount'];
    selectedAmount.value = (subsAmount is num) ? subsAmount.toDouble() : 0.0;

    // Set user type in registration model
    registrationData.update((val) {
      val?.userType = selectedRole.value;
    });

    // Initialize dynamic form when controller loads
    getUserTypeFormApi(selectedRole.value);
  }

  // ========== REGISTRATION MODEL METHODS ==========

  // Update Personal Info
  void updatePersonalInfo({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? password,
  }) {
    registrationData.update((val) {
      val?.fullName = fullName;
      val?.email = email;
      val?.phoneNumber = phoneNumber;
      val?.password = password;
    });
  }

  // Update Location Info
  void updateLocationInfo({
    String? address,
    String? city,
    String? state,
    double? latitude,
    double? longitude,
  }) {
    registrationData.update((val) {
      val?.address = address;
      val?.city = city;
      val?.state = state;
      val?.latitude = latitude;
      val?.longitude = longitude;
    });
  }

  // Update About Info
  void updateAboutInfo({
    String? aboutYourself,
    String? referenceNumber,
  }) {
    registrationData.update((val) {
      val?.aboutYourself = aboutYourself;
      val?.referenceNumber = referenceNumber;
    });
  }

  // Update Category Info
  void updateCategoryInfo({
    String? objective,
    List<String>? category,
    String? customCategory,
    List<String>? subCategory,
    String? customSubCategory,
    String? describeYourNeed,
  }) {
    registrationData.update((val) {
      val?.objective = objective;
      val?.category = category;
      val?.customCategory = customCategory;
      val?.subCategory = subCategory;
      val?.customSubCategory = customSubCategory;
      val?.describeYourNeed = describeYourNeed;
    });
  }

  // Update User Type
  void updateUserType(String userType) {
    registrationData.update((val) {
      val?.userType = userType;
    });
  }

  // ========== DYNAMIC FIELDS METHODS ==========

  // Add single dynamic field to registration model
  void addExtraField(String key, dynamic value) {
    registrationData.update((val) {
      val?.setExtraField(key, value);
    });
  }

  // Add multiple dynamic fields to registration model
  void addExtraFields(Map<String, dynamic> fields) {
    registrationData.update((val) {
      val?.extraFields.addAll(fields);
    });
  }

  // Get dynamic field from registration model
  dynamic getExtraField(String key) {
    return registrationData.value.getExtraField(key);
  }

  // Save all formData to registration model
  void saveDynamicFormToRegistration() {
    // Filter out null or empty values
    final Map<String, dynamic> validData = {};

    formData.forEach((key, value) {
      if (value != null &&
          value.toString().trim().isNotEmpty &&
          value.toString() != 'null') {
        validData[key] = value;
      }
    });

    // Save to registration model
    addExtraFields(validData);

    debugPrint("💾 Saved dynamic fields to registration model:");
    debugPrint("Total fields saved: ${validData.length}");
    debugPrint("Data: ${validData.toString()}");
  }

  // Load saved dynamic fields from registration model to formData
  void loadSavedDynamicFields() {
    if (formResponse.value == null) return;

    final savedFields = registrationData.value.extraFields;

    formResponse.value!.fields.forEach((key, field) {
      // Check if we have saved value for this field
      if (savedFields.containsKey(key) && savedFields[key] != null) {
        formData[key] = savedFields[key];
        debugPrint("📥 Loaded saved value for $key: ${savedFields[key]}");
      }
    });
  }

  // ========== VALIDATION METHODS ==========
  bool validateStep1() {
    final data = registrationData.value;
    return data.fullName != null &&
        data.fullName!.isNotEmpty &&
        data.email != null &&
        data.email!.isNotEmpty &&
        data.phoneNumber != null &&
        data.phoneNumber!.isNotEmpty &&
        data.password != null &&
        data.password!.isNotEmpty;
  }

  bool validateStep2() {
    final data = registrationData.value;
    return data.address != null &&
        data.address!.isNotEmpty &&
        data.city != null &&
        data.city!.isNotEmpty &&
        data.state != null &&
        data.state!.isNotEmpty;
  }

  // ========== RESET METHODS ==========
  void resetData() {
    registrationData.value = RegistrationModel();
    currentStep.value = 0;
    formData.clear();
  }

  void clearExtraFields() {
    registrationData.update((val) {
      val?.extraFields.clear();
    });
  }

  // ========== GETTERS FOR UI ==========
  String get fullName => registrationData.value.fullName ?? '';
  String get email => registrationData.value.email ?? '';
  String get userType => registrationData.value.userType ?? 'student';

  // ========== DYNAMIC FORM API METHODS ==========

  // Fetch dynamic form configuration based on user type
  Future<void> getUserTypeFormApi(String? userType) async {
    try {
      isLoading(true);
      update();
      errorMessage('');

      final response = await _apiService.get(
        AppConfig.getUSerTypeFormUrl(userType),
      );

      debugPrint("✅ RESPONSE: ${response.data}");

      if (response.data != null && response.data['data']['user_type'] != null) {
        // Direct response format (as shown in your log)
        formResponse.value = DynamicFormResponse.fromJson(response.data['data']);

        // Initialize form data
        initializeFormData();

        // Load any previously saved dynamic fields
        loadSavedDynamicFields();

        debugPrint(
          "✅ Form loaded successfully for user type: ${formResponse.value?.userType}",
        );
        debugPrint("✅ Number of fields: ${formResponse.value?.fields.length}");

        // Update user_type in registration model
        updateUserType(userType ?? '');
      } else {
        debugPrint("❌ Response data is null or missing user_type");
        throw Exception("Invalid response format: Missing user_type");
      }
    } catch (e, stackTrace) {
      debugPrint("❌ API ERROR: $e");
      debugPrint("❌ STACK TRACE: $stackTrace");
      errorMessage(e.toString());

      CustomSnackBar.error(
        title: "Something went wrong",
        "Failed to load form configuration",
      );
    } finally {
      isLoading(false);
      update();
    }
  }

  // Initialize form data with empty values
  void initializeFormData() {
    if (formResponse.value == null) return;

    formData.clear();
    formResponse.value!.fields.forEach((key, field) {
      // Initialize with empty values based on field type
      if (field.type == 'select') {
        formData[key] = null;
      } else if (field.type == 'number') {
        formData[key] = null;
      } else if (field.type == 'checkbox') {
        formData[key] = false;
      } else {
        formData[key] = '';
      }
    });
  }

  // Update form value (both temporary and registration model)
  void updateFormValue(String key, dynamic value) {
    formData[key] = value;

    // Also update registration model immediately
    addExtraField(key, value);

    update();
  }

  // Check if field should be visible based on dependencies
  bool isFieldVisible(DynamicFormField field) {
    if (field.dependsOn == null) return true;

    final dependentFieldValue = formData[field.dependsOn!.field];
    return dependentFieldValue == field.dependsOn!.value;
  }

  // Get sorted fields by order
  List<DynamicFormField> getSortedFields() {
    if (formResponse.value == null) return [];

    return formResponse.value!.fields.values.toList()
      ..sort((a, b) => a.order.compareTo(b.order));
  }

  // Validate the form
  bool validateForm() {
    if (formResponse.value == null) {
      Get.snackbar('Error', 'Form configuration not loaded');
      return false;
    }

    bool isValid = true;

    for (var entry in formResponse.value!.fields.entries) {
      final field = entry.value;
      final value = formData[field.key];

      // Skip validation if field is not visible
      if (!isFieldVisible(field)) continue;

      if (field.required && (value == null || value.toString().isEmpty)) {
        CustomSnackBar.error(
          title: "Validation Error",
          "${field.label} is required",
        );
        isValid = false;
        continue;
      }

      if (value != null && value.toString().isNotEmpty) {
        // Validate min/max length for strings
        if (field.minLength != null &&
            value.toString().length < field.minLength!) {
          Get.snackbar(
            'Validation Error',
            '${field.label} must be at least ${field.minLength} characters',
          );
          isValid = false;
          continue;
        }

        if (field.maxLength != null &&
            value.toString().length > field.maxLength!) {
          Get.snackbar(
            'Validation Error',
            '${field.label} must not exceed ${field.maxLength} characters',
          );
          isValid = false;
          continue;
        }

        // Validate min/max for numbers
        if (field.type == 'number' && value is num) {
          if (field.min != null && value < field.min!) {
            Get.snackbar(
              'Validation Error',
              '${field.label} must be at least ${field.min}',
            );
            isValid = false;
            continue;
          }

          if (field.max != null && value > field.max!) {
            Get.snackbar(
              'Validation Error',
              '${field.label} must not exceed ${field.max}',
            );
            isValid = false;
            continue;
          }
        }
      }
    }

    return isValid;
  }

  // ========== COMPLETE REGISTRATION API CALL ==========
  /// [skipNavigation] when true, on success does not navigate nor resetData (used before opening Razorpay).
  Future<bool> submitRegistration({bool skipNavigation = false}) async {
    try {
      isLoading.value = true;
      update();

      // 1️⃣ Save dynamic form into model
      saveDynamicFormToRegistration();

      // 2️⃣ Prepare final request body
      final Map<String, dynamic> finalData = {};
      finalData.addAll(registrationData.value.toJson());

      debugPrint("📦 Final registration data:");
      debugPrint(finalData.toString());

      // 3️⃣ Call API
      final response = await _apiService.post(
        '${AppConfig.baseUrl}/register',
        data: finalData,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = response.data;

        if (responseData == null) {
          throw Exception("Invalid server response");
        }

        /// 🔹 Extract user json safely
        final userJson =
            responseData['data']?['user'] ?? responseData['data'];

        if (userJson != null && userJson is Map<String, dynamic>) {
          final userModel = ProfileData.fromJson(userJson);

          // ✅ SAVE USER MODEL LOCALLY
          await TokenService.saveUser(userModel);
          await TokenService.saveUserId(userModel.id ?? '');
        }

        CustomSnackBar.success(
          title: "Success",
          "Registration completed successfully!",
        );

        if (!skipNavigation) {
          resetData();
          Get.offAllNamed(AppRoutes.bottomnavScreen);
        }
        return true;
      } else {
        CustomSnackBar.error(
          title: "Error",
          response.data?['detail']['msg'] ?? 'Registration failed',
        );
        return false;
      }
    } catch (e, stack) {
      debugPrint("❌ Registration error: $e");
      debugPrintStack(stackTrace: stack);

      CustomSnackBar.error(
        title: "Error",
        "$e",
      );
      return false;
    } finally {
      isLoading.value = false;
      update();
    }
  }


  // ========== FORM SUBMISSION (For dynamic form screen) ==========
  /// Validates form, submits registration, then opens Razorpay checkout with [selectedAmount].
  /// Payment success: verifies with backend, then navigates to bottom nav.
  Future<void> submitForm() async {
    if (!validateForm()) return;

    try {
      isLoading(true);
      update();

      // Save dynamic form data to registration model
      saveDynamicFormToRegistration();

      // ✅ PRINT COMPLETE REGISTRATION MODEL DATA
      _printCompleteRegistrationData();

      // 1️⃣ Submit registration (do not navigate yet when we have payment)
      final registered = await submitRegistration(skipNavigation: true);
      if (!registered) return;

      final amount = selectedAmount.value;
      final data = registrationData.value;

      // 2️⃣ If no amount, go to home without payment
      if (amount <= 0) {
        resetData();
        Get.offAllNamed(AppRoutes.bottomnavScreen);
        return;
      }

      // 3️⃣ Open Razorpay checkout with dynamic amount and user details
      _controller.openCheckout(
        amount: amount,
        currency: 'INR',
        name: data.fullName ?? 'User',
        email: data.email ?? '',
        contact: data.phoneNumber ?? '',
        description: 'Subscription - ${selectedRole.value}',
        notes: {
          'user_type': selectedRole.value,
          'payment_type': 'subscription',
        },
        onPaymentSuccess: (response) async {
          try {
            final orderId = response.orderId;
            final paymentId = response.paymentId;
            final signature = response.signature;
            if (orderId != null &&
                orderId.isNotEmpty &&
                paymentId != null &&
                paymentId.isNotEmpty &&
                signature != null &&
                signature.isNotEmpty) {
              await verifyPayment(
                orderId: orderId,
                paymentId: paymentId,
                signature: signature,
              );
            }
            resetData();
            Get.offAllNamed(AppRoutes.bottomnavScreen);
          } catch (e) {
            debugPrint('❌ Payment verify error: $e');
            // Still navigate after success; verification can be retried on server
            resetData();
            Get.offAllNamed(AppRoutes.bottomnavScreen);
          }
        },
        onPaymentError: (_) {
          // Snackbar already shown by RazorpayController; user stays on screen
        },
      );
    } catch (e) {
      debugPrint('❌ Submission Error: $e');
      Get.snackbar(
        'Error',
        'Failed to submit form: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
      update();
    }
  }

// ✅ NEW METHOD: Print complete registration model data
  void _printCompleteRegistrationData() {
    final data = registrationData.value;

    debugPrint('📋 ========== COMPLETE REGISTRATION DATA ==========');
    debugPrint('📦 User Type: ${data.userType}');
    debugPrint('📦 Full Name: ${data.fullName}');
    debugPrint('📦 Email: ${data.email}');
    debugPrint('📦 Phone: ${data.phoneNumber}');
    debugPrint('📦 Password: ${data.password != null ? "***${data.password!.substring(min(3, data.password!.length))}" : "Not set"}');
    debugPrint('📦 Address: ${data.address}');
    debugPrint('📦 City: ${data.city}');
    debugPrint('📦 State: ${data.state}');
    debugPrint('📦 Latitude: ${data.latitude}');
    debugPrint('📦 Longitude: ${data.longitude}');
    debugPrint('📦 About Yourself: ${data.aboutYourself}');
    debugPrint('📦 Reference Number: ${data.referenceNumber}');
    debugPrint('📦 Objective: ${data.objective}');
    debugPrint('📦 Category: ${data.category?.join(", ") ?? "Not set"}');
    debugPrint('📦 Custom Category: ${data.customCategory}');
    debugPrint('📦 Sub Category: ${data.subCategory?.join(", ") ?? "Not set"}');
    debugPrint('📦 Custom Sub Category: ${data.customSubCategory}');
    debugPrint('📦 Describe Your Need: ${data.describeYourNeed}');

    // ✅ Print dynamic fields
    debugPrint('📦 ========== DYNAMIC FIELDS ==========');
    if (data.extraFields.isEmpty) {
      debugPrint('📦 No dynamic fields stored');
    } else {
      data.extraFields.forEach((key, value) {
        if (value is List) {
          debugPrint('📦 $key: ${value.join(", ")}');
        } else {
          debugPrint('📦 $key: $value');
        }
      });
    }

    // ✅ Print formData (temporary storage)
    debugPrint('📦 ========== FORM DATA (TEMPORARY) ==========');
    if (formData.isEmpty) {
      debugPrint('📦 No form data stored');
    } else {
      formData.forEach((key, value) {
        debugPrint('📦 $key: $value');
      });
    }

    // ✅ Print JSON representation
    debugPrint('📦 ========== JSON REPRESENTATION ==========');
    try {
      final jsonData = data.toJson();
      // Format JSON for better readability
      final encoder = JsonEncoder.withIndent('  ');
      debugPrint(encoder.convert(jsonData));
    } catch (e) {
      debugPrint('❌ Error converting to JSON: $e');
    }

    // ✅ Count summary
    debugPrint('📦 ========== DATA SUMMARY ==========');
    debugPrint('📦 Total static fields: 19');
    debugPrint('📦 Dynamic fields stored: ${data.extraFields.length}');
    debugPrint('📦 Form data fields: ${formData.length}');
    debugPrint('📦 Is password set: ${data.password != null}');
    debugPrint('📦 Is address complete: ${data.address != null && data.city != null && data.state != null}');
    debugPrint('📦 Is category info set: ${data.objective != null || data.category != null}');
    debugPrint('📋 ========== END REGISTRATION DATA ==========');
  }

  // ========== HELPER METHODS ==========

  // Get field value for display
  String? getFieldValue(String key) {
    return formData[key]?.toString();
  }

  // Check if form has been loaded
  bool get isFormLoaded => formResponse.value != null;

  // Get total required fields count
  int get requiredFieldsCount {
    if (formResponse.value == null) return 0;
    return formResponse.value!.fields.values
        .where((field) => field.required)
        .length;
  }

  // Get filled required fields count
  int get filledRequiredFieldsCount {
    if (formResponse.value == null) return 0;

    int count = 0;
    for (var entry in formResponse.value!.fields.entries) {
      final field = entry.value;
      final value = formData[field.key];

      if (field.required && value != null && value.toString().isNotEmpty) {
        count++;
      }
    }
    return count;
  }

  // Get registration progress percentage
  double get registrationProgress {
    if (formResponse.value == null) return 0.0;

    final totalFields = formResponse.value!.fields.length;
    if (totalFields == 0) return 1.0;

    final filledFields = formData.values.where((value) =>
    value != null && value.toString().isNotEmpty).length;

    return filledFields / totalFields;
  }

  // PAYMENT FUNCTIONS
  Future<CreatePaymentResponse> createPaymentOrder({
    required String userId,
    required String userType,
    required String paymentType,
    required double amountInr,
    String currency = 'INR',
    String? receipt,
  }) async {
    try {
      final request = CreatePaymentRequest(
        userId: userId,
        userType: userType,
        paymentType: paymentType,
        amountInr: amountInr,
        currency: currency,
        receipt: receipt ?? 'receipt_${DateTime.now().millisecondsSinceEpoch}',
      );

      final response = await _apiService.post(
        '${AppConfig.baseUrl}/api/payments/create-order',
        data: request.toJson(),
        // token is already handled inside ApiService (recommended)
      );

      if (response != null && response.statusCode == 200) {
        final data = response.data;

        return CreatePaymentResponse.fromJson(
          data['data'] ?? data,
        );
      } else {
        throw Exception(
          'Failed to create order: ${response?.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('❌ Create Payment Order Error: $e');
      throw Exception('Failed to create payment order');
    }
  }


  Future<VerifyPaymentResponse> verifyPayment({
    required String orderId,
    required String paymentId,
    required String signature,
  }) async {
    try {
      final request = VerifyPaymentRequest(
        razorpayOrderId: orderId,
        razorpayPaymentId: paymentId,
        razorpaySignature: signature,
      );

      final response = await _apiService.post(
        '${AppConfig.baseUrl}/api/payments/verify',
        data: request.toJson(),
      );

      if (response != null && response.statusCode == 200) {
        final data = response.data;
        return VerifyPaymentResponse.fromJson(
          data['data'] ?? data,
        );
      } else {
        throw Exception(
          'Verification failed: ${response?.statusCode}',
        );
      }
    } catch (e) {
      debugPrint('❌ Payment Verification Error: $e');
      throw Exception('Payment verification failed');
    }
  }


  // Optional: Save payment details to your database
  Future<bool> savePaymentDetails({
    required String userId,
    required String orderId,
    required String paymentId,
    required String paymentType,
    required double amount,
    required String status,
  }) async {
    try {
      final token = TokenService.getAccessToken();
      final response = await http.post(
        Uri.parse('${AppConfig.baseUrl}/api/payments/save-details'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': "Bearer $token",
        },
        body: json.encode({
          'user_id': userId,
          'order_id': orderId,
          'payment_id': paymentId,
          'payment_type': paymentType,
          'amount': amount,
          'status': status,
          'created_at': DateTime.now().toIso8601String(),
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  @override
  void onClose() {
    companyNameController.dispose();
    addressController.dispose();
    phoneController.dispose();
    aboutController.dispose();
    super.onClose();
  }
}