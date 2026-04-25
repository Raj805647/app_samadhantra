// lib/app/modules/stakeholder/views/dashboard/controllers/dashboard_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as _apiService;
import 'package:http/http.dart' as http;
import 'package:samadhantra/app/constant/token_storage_service.dart';
import 'package:samadhantra/app/data/model/stake_requirement_model.dart';
import 'package:samadhantra/app/global_routes/app_routes.dart';
import 'package:samadhantra/app/data/api_service.dart';
import 'package:samadhantra/app/utils/app_config.dart';
import '../../../constant/custom_snackbar.dart';
import '../../../data/model/announcements_acitve_list_response.dart';
import 'dart:convert';

class HomeScreenController extends GetxController {
  final companyName = 'Tech Innovations Ltd.'.obs;
  final userid = ''.obs;
  final RxList<AnnouncementData> recentRequirements = <AnnouncementData>[].obs;

  RxString reqId = ''.obs;

  // Stats
  final activeProjects = 0.obs;
  final completedProjects = 0.obs;
  final inReviewProjects = 0.obs;
  final totalProposals = 42.obs;
  final int limit = 10;

  RxBool isLoading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    try {
      isLoading.value = true;
      userid.value = await TokenService.getUserId() ?? '';

      final String url =
          'https://api.samadhantra.com/api/requirements/announcements/active';

      final response = await _apiService.get(Uri.parse(url));
      isLoading.value = false;
      if (response != null && response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print('adkshbfhsdavfs');
        print(data);
        print('askdhbfhvdashyfhasdvhjfvasdbjhfvasbdhb');
        print((await TokenService.getAccessToken()));
        if (data['status'] == true) {
          recentRequirements.value = (data['data'] as List)
              .map((e) => AnnouncementData.fromJson(e))
              .toList();
        } else {
          CustomSnackBar.error(
            data['message'] ?? 'Failed to load dashboard data',
          );
        }
      } else {
        CustomSnackBar.error('Server error. Please try again.');
      }
    } catch (e) {
      debugPrint('Dashboard Load Error: $e');
      CustomSnackBar.error('Failed to load dashboard data.');
    } finally {
      isLoading.value = false;
    }
  }

  void navigateToPostRequirement() {
    Get.toNamed(AppRoutes.postRequirementScreen);
  }

  void viewRequirementDetail(String requirementId) {
    print('akdjfjbkdsbjkfb');
    print(requirementId);
    Get.toNamed('/requirementDetails', arguments: requirementId);
    // Get.toNamed('/stakeholder/requirement-detail/$requirementId');
  }

  Future<void> submitSelectedBid() async {
    try {
      final url =
          // '${AppConfig.baseUrl}/requirements/admin/${reqId.value}/shortlist';
          '${AppConfig.baseUrl}/requirements/admin/630a6f3c-64c9-4576-bf4b-5c3713bae592/shortlist';

      final body = {
        "provider_user_ids": [
          // userid.value.toString(),
        "4972cb3e-1d8b-4fa9-8152-e1912f4f44e4",
        ],
      };

      print("URL => $url");
      print("BODY => ${jsonEncode(body)}");

      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization":
              "bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJhZG1pbkBzYW1hZGhhbnRyYS5jb20iLCJyb2xlIjoiYWRtaW4iLCJhZG1pbl90eXBlIjoic3VwZXJfYWRtaW4iLCJleHAiOjE3NzU0NjE0NjgsImp0aSI6Ijc4YzZhMmQ3N2U1ZjQ5MWZhZDA4N2I4ZTQ4Zjk3Y2M2In0.ad5inuEfahGiJZpqxaprRFOZIK8a_mBqLPdfmszo8rc",
        },
        body: jsonEncode(body),
      );

      print("Status Code => ${response.statusCode}");
      print("Response => ${response.body}");
    } catch (e) {
      print("ERROR => $e");
    }
  }
}
