import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/constant/custom_snackbar.dart';
import 'package:samadhantra/app/data/model/stake_holder_model/registration_model.dart';
import 'package:samadhantra/app/global_routes/app_routes.dart';

class SignupScreenController extends GetxController {
  static SignupScreenController get to => Get.find();
  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // Text controllers
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final addressController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Observable variables
  var isPasswordVisible = true.obs;
  var isConfirmPasswordVisible = true.obs;
  var isLoading = false.obs;
  var acceptTerms = false.obs;


  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  // Toggle terms acceptance
  void toggleTerms() {
    acceptTerms.value = !acceptTerms.value;
  }

  // Full name validation
  String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name is required';
    }
    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Name can only contain letters and spaces';
    }
    return null;
  }

  // Email validation
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!GetUtils.isEmail(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // Phone validation
  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }
    if (!RegExp(r'^[0-9+\-\s()]+$').hasMatch(value)) {
      return 'Please enter a valid phone number';
    }
    if (value.replaceAll(RegExp(r'[^0-9]'), '').length < 10) {
      return 'Phone number must be at least 10 digits';
    }
    return null;
  }

  // Password validation
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)').hasMatch(value)) {
      return 'Password must contain at least one letter and one number';
    }
    return null;
  }

  // Confirm password validation
  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }
  final Rx<RegistrationModel> registrationData = RegistrationModel().obs;
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

  // Signup function
  Future<void> signup() async {
    // Get.toNamed(AppRoutes.stakeholderSignUp2);
    // Get.toNamed(AppRoutes.roleSelection);
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (!acceptTerms.value) {
      CustomSnackBar.show(
        title: "Error",
        message: "Please accept the Terms and Conditions",
        type: ContentType.failure,
      );
      return;
    }

    try {
      isLoading.value = true;

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock signup logic - replace with actual API call
      if (fullNameController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          phoneController.text.isNotEmpty &&
          passwordController.text.isNotEmpty) {
        // Show success message

        updatePersonalInfo(
          fullName: fullNameController.text.trim(),
          email: emailController.text.trim(),
          phoneNumber: phoneController.text.trim(),
          password: passwordController.text,
        );

        // Navigate to login screen
        await Future.delayed(const Duration(seconds: 1));

        Get.toNamed(AppRoutes.stakeholderSignUp2);
        // Show login prompt
        CustomSnackBar.show(title: "Welcome!", message: "Please login with your new credentials", type: ContentType.success);
      } else {
        throw Exception('Invalid signup data');
      }
    } catch (e) {
      CustomSnackBar.show(title: "Error", message: "Signup failed. Please try again.", type: ContentType.failure);
    } finally {
      isLoading.value = false;
    }
  }

  // Navigate to terms and conditions
  void showTermsAndConditions() {
    Get.dialog(
      AlertDialog(
        title: const Text('Terms and Conditions'),
        content: const SingleChildScrollView(
          child: Text(
            'By using this School Management System, you agree to the following terms and conditions:\n\n'
            '1. You will use the system responsibly and in accordance with school policies.\n\n'
            '2. You will not share your login credentials with others.\n\n'
            '3. You will maintain the confidentiality of student and school information.\n\n'
            '4. You will report any security concerns immediately.\n\n'
            '5. The school reserves the right to modify these terms at any time.\n\n'
            'For more detailed information, please contact the school administration.',
            style: TextStyle(fontSize: 14),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Close')),
        ],
      ),
    );
  }

  // Navigate to privacy policy
  void showPrivacyPolicy() {
    Get.dialog(
      AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'Privacy Policy for School Management System\n\n'
            'We are committed to protecting your privacy and personal information:\n\n'
            '1. We collect only necessary information for school operations.\n\n'
            '2. Your data is stored securely and encrypted.\n\n'
            '3. We do not share your information with third parties without consent.\n\n'
            '4. You have the right to access and update your information.\n\n'
            '5. We comply with all applicable data protection laws.\n\n'
            'For questions about our privacy practices, contact the school administration.',
            style: TextStyle(fontSize: 14),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Close')),
        ],
      ),
    );
  }
}
