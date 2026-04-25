import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:samadhantra/app/constant/app_color.dart';

import 'package:get/get.dart';
import 'package:samadhantra/app/utils/app_config.dart';

import '../../../constant/token_storage_service.dart';
import '../../../data/api_service.dart';
import '../../../data/model/app_notification_response.dart';
import '../../../global_routes/app_routes.dart';

class NotificationsController extends GetxController {
  final ApiService _apiService = ApiService();

  RxBool isLoading = false.obs;
  RxList<AppNotification> notifications = <AppNotification>[].obs;

  Future<void> fetchNotifications(
      NotificationCategory category,
      ) async {
    try {
      isLoading.value = true;

      final userId = await TokenService.getUserId();

      String apiUrl = "";

      switch (category) {
        case NotificationCategory.active:
          apiUrl =
          "${AppConfig.baseUrl}/requirements/notifications/active/$userId";
          break;

        case NotificationCategory.shortlist:
          apiUrl =
          "${AppConfig.baseUrl}/requirements/notifications/shortlist/$userId";
          break;
      }

      final response = await _apiService.get(apiUrl);

      final List data = response.data['data'] ?? [];

      notifications.value = data
          .map((e) => AppNotification.fromJson(e))
          .toList();
    } catch (e) {
      print("Notification fetch error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void onNotificationTap(AppNotification item) {
    switch (item.type) {
      case "requirement_announcement":
        Get.toNamed(
          AppRoutes.requirementListScreen,
          arguments: item.requirementId,
        );
        break;

      case "requirement_targeted":
        Get.toNamed(
          AppRoutes.activeTargetListScreen,
          arguments: item.requirementId,
        );
        break;

      case "shortlist_notification":
        Get.toNamed(
          AppRoutes.notificationScreen,
          arguments: item.requirementId,
        );
        break;

      default:
        Get.toNamed(AppRoutes.notificationScreen);
    }
  }
}

enum NotificationCategory {
  active,
  shortlist,
}