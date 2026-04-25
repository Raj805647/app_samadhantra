// lib/app/modules/stakeholder/views/profile/controllers/profile_controller.dart
import 'package:get/get.dart';
import 'package:samadhantra/app/constant/custom_snackbar.dart';
import 'package:samadhantra/app/constant/token_storage_service.dart';
import 'package:samadhantra/app/data/api_service.dart';
import 'package:samadhantra/app/data/model/user_data_model.dart';
import 'package:samadhantra/app/utils/app_config.dart';

class ProfileController extends GetxController {
  Rx<ProfileData> profileData = ProfileData().obs;
  final ApiService _apiService = ApiService();

  // Loading states
  final RxBool isLoading = false.obs;
  final RxBool isUploadingLogo = false.obs;

  @override
  void onInit() {
    getUserProfile();
    super.onInit();
  }



  Future<void> getUserProfile() async {
    try {
      isLoading.value = true;

      final response = await _apiService.get(AppConfig.getMyProfileUrl);

      if (response == null || response.statusCode != 200) {
        CustomSnackBar.error('Failed to fetch profile');
        return;
      }

      final responseData = response.data;

      if (responseData == null || responseData['data'] == null) {
        CustomSnackBar.error('Invalid profile response');
        return;
      }

      /// ✅ Extract actual profile object
      final profileJson = responseData['data'];

      final ProfileData profile = ProfileData.fromJson(profileJson);
      print('adfjndsjkbfkbsafsdf');
      await TokenService.saveUserId(profile.id!);
      await TokenService.saveUser(profile);
      print(profileJson);

      /// ✅ Get userId safely
      final String? userId = profile.id;

      if (userId == null || userId.trim().isEmpty) {
        CustomSnackBar.error('User ID not found');
        return;
      }

      profileData.value = profile;


    } catch (e, s) {
      CustomSnackBar.error('Unable to load profile. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  void viewPrivacyPolicy() {
    Get.toNamed('/privacy-policy');
  }

  // View terms
  void viewTermsAndConditions() {
    Get.toNamed('/terms');
  }
}
