import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as _apiService;
import 'package:samadhantra/app/constant/token_storage_service.dart';
import 'package:samadhantra/app/utils/app_config.dart';

import '../../../constant/custom_snackbar.dart';
import '../../../data/model/announcements_acitve_list_response.dart';
import '../../../data/model/stake_holder_model/my_requirements_model.dart';
import '../../../data/model/user_data_model.dart';

class ActiveTargetListController extends GetxController {
  var userProfile = Rx<ProfileData?>(null);

  RxList<AnnouncementData> recentRequirements = <AnnouncementData>[].obs;
  RxBool isLoading = false.obs;
  RxBool isSubmit = false.obs;
  Rx<ProfileData> userData = ProfileData().obs;

  @override
  void onInit() {
    getActiveTargetList();
    super.onInit();
  }

   getActiveTargetList() async {
    try {
      isLoading.value = true;
      final userData = await TokenService.getUserId();
      final url = '${AppConfig.baseUrl}${AppConfig.getTargetActiveList(userData)}';
      print('aksdjfnjksdankjbfkjsdabkbnf');
      print(url);

      final response = await _apiService.get(Uri.parse(url));
      isLoading.value = false;
      if (response != null && response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print('asdkjbfkjsdabjkbf');
        print(data['data']);

        if (data['status'] == true) {
          recentRequirements.value = (data['data']as List).map((e)=>  AnnouncementData.fromJson(e)).toList();
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
}

