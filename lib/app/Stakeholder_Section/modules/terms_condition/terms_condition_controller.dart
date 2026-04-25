import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../data/model/terms_condition_response.dart';

class TermsConditionsController extends GetxController {
  var terms = <TermsConditionsModel>[].obs;
  var isLoading = false.obs;
  var hasMoreData = true.obs;
  var currentSkip = 0.obs;
  final int limit = 10;

  final String baseUrl = 'https://api.samadhantra.com/api/terms-conditions';

  @override
  void onInit() {
    super.onInit();
    fetchTermsConditions();
  }

  Future<void> fetchTermsConditions({bool isLoadMore = false}) async {
    if (isLoading.value) return;

    if (isLoadMore) {
      if (!hasMoreData.value) return;
    } else {
      isLoading.value = true;
      terms.clear();
      currentSkip.value = 0;
      hasMoreData.value = true;
    }

    try {
      final url = Uri.parse('$baseUrl?include_inactive=false&skip=${currentSkip.value}&limit=$limit');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['status'] == true) {
          final List<dynamic> dataList = jsonResponse['data'] ?? [];

          final newTerms = dataList
              .map((json) => TermsConditionsModel.fromJson(json))
              .where((term) => term.isActive ?? false)
              .toList();

          if (isLoadMore) {
            terms.addAll(newTerms);
          } else {
            terms.value = newTerms;
          }

          if (newTerms.length < limit) {
            hasMoreData.value = false;
          } else {
            currentSkip.value += limit;
          }
        } else {
          throw Exception(jsonResponse['message'] ?? 'Failed to load terms');
        }
      } else {
        throw Exception('Failed to load terms');
      }
    } catch (e) {
      print('Error: $e');
      Get.snackbar(
        'Error',
        'Failed to load terms & conditions',
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
      await fetchTermsConditions(isLoadMore: true);
    }
  }

  void refreshData() {
    fetchTermsConditions();
  }
}