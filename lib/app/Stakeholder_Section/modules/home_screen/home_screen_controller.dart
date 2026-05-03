import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/profile_screen/profile_screen_controller.dart';
import 'package:samadhantra/app/constant/token_storage_service.dart';
import 'package:samadhantra/app/data/api_service.dart';
import 'package:samadhantra/app/utils/app_config.dart';
import '../../../constant/custom_snackbar.dart';
import '../../../data/model/announcements_acitve_list_response.dart';
import '../../../data/model/dashboard_response.dart';

class HomeScreenController extends GetxController {
  ApiService apiService = ApiService();
  final profileData = Get.find<ProfileController>();

  final userid = ''.obs;
  final RxList<AnnouncementData> recentRequirements = <AnnouncementData>[].obs;
  Rx<DashBoardData> dashBoard = DashBoardData().obs;
  final unreadNotifications = 0.obs;

  RxBool isLoading = false.obs;

  @override
  void onInit() async {
    super.onInit();
    loadDashboardData();
  }

  void fetchDashboard() async{
    isLoading.value = true;
    try {
      final response = await apiService.get(AppConfig.actionDashboard);
      if (response.statusCode == 200) {
        dashBoard.value = DashBoardData.fromJson(response.data['data']);
        unreadNotifications.value = dashBoard.value.basicCounters?.unreadNotifications ?? 0;
      }
    } catch (e) {
      print('Error loading dashboard: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadDashboardData() async {
    fetchDashboard();
    try {
      isLoading.value = true;
      userid.value = await TokenService.getUserId() ?? '';
      final response = await apiService.get(
        AppConfig.actionActiveAnnouncements,
      );
      isLoading.value = false;
      if (response.statusCode == 200) {
        recentRequirements.value = (response.data['data'] as List)
            .map((e) => AnnouncementData.fromJson(e))
            .toList();
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
}
