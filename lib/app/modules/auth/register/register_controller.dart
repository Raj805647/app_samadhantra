import 'package:get/get.dart';
import 'package:flutter/material.dart';

class RegisterController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  /// 🔹 Single Validator Function
  String? validateField(String field, String? value) {
    switch (field) {
      case 'name':
        if (value == null || value.trim().isEmpty) {
          return "Name is required";
        }
        if (value.trim().length < 3) {
          return "Name must be at least 3 characters";
        }
        break;

      case 'email':
        if (value == null || value.trim().isEmpty) {
          return "Email is required";
        }
        if (!RegExp(
          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
        ).hasMatch(value.trim())) {
          return "Enter a valid email";
        }
        break;

      case 'phone':
        if (value == null || value.trim().isEmpty) {
          return "Phone number is required";
        }
        if (!RegExp(r'^[6-9]\d{9}$').hasMatch(value)) {
          return "Enter valid 10-digit mobile number";
        }
        break;

      case 'city':
        if (value == null || value.trim().isEmpty) {
          return "City is required";
        }
        break;

      case 'state':
        if (value == null || value.trim().isEmpty) {
          return "State is required";
        }
        break;

      case 'password':
        if (value == null || value.isEmpty) {
          return "Password is required";
        }
        if (value.length < 6) {
          return "Minimum 6 characters required";
        }
        break;

      case 'confirmPassword':
        if (value == null || value.isEmpty) {
          return "Confirm your password";
        }
        if (value != passwordController.text) {
          return "Passwords do not match";
        }
        break;
    }
    return null;
  }

  /// 🔹 Submit
  void register() {
    if (!formKey.currentState!.validate()) return;

    final data = {
      "name": nameController.text.trim(),
      "email": emailController.text.trim(),
      "phone": phoneController.text.trim(),
      "city": cityController.text.trim(),
      "state": stateController.text.trim(),
      "password": passwordController.text.trim(),
    };

    print("Register Data => $data");
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    cityController.dispose();
    stateController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
