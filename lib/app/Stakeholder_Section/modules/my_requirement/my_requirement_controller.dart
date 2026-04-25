import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/constant/custom_snackbar.dart';
import 'package:samadhantra/app/data/api_service.dart';
import 'package:samadhantra/app/data/model/stake_holder_model/my_requirements_model.dart';
import 'package:samadhantra/app/utils/app_config.dart';
import 'package:http/http.dart' as http;

import '../../../constant/token_storage_service.dart';

class MyRequirementController extends GetxController {
  final  categoryController = TextEditingController();
  final  descriptionController = TextEditingController();
  final  timelineController = TextEditingController();
  final  budgetController = TextEditingController();
  final  locationController = TextEditingController();
  final  outComesController = TextEditingController();

  final RxList<MyRequirementData> requirements = <MyRequirementData>[].obs;

  RxBool isLoading = false.obs;
  RxBool isSubmit = false.obs;
  RxString userId = ''.obs;
  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    fetchRequirements();
  }

  Future<void> fetchRequirements() async {
    try {
      isLoading.value = true;

      userId.value = await TokenService.getUserId() ?? '';
      final String url =
          'https://api.samadhantra.com/api/requirements?user_id=$userId';

      final response = await _apiService.get(url);

      if (response != null && response.statusCode == 200) {
        final data = response.data;
        print('ajdfhsdbfgvsdfmbfhsdaf');
        print(data);
        print(data['status']);
        print(data['message']);

        if (data != null && data['status'] == true) {
          final model = MyRequirementModel.fromJson(data);
          requirements.value = model.data ?? [];
          CustomSnackBar.success('Requirements fetched successfully');
        } else {
          CustomSnackBar.error(
            data['message'] ?? 'Failed to fetch requirements',
          );
        }
      } else {
        CustomSnackBar.error('Server error. Please try again.');
      }
    } catch (e) {
      CustomSnackBar.error('Failed to fetch requirements.');
      debugPrint('Fetch Requirements Error: $e');
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> deleteRequirement(String requirementId) async {
    try {
      isLoading.value = true;

      final url = Uri.parse(
        '${AppConfig.baseUrl}${AppConfig.updateRequirement}/$requirementId',
      );

      final userToken = await TokenService.getAccessToken();
      print('adjbkjfbsdkjbf=> $userToken');

      final response = await http.delete(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $userToken",
        },
      );

      print("DELETE URL => $url");
      print("STATUS CODE => ${response.statusCode}");
      print("STATUS CODE => ${response.body}");

      _handleDeleteResponse(response);

      Get.back();
      /// Or refresh list
      fetchRequirements();

    } catch (error) {
      CustomSnackBar.error('Failed to delete requirement.');
      debugPrint('Delete Requirement Error: $error');
    } finally {
      isLoading.value = false;
    }
  }

  void _handleDeleteResponse(http.Response response) {

    if (response.statusCode == 204) {

      /// Successfully deleted
      CustomSnackBar.success("Requirement deleted successfully");

    } else if (response.statusCode == 401) {
      CustomSnackBar.error("Session expired. Please login again.");

    } else if (response.statusCode == 404) {
      CustomSnackBar.error("Requirement not found.");

    } else {
      CustomSnackBar.error("Failed to delete requirement.");
    }
  }}
