import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:samadhantra/app/data/api_service.dart';

import '../../../constant/token_storage_service.dart';
import '../../../data/model/provider_requester_chatting_response.dart';
import '../../../data/model/stake_holder_model/my_requirements_model.dart';
import '../../../utils/app_config.dart';

  class MessageController extends GetxController {
    ApiService apiService = ApiService();
    final searchController = TextEditingController();
    final isSearchVisible = false.obs;
    final isLoading = false.obs;
    final userId = ''.obs;
    final requirementId = ''.obs;
    final requirementCategory = ''.obs;
    final appBarTitle = ''.obs;

    RxList<ChattingListData> allChattingLists = <ChattingListData>[].obs;
    RxList<ChattingListData> chattingLists = <ChattingListData>[].obs;

    @override
    void onInit() async {
      super.onInit();
      userId.value = await TokenService.getUserId() ?? "";
      requirementId.value = Get.arguments['requirement_id'];
      requirementCategory.value = Get.arguments['requirement_category'];
      appBarTitle.value = Get.arguments['appbar_title'];

     fetchingData();
      searchController.addListener(() {
        searchChats(searchController.text);
      });
    }

    void fetchingData() async{
      if (requirementId.value.isNotEmpty && requirementCategory.value.isNotEmpty) {
        fetchCurrentTabData();
      } else {
        fetchRequesterData();
      }
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
        final url = '${AppConfig.actionProviderChatting}/${userId.value}?requirement_id=${requirementId.value}';
        print('ajfvdsfgdsaf=> $url');
        final response = await apiService.get(url );
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
    Future<void> fetchRequesterData() async {
      try {
        isLoading(true);

        final url =
            '${AppConfig.baseUrl}${AppConfig.actionRequesterChatting}';

        final response = await http.get(
          Uri.parse(url),
          headers: {
            'accept': 'application/json',
            'provider-user-id': userId.value.toString(),
          },
        );

        isLoading(false);

        if (response.statusCode == 200) {
          final decoded = jsonDecode(response.body);

          allChattingLists.value =
              (decoded['data'] as List)
                  .map((e) => ChattingListData.fromJson(e))
                  .toList();

          chattingLists.value = allChattingLists;
        }
      } catch (error) {
        isLoading(false);
        print('Error => $error');
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