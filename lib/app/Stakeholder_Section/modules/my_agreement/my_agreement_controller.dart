import 'dart:convert';

import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:samadhantra/app/constant/token_storage_service.dart';
import 'package:samadhantra/app/data/model/my_agreement_response.dart';
import 'package:samadhantra/app/utils/app_config.dart';
import 'package:signature/signature.dart';

class MyAgreementController extends GetxController {
  final SignatureController signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  final Dio _dio = Dio();
  RxList<AgreementData> agreements = <AgreementData>[].obs;
  var isLoading = true.obs;
  var generatingPdf = false.obs;
  final RxDouble downloadProgress = 0.0.obs;
  RxString bidId = ''.obs;
  RxString reqId = ''.obs;
  RxString providerUserID = ''.obs;

  @override
  void onInit() {
    super.onInit();
    bidId.value = Get.arguments['reqBidId'];
    reqId.value = Get.arguments['reqId'];
    providerUserID.value = Get.arguments['providerUserID'];
    fetchAgreements();
  }

  Future<void> fetchAgreements() async {
    try {
      isLoading.value = true;
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

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          agreements.value = (data['data'] as List)
              .map((json) => AgreementData.fromJson(json))
              .toList();
        }
      }
    } catch (e) {
      print('afbadjkbfbads=> $e');
      Get.snackbar('Error', 'Failed to fetch agreements');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> downloadAgreementPdf(String agreementId) async {
    try {
      print("========== PDF DOWNLOAD START ==========");
      print("Agreement ID: $agreementId");

      showDownloadProgressDialog();
      print("Loading dialog shown");

      final token = await TokenService.getAccessToken();
      print("Token fetched: ${token != null ? 'Available' : 'NULL'}");

      final metaUrl =
          '${AppConfig.baseUrl}/requirements/agreements/$agreementId/generate-pdf';

      print("Meta API URL: $metaUrl");

      final metaResponse = await _dio.post(
        metaUrl,
        data: {
          'agreement_id': agreementId,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print("Meta Response: ${metaResponse.data}");

      final fullPdfUrl =
          'https://api.samadhantra.com${metaResponse.data['data']['file_url']}';

      print("Full PDF URL: $fullPdfUrl");

      final pdfResponse = await _dio.get(
        fullPdfUrl,
        options: Options(
          responseType: ResponseType.bytes,
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print("PDF Response Status: ${pdfResponse.statusCode}");
      print("PDF Bytes Length: ${pdfResponse.data.length}");

      final directory = await getApplicationDocumentsDirectory();
      print("Directory Path: ${directory.path}");

      final file = File('${directory.path}/agreement_$agreementId.pdf');
      print("Saving File At: ${file.path}");

      await file.writeAsBytes(pdfResponse.data);

      print("File saved successfully");
      print("Saved file size: ${await file.length()} bytes");

      if (Get.isDialogOpen ?? false) {
        Get.back();
        print("Loading dialog closed");
      }

      await OpenFile.open(file.path);
      print("PDF opened successfully");

      Get.snackbar(
        'Success',
        'PDF downloaded successfully',
        snackPosition: SnackPosition.BOTTOM,
      );

      print("========== PDF DOWNLOAD COMPLETE ==========");
    } catch (e, stackTrace) {
      print("========== PDF DOWNLOAD ERROR ==========");
      print("Error: $e");
      print("StackTrace: $stackTrace");

      if (Get.isDialogOpen ?? false) {
        Get.back();
        print("Dialog closed after error");
      }

      Get.snackbar(
        'Error',
        'Download failed: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> signAgreement(String id) async {
    try {
      final userToken = await TokenService.getAccessToken();
      final image = await signatureController.toPngBytes();
      final signatureBase64 = image != null ? base64Encode(image) : "";
      final url = Uri.parse(
        '${AppConfig.baseUrl}/requirements/agreements/$id/sign-provider',
      );
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $userToken',
        },
        body: json.encode({'provider_signature': signatureBase64}),
      );
      print('adhbafbhfabsdhbfasdjfvh');
      print(url);
      print(response.statusCode);
      print(response.body);
      if (response.statusCode == 200 &&
          json.decode(response.body)['status'] == true) {
        await fetchAgreements();
        Get.snackbar('Success', 'Agreement signed successfully');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to sign agreement');
    }
  }

  String getStatusColor(String status) {
    switch (status) {
      case 'pending_signatures':
        return '#FFA500'; // Orange
      case 'signed':
        return '#4CAF50'; // Green
      case 'expired':
        return '#F44336'; // Red
      default:
        return '#9E9E9E'; // Grey
    }
  }

  String getStatusText(String status) {
    switch (status) {
      case 'pending_signatures':
        return 'Pending Signatures';
      case 'signed':
        return 'Signed';
      case 'expired':
        return 'Expired';
      default:
        return status.replaceAll('_', ' ').toUpperCase();
    }
  }

  void showDownloadProgressDialog() {
    Get.dialog(
      PopScope(
        canPop: false,
        child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  spreadRadius: 2,
                  color: Colors.black.withOpacity(0.08),
                ),
              ],
            ),
            child: Obx(
                  () => Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TweenAnimationBuilder(
                    tween: Tween<double>(begin: 0.9, end: 1.1),
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.easeInOut,
                    builder: (context, scale, child) {
                      return Transform.scale(
                        scale: scale,
                        child: child,
                      );
                    },
                    child: const Icon(
                      Icons.download_rounded,
                      size: 48,
                      color: Colors.blue,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    "${downloadProgress.value.toInt()}%",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      minHeight: 10,
                      value: downloadProgress.value / 100,
                    ),
                  ),

                  const SizedBox(height: 14),

                  const Text(
                    "Downloading PDF...",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
