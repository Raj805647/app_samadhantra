// lib/app/modules/service_provider/controllers/service_provider_certifications_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceProviderCertificationsController extends GetxController {
  var certifications = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCertifications();
  }

  void loadCertifications() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 1));

    certifications.value = [
      {
        'id': '1',
        'name': 'Google Cloud Professional',
        'issuer': 'Google',
        'issueDate': '2023-06-15',
        'expiryDate': '2025-06-15',
        'certificateId': 'GCP-2023-12345',
        'document': 'google_cert.pdf',
        'verified': true,
      },
      {
        'id': '2',
        'name': 'AWS Solutions Architect',
        'issuer': 'Amazon Web Services',
        'issueDate': '2022-11-20',
        'expiryDate': '2024-11-20',
        'certificateId': 'AWS-SA-2022-67890',
        'document': 'aws_cert.pdf',
        'verified': true,
      },
      {
        'id': '3',
        'name': 'Flutter Development',
        'issuer': 'Flutter Institute',
        'issueDate': '2023-03-10',
        'expiryDate': null,
        'certificateId': 'FLUT-2023-54321',
        'document': 'flutter_cert.pdf',
        'verified': false,
      },
    ];

    isLoading.value = false;
  }

  void addCertification(Map<String, dynamic> cert) {
    certifications.add(cert);
    Get.snackbar('Success', 'Certification added');
  }

  void verifyCertification(String id) {
    final index = certifications.indexWhere((cert) => cert['id'] == id);
    if (index != -1) {
      certifications[index]['verified'] = true;
      certifications.refresh();
    }
  }

  void deleteCertification(String id) {
    Get.defaultDialog(
      title: 'Delete Certification',
      middleText: 'Are you sure you want to delete this certification?',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      onConfirm: () {
        certifications.removeWhere((cert) => cert['id'] == id);
        Get.back();
        Get.snackbar('Success', 'Certification deleted');
      },
    );
  }
}