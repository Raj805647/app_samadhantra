// lib/app/modules/service_provider/controllers/service_provider_settings_controller.dart
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:samadhantra/app/Stakeholder_Section/modules/profile_screen/profile_screen_controller.dart';
import 'package:samadhantra/app/constant/token_storage_service.dart';
import 'package:samadhantra/app/data/api_service.dart';
import 'package:samadhantra/app/utils/app_config.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsController extends GetxController {
  final profileController = Get.put(ProfileController());
  final  currentPassword = TextEditingController();
  final  newPassword = TextEditingController();
  final  confirmPassword = TextEditingController();

  //send feedback
  final subjectController = TextEditingController();
  final messageController = TextEditingController();
  final appUrl = 'https://play.google.com/store/apps/details?id=com.app.samadhantra';


  var preferredLanguage = 'English'.obs;
  var isLoading = false.obs;

  final List<String> languages = ['English', 'Hindi', 'Spanish', 'French'];



  Future<void> changePassword() async {
    if (currentPassword.text.isEmpty ||
        newPassword.text.isEmpty ||
        confirmPassword.text.isEmpty) {
      Get.snackbar('Error', 'All fields are required');
      return;
    }

    if (newPassword.text != confirmPassword.text) {
      Get.snackbar('Error', 'Passwords do not match');
      return;
    }

    if (newPassword.text.length < 6) {
      Get.snackbar(
        'Error',
        'Password must be at least 6 characters',
      );
      return;
    }

    try {
      isLoading(true);
      final url = Uri.parse(
        '${AppConfig.baseUrl}${AppConfig.actionChangePassword}',
      );
      final body = {
        'email':
        profileController.profileData.value.email ?? '',
        'previous_password': currentPassword.text,
        'new_password': newPassword.text,
      };
      final response = await http.post(
        url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(body)
      );
      print('ajkdfkabsdkjf=> $url');
      print(body);
      print(response.statusCode);
      print(response.body);
isLoading(false);
      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        Get.snackbar(
          'Success',
          'Password changed successfully',
        );

        clearController();
      } else {
        Get.snackbar(
          'Error',
          'Failed to change password',
        );
      }
    } catch (e) {
      isLoading(false);
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
      );
    }
  }

  void deleteGetDeviceToken() async{
    ApiService  apiService = ApiService();
    try{
      final fcmToken = await FirebaseMessaging.instance.getToken();

      Map<String, dynamic> bodyData = {
        "token": fcmToken,
      };
      final response = await apiService.delete(AppConfig.actionGetDeviceToken, queryParameters: bodyData);
      print('adkbfkjbsdakfbds=> ${response.data}');
      print('adkbfkjbsdakfbds=> ${response.statusCode}');


    }catch(error){
      print('fakvbkjdsabjdsanjkbvb=>$error');
    }
  }


  void updatePreferences() {
    Get.snackbar('Success', 'Preferences updated');
  }


  void contactSupport() {
    Get.toNamed('/service-provider/support');
  }
  Future<void> openPlayStoreForRating() async {
    final Uri url = Uri.parse(appUrl);

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Could not launch Play Store';
    }
  }

  Future<void> shareAppUrl() async {
    await Share.share(
      'Check out this app on Play Store:\n$appUrl',
      subject: 'Samadhantra App',
    );
  }

  Future<void> contactSupportByEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'info@samadhantra.com',
      query: 'subject=Help & Support&body=Hello Samadhantra Team,',
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not open email app';
    }
  }

  Future<void> contactSupportByPhone() async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: '+919644553196',
    );

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not open phone dialer';
    }
  }

  void fetchFeedback() async{
    if (subjectController.text.isEmpty ||
        messageController.text.isEmpty) {
      Get.snackbar('Error', 'please fill the subject and message ');
      return;
    }

    try {
      isLoading(true);
      final url = Uri.parse(
        '${AppConfig.baseUrl}${AppConfig.actionSendFeedback}',
      );
      final body = {
          "name": profileController.profileData.value.fullName,
          "email": profileController.profileData.value.email,
          "mobile": profileController.profileData.value.phoneNumber,
          "subject": subjectController.text,
          "message": messageController.text
      };
      final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(body)
      );
      print('dfskjgbkjfsdjbgkfb=> $url');
      print(body);
      print(response.statusCode);
      print(response.body);
      isLoading(false);
      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        Get.snackbar(
          'Success',
          'Received Feedback successfully',
        );

        clearController();
      } else {
        Get.snackbar(
          'Error',
          'Failed to change password',
        );
      }
    } catch (e) {
      isLoading(false);
      Get.snackbar(
        'Error',
        'Something went wrong: $e',
      );
    }

  }

  void clearController(){
    currentPassword.clear();
    newPassword.clear();
    confirmPassword.clear();
    subjectController.clear();
    messageController.clear();
  }
}