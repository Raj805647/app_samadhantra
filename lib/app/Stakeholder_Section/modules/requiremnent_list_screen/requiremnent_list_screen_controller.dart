// requirement_list_screen_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/constant/custom_snackbar.dart';
import 'package:samadhantra/app/constant/token_storage_service.dart';
import 'package:samadhantra/app/data/api_service.dart';
import 'package:samadhantra/app/data/model/stake_holder_model/my_requirements_model.dart';
import 'package:samadhantra/app/global_routes/app_routes.dart';

class RequirementsController extends GetxController {
  final RxList<MyRequirementData> requirements = <MyRequirementData>[].obs;
  final RxString selectedFilter = 'All'.obs;
  final filters = ['All', 'Active', 'In Review', 'Completed', 'Pending'];

  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool hasMoreData = true.obs;
  final int limit = 10;
  int currentPage = 0;
  bool isFirstLoad = true;
  RxString userId = ''.obs;

  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    fetchRequirements();
  }

  Future<void> fetchRequirements({bool loadMore = false}) async {
    try {
      if (loadMore) {
        isLoadingMore.value = true;
      } else {
        isLoading.value = true;
        if (!loadMore) {
          currentPage = 0;
          hasMoreData.value = true;
        }
      }

      userId.value = await TokenService.getUserId() ?? '';
      print('sbfhsdbfdsfbs');
      print(userId.value);
      final int skip = currentPage * limit;
      final String url =
          'https://api.samadhantra.com/api/requirements?skip=$skip&limit=$limit';

      final response = await _apiService.get(url);

      if (response != null && response.statusCode == 200) {
        final data = response.data;

        if (data != null && data['status'] == true) {
          final model = MyRequirementModel.fromJson(data);
          final List<MyRequirementData> newRequirements = model.data ?? [];

          if (loadMore) {
            requirements.addAll(newRequirements);
          } else {
            requirements.value = newRequirements;
          }

          if (newRequirements.length < limit) {
            hasMoreData.value = false;
          } else {
            currentPage++;
          }

          if (!loadMore && !isFirstLoad) {
            CustomSnackBar.success('Requirements fetched successfully');
          }
        } else {
          if (!loadMore) {
            CustomSnackBar.error(data['message'] ?? 'Failed to fetch requirements');
          }
        }
      } else {
        if (!loadMore) {
          CustomSnackBar.error('Server error. Please try again.');
        }
      }
    } catch (e) {
      if (!loadMore) {
        CustomSnackBar.error('Failed to fetch requirements.');
      }
      debugPrint('Fetch Requirements Error: $e');
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
      isFirstLoad = false;
    }
  }

  // Method to load more data
  Future<void> loadMoreRequirements() async {
    if (!isLoadingMore.value && !isLoading.value && hasMoreData.value) {
      await fetchRequirements(loadMore: true);
    }
  }

  // Refresh data
  Future<void> refreshRequirements() async {
    await fetchRequirements();
  }

  // Filter requirements based on status
  List<MyRequirementData> get filteredRequirements {
    if (selectedFilter.value == 'All') return requirements;

    // Map filter names to status values from API
    String statusFilter;
    switch (selectedFilter.value) {
      case 'Active':
        statusFilter = 'open';
        break;
      case 'In Review':
        statusFilter = 'in_review';
        break;
      case 'Completed':
        statusFilter = 'completed';
        break;
      case 'Pending':
        statusFilter = 'pending';
        break;
      default:
        statusFilter = selectedFilter.value.toLowerCase();
    }

    return requirements
        .where((req) => req.status?.toLowerCase() == statusFilter.toLowerCase())
        .toList();
  }

  void viewRequirementDetail(String id) {
    Get.toNamed(AppRoutes.requirementDetails,arguments: id);
  }

  void deleteRequirement(String id) {
    requirements.removeWhere((req) => req.id == id);
  }
}