import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:samadhantra/app/data/api_service.dart';

import '../../../constant/token_storage_service.dart';
import '../../../data/model/provider_requester_chatting_response.dart';
import '../../../utils/app_config.dart';

  class MessageController extends GetxController {
    ApiService apiService = ApiService();
    final searchController = TextEditingController();
    final isSearchVisible = false.obs;
    final isLoading = false.obs;
    final userId = ''.obs;
    RxList<ChattingListData> allChattingLists = <ChattingListData>[].obs;
    RxList<ChattingListData> chattingLists = <ChattingListData>[].obs;

    @override
    void onInit() async {
      super.onInit();
      userId.value = await TokenService.getUserId() ?? "";
      fetchCurrentTabData();

      searchController.addListener(() {
        searchChats(searchController.text);
      });
    }

    @override
    void onClose() {
      searchController.dispose();
      super.onClose();
    }

    void toggleSearch() => isSearchVisible.toggle();

    Future<void> fetchCurrentTabData() async {
      try {
        isLoading(true);
        final response = await apiService.get(
            '${AppConfig.actionProviderRequesterChatting}/${userId.value}');
        print('akjbfhbsdahfhbsdabf=> ${response.data}');
        isLoading(false);
        if (response.statusCode == 200) {
          allChattingLists.value =
              (response.data['data'] as List)
                  .map((e) => ChattingListData.fromJson(e))
                  .toList();

          chattingLists.value = allChattingLists;
        }
      } catch (error) {
        isLoading(false);
        print('adfkjsadbhfbsda=> $error');
      }
    }

    void searchChats(String query) {
      if (query.isEmpty) {
        chattingLists.value = allChattingLists;
      } else {
        chattingLists.value = allChattingLists.where((chat) {
          final name = chat.userName?.toLowerCase() ?? '';
          final role = chat.myRole?.toLowerCase() ?? '';
          return name.contains(query.toLowerCase()) ||
              role.contains(query.toLowerCase());
        }).toList();
      }
    }
  }