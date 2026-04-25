import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as _apiService;
import 'package:samadhantra/app/constant/custom_snackbar.dart';
import 'package:samadhantra/app/constant/token_storage_service.dart';
import 'package:samadhantra/app/data/api_service.dart';
import 'package:samadhantra/app/data/model/stake_holder_model/get_requirement_details_by_id.dart';
import 'package:samadhantra/app/data/model/stake_requirement_model.dart';
import 'package:samadhantra/app/utils/app_config.dart';


class RequirementDetailsScreenController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxBool isSubmit = false.obs;
  final RxString errorMessage = ''.obs;
  RxString requirementId = ''.obs;
  Rx<RequirementDetailData?> requirementDetails = Rx<RequirementDetailData?>(null);
  final ApiService _apiService = ApiService();
  RxString userId = ''.obs;


  final amountController = TextEditingController();
  final timelineController = TextEditingController();
  final proposalController = TextEditingController();
  final experienceController = TextEditingController();


  @override
  void onInit() {
    getUserData();
    super.onInit();
    requirementId.value = Get.arguments;
    if (requirementId.value != null && requirementId.value.isNotEmpty) {
      getRequirementDetailsById();
    } else {
      // CustomSnackBar.error("Invalid requirement ID");
    }
  }

  void getUserData()async{
    userId.value = await TokenService.getUserId() ?? '';
  }

  Future<void> getRequirementDetailsById() async {
    try {
      isLoading.value = true;
      final response = await _apiService.get('https://api.samadhantra.com/api/requirements/${requirementId.value}'
        // "${AppConfig.baseUrl}${AppConfig.getrequirementDetailByIdUrl(requirementId)}",
      );
      print('adskjfbhsdabfsdajf');
      print(response.statusCode);
      print(response.data);
      if (response == null || response.statusCode != 200) {
        CustomSnackBar.error('Failed to fetch requirement details');
        return;
      }
      // requirementDetails.value = response.data;

      final responseData = response.data;
      debugPrint("REQUIREMENT RESPONSE => $responseData");
      debugPrint("TYPE OF DATA => ${responseData['data'].runtimeType}");

      if (responseData == null) {
        CustomSnackBar.error('Invalid requirement response');
        return;
      }

      /// ✅ Parse full requirement model
      final GetRequirementByIdModel requirementModel =
      GetRequirementByIdModel.fromJson(responseData);

      /// ✅ Save in GetX variable (create this Rx variable)
      requirementDetails.value = requirementModel.data;



      debugPrint('✅ Requirement details stored successfully');
    } catch (e, s) {
      debugPrint('❌ Get Requirement Error: $e');
      debugPrintStack(stackTrace: s);

      CustomSnackBar.error(
        'Unable to load requirement details. Please try again.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitBid() async {
    try {
      isSubmit.value = true;

      final token = await TokenService.getAccessToken();

      final url = Uri.parse(
          "https://api.samadhantra.com/api/requirements/${requirementId.value}/bid");


      Map<String, dynamic> postData = {
        // "id": userid,
        // "requirement_id": requirementId.value,
        "provider_user_id": userId.value,
        "amount": amountController.text,
        "proposal_text": proposalController.text,
        "experience_text": experienceController.text,
      /*  "source": timelineController.text,
        "status": "string",
        "created_at": dateFormat,*/
      };
      print("REQUEST BODY => ${jsonEncode(postData)}");

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(postData),
      );

      print("STATUS => ${response.statusCode}");
      print("RESPONSE => ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        CustomSnackBar.success("Bid submitted successfully");
      } else {
        CustomSnackBar.error("Server Error (${response.statusCode})");
      }
    } catch (e) {
      debugPrint("Submit Bid Error: $e");
    } finally {
      isSubmit.value = false;
    }
  }}
