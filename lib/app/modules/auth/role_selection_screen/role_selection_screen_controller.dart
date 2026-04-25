import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/constant/custom_snackbar.dart';
import 'package:samadhantra/app/data/api_service.dart';
import 'package:samadhantra/app/data/model/stake_holder_model/get_user_type_model.dart';
import 'package:samadhantra/app/data/model/stake_holder_model/registration_model.dart';
import 'package:samadhantra/app/global_routes/app_routes.dart';
import 'package:samadhantra/app/modules/auth/signup_screen/signup_screen_controller.dart';
import 'package:samadhantra/app/utils/app_config.dart';

class RoleSelectionController extends GetxController {

  final RxBool isLoading = false.obs;
  final RxList<UserTypes> userTypes = <UserTypes>[].obs;
  final ApiService _apiService = ApiService();

  @override
  void onInit() {
    super.onInit();
    getUserTypeApi();

  }

  Rx<RegistrationModel> get registrationData =>
      SignupScreenController.to.registrationData;  void updateUserType(String userType) {
    registrationData.update((val) {
      val?.userType = userType;
    });
  }

  Future<void> getUserTypeApi() async {
    try {
      isLoading.value = true;
      update();

      final response = await _apiService.get(
        AppConfig.getUserTypeUrl,
      );

      debugPrint("✅ RESPONSE: ${response.data}");

      if (response.data != null &&
          response.data['data']['user_types'] != null) {

        final List list = response.data['data']['user_types'];
        
      

        userTypes.value =
            list.map((e) => UserTypes.fromJson(e)).toList();

      } else {
        throw Exception("Invalid response format");
      }

    } catch (e, stackTrace) {
      debugPrint("❌ API ERROR: $e");
      debugPrint("❌ STACK TRACE: $stackTrace");

      CustomSnackBar.show(
        title: "Something went wrong",
        message: e.toString(),
        type: ContentType.failure,
      );

    } finally {
      isLoading.value = false;
      update();
    }
  }



  final List<RoleItem> roles = [
    RoleItem(
      id: 'startup',
      title: 'startup_msme',
      icon: '🚀',
      description: 'New business ventures',
    ),
    RoleItem(
      id: 'msme',
      title: 'incubation_centre',
      icon: '🏢',
      description: 'Micro, Small & Medium Enterprises',
    ),
    RoleItem(
      id: 'corporate',
      title: 'industry',
      icon: '🏛️',
      description: 'Large established companies',
    ),
    RoleItem(
      id: 'institute',
      title: 'educational_institute',
      icon: '🎓',
      description: 'Educational institutions',
    ),
    RoleItem(
      id: 'student',
      title: 'student',
      icon: '👨‍🎓',
      description: 'Learners and scholars',
    ),
    RoleItem(
      id: 'freelancer',
      title: 'freelancer',
      icon: '💼',
      description: 'Independent professionals',
    ),
    RoleItem(
      id: 'vendor',
      title: 'service_product_provider',
      icon: '🛒',
      description: 'Suppliers and service providers',
    ),

    RoleItem(
      id: 'vendors',
      title: 'investor',
      icon: '🛒',
      description: 'Suppliers and service providers',
    ),
  ];

  // Selected role
  Rx<UserTypes?> selectedRole = Rx<UserTypes?>(null);
  // Rx<UserTypes?> selectedAmount = Rx<UserTypes?>(null);
  var subscriptionAmount;
  // Methods
  void selectRole(UserTypes role) {
    selectedRole.value = role;
  }

  void continueWithRole() {
    if (selectedRole.value != null) {
      selectRole(selectedRole.value ?? userTypes.value.first);
      CustomSnackBar.success("You selected: ${selectedRole.value!.label}");
      // Here you would navigate to the next screen
       Get.toNamed(AppRoutes.completeProfile,arguments: {
         "selectedRole" : selectedRole.value?.value,"subsAmount" : subscriptionAmount
       });
    } else {
      CustomSnackBar.success("Please select a role to continue");

    }
  }
}

// Role model (inline in controller file)
class RoleItem {
  final String id;
  final String title;
  final String icon;
  final String description;

  RoleItem({
    required this.id,
    required this.title,
    required this.icon,
    required this.description,
  });
}