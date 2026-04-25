import 'dart:convert';

import 'package:get/get_navigation/src/snackbar/snackbar.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:samadhantra/app/utils/app_config.dart';

import '../../../data/model/privacy_policy_response.dart';

class PrivacyPolicyController extends GetxController {
  var policies = <PrivacyPolicyModel>[].obs;
  var isLoading = false.obs;
  var hasMoreData = true.obs;
  var currentSkip = 0.obs;
  final int limit = 10;

  @override
  void onInit() {
    super.onInit();
    fetchPrivacyPolicies();
  }

  Future<void> fetchPrivacyPolicies({bool isLoadMore = false}) async {
    if (isLoading.value) return;

    if (isLoadMore) {
      if (!hasMoreData.value) return;
    } else {
      isLoading.value = true;
      policies.clear();
      currentSkip.value = 0;
      hasMoreData.value = true;
    }

    try {
      final url = Uri.parse('${AppConfig.baseUrl}/privacy-policy?include_inactive=false&skip=${currentSkip.value}&limit=$limit');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));
      print('lkadnfjkbsdakbf=> ${url}');
      print('lkadnfjkbsdakbf=> ${response.body}');

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == true) {
          final List<dynamic> dataList = jsonResponse['data'] ?? [];

          final newPolicies = dataList
              .map((json) => PrivacyPolicyModel.fromJson(json))
              .where((policy) => policy.isActive ?? false)
              .toList();

          if (isLoadMore) {
            policies.addAll(newPolicies);
          } else {
            policies.value = newPolicies;
          }

          if (newPolicies.length < limit) {
            hasMoreData.value = false;
          } else {
            currentSkip.value += limit;
          }
        } else {
          throw Exception(jsonResponse['message'] ?? 'Failed to load');
        }
      } else {
        throw Exception('Failed to load');
      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar(
        'Error',
        'Failed to load privacy policies',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade800,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (!isLoading.value && hasMoreData.value) {
      await fetchPrivacyPolicies(isLoadMore: true);
    }
  }

  void refreshData() {
    fetchPrivacyPolicies();
  }
}