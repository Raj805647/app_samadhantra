import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:samadhantra/app/Stakeholder_Section/modules/profile_screen/profile_screen_controller.dart';
import 'package:samadhantra/app/data/model/blog_response.dart';
import 'package:flutter/material.dart';
import '../../../data/model/blog_comment_response.dart';
import '../../../utils/app_config.dart';

class BlogController extends GetxController {
  final commentController = TextEditingController();
  final profileController = Get.find<ProfileController>();
  RxList<BlogListData> blogListData = <BlogListData>[].obs;
  RxList<BlogCommentListData> comments = <BlogCommentListData>[].obs;
  RxBool isLoading = false.obs;
  var isLoadingMore = false.obs;
  var hasMoreData = true.obs;
  RxInt currentSkip = 0.obs;
  RxInt limit = 50.obs;

  @override
  void onInit() {
    fetchBlogsList(reset: true);
    super.onInit();
  }

  void fetchBlogsList({bool reset = false}) async {
    print('=== fetchBlogsList called ===');
    print('reset: $reset');
    print('currentSkip before: $currentSkip');
    print('hasMoreData before: $hasMoreData');

    try {
      if (reset) {
        isLoading.value = true;
        currentSkip.value = 0;
        hasMoreData.value = true;
        blogListData.clear();
        print('Reset: cleared data, skip=0');
      } else if (isLoadingMore.value || !hasMoreData.value) {
        print(
          'Skipped: isLoadingMore=$isLoadingMore, hasMoreData=$hasMoreData',
        );
        return;
      } else {
        isLoadingMore.value = true;
      }

      final url =
          '${AppConfig.baseUrl}${AppConfig.actionBlogList}?skip=$currentSkip&limit=$limit';
      print('Request URL: $url');

      final response = await http.get(Uri.parse(url));
      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final List dataList = jsonData['data'];
        print('Received ${dataList.length} items');

        final newData = dataList.map((e) => BlogListData.fromJson(e)).toList();

        reset ? blogListData.value = newData : blogListData.addAll(newData);
        print('Total items now: ${blogListData.length}');

        // Fixed pagination logic
        final hasMore = newData.length >= limit.value;
        hasMoreData.value = hasMore;
        if (hasMore) {
          currentSkip += limit.value;
          print('Has more data, skip incremented to: $currentSkip');
        } else {
          print('No more data');
        }
      } else {
        print('Error: ${response.statusCode}');
        hasMoreData.value = false;
      }
    } catch (e) {
      print('Exception: $e');
      hasMoreData.value = false;
    } finally {
      reset ? isLoading.value = false : isLoadingMore.value = false;
      print('currentSkip after: $currentSkip');
      print('hasMoreData after: $hasMoreData');
    }
  }

  void loadMoreData() {
    if (!isLoadingMore.value && hasMoreData.value && !isLoading.value) {
      fetchBlogsList(reset: false);
    }
  }

  Future<void> fetchComments(String blogId) async {
    final url = '${AppConfig.baseUrl}/blogs/$blogId/comments';
    print('Request URL: $url');

    final response = await http.get(Uri.parse(url));
    print('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List dataList = jsonData['data'];
      print('Received ${dataList.length} items');

      comments.value = dataList
          .map((e) => BlogCommentListData.fromJson(e))
          .toList();
    }
  }

  Future<void> postComment(String blogId) async {
    final url = '${AppConfig.baseUrl}/blogs/$blogId/comments';

    final data = {
      "author_name": profileController.profileData.value.fullName ?? '',
      "author_email": profileController.profileData.value.email ?? '',
      "content": commentController.text.trim(),
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        fetchComments(blogId);
        commentController.clear();
        Get.snackbar(
          'Comment Submitted',
          'Your comment has been saved and will appear after admin approval.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange.shade700,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
          icon: const Icon(Icons.hourglass_empty, color: Colors.white),
          margin: const EdgeInsets.all(12),
          borderRadius: 12,
        );
      } else {
        Get.snackbar('Error', 'Failed to post comment',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }}
