import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:samadhantra/app/data/api_service.dart';
import 'package:samadhantra/app/utils/app_config.dart';

import '../../../constant/token_storage_service.dart';
import '../../../data/model/assignment_details_response.dart';
import '../../../data/model/my_agreement_response.dart';

class AssignmentController extends GetxController {
  RxList<AgreementData> agreements = <AgreementData>[].obs;

  @override
  onInit() {
    super.onInit();
    fetchAssignmentData();
  }

  RxBool isAssignmentLoading = false.obs;
  Future<void> fetchAssignmentData() async {
    try {
      isAssignmentLoading.value = true;
      final userToken = await TokenService.getAccessToken();
      final url = Uri.parse('${AppConfig.baseUrl}/requirements/agreements/me');
      final response = await http.get(
        url,
        headers: {
          'context-type': 'application/json',
          'Authorization': 'Bearer $userToken',
        },
      );

      print('adsbfkbdskbffds=> ${response.body}');
      isAssignmentLoading(false);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          agreements.value = (data['data'] as List)
              .map((json) => AgreementData.fromJson(json))
              .toList();
        }
      }
    } catch (e) {
      isAssignmentLoading(false);
      print('afbadjkbfbads=> $e');
      Get.snackbar('Error', 'Failed to fetch agreements');
    } finally {
      isAssignmentLoading.value = false;
    }
  }
}
