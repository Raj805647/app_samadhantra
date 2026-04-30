import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as dio;
import 'package:samadhantra/app/Stakeholder_Section/modules/profile_screen/profile_screen_controller.dart';
import 'package:samadhantra/app/constant/custom_snackbar.dart';
import 'package:samadhantra/app/constant/token_storage_service.dart'
    show TokenService;
import 'package:samadhantra/app/data/api_service.dart';
import 'package:samadhantra/app/global_routes/app_routes.dart';
import 'package:samadhantra/app/utils/app_config.dart';

import '../../../../firebase_service.dart';
import '../../../data/model/user_data_model.dart';

class LoginScreenController extends GetxController {

  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // Text controllers
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  // Observable variables
  var isPasswordVisible = true.obs;
  var isLoading = false.obs;
  var rememberMe = false.obs;
  var isPhoneLogin = true.obs; // Toggle for phone/email login

  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
  }

  // Toggle between phone and email login
  void toggleLoginMethod() {
    isPhoneLogin.value = !isPhoneLogin.value;

    // Clear text controllers when switching
    if (isPhoneLogin.value) {
      emailController.clear();
    } else {
      phoneController.clear();
    }
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
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

    // Basic phone number validation (10 digits)
    if (!GetUtils.isPhoneNumber(value)) {
      return 'Please enter a valid phone number';
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
    return null;
  }

  // Get the current identifier (email or phone)
  String getIdentifier() {
    return isPhoneLogin.value ? phoneController.text : emailController.text;
  }

  // Login function
  Future<void> login() async {
    try {
      isLoading.value = true;

      final body = {
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
      };

      final response = await _apiService.post(AppConfig.loginUrl, data: body);
      print('ksdfgjbdjkfsgbsdg');
      print(response.data);

      if (response != null && response.statusCode == 200) {
        final data = response.data;
        if (data != null) {
          // ✅ SAVE TOKEN SECURELY
          CustomSnackBar.success('Login Successfully');
          final accessToken = data['data']?['access_token'];
          final userId = data['data']?['user_id'];
          final userType = data['data']?['user_type'];

          await TokenService.saveAccessToken(accessToken ?? "");
          await TokenService.saveUserId(userId ?? "");
          await TokenService.saveUserType(userType ?? "");
          _navigateToDashboard();
          fetchGetDeviceToken();
          // await NotificationService().init();
        } else {
          CustomSnackBar.error(data['message'] ?? 'Invalid email or password');
        }
      } else {
        CustomSnackBar.error('Server error. Please try again.');
      }
    } catch (e) {
      CustomSnackBar.error('Login failed. Please check your credentials.');
      debugPrint('Login Error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void fetchGetDeviceToken() async{
    try{
      final fcmToken = await FirebaseMessaging.instance.getToken();

      Map<String, dynamic> bodyData = {
          "token": fcmToken,
          "platform": "unknown",
          "device_label": "string"
      };
      final response = await _apiService.post(AppConfig.actionGetDeviceToken, data: bodyData);
      print('adkbfkjbsdakfbds=> ${response.data}');
      print('adkbfkjbsdakfbds=> ${response.statusCode}');


    }catch(error){
      print('fakvbkjdsabjdsanjkbvb=>$error');
    }
  }

  void _navigateToDashboard() {
    // !isPhoneLogin.value ?
    // Get.toNamed(AppRoutes.bottomnavScreen) : Get.toNamed(AppRoutes.otp);
    Get.offAllNamed(AppRoutes.bottomnavScreen);
  }

  // Forgot password function
  void forgotPassword() {
    Get.toNamed('/forgotPassword');
  }

  // Go to sign up
  void goToSignUp() {
    Get.toNamed('/signUp');
  }
}
