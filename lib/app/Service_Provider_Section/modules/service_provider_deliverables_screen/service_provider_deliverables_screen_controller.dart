// lib/app/modules/service_provider/controllers/service_provider_deliverables_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceProviderDeliverablesController extends GetxController {
  var isLoading = false.obs;
  var assignmentId = ''.obs;
  var assignment = {}.obs;
  var deliverables = <Map<String, dynamic>>[].obs;
  var uploadingFiles = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    assignmentId.value = Get.arguments ?? '';
    loadAssignmentDeliverables();
  }

  void loadAssignmentDeliverables() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 1));

    assignment.value = {
      'id': assignmentId.value,
      'title': 'Mobile App Development',
      'client': 'ABC Enterprises',
      'deadline': '2024-01-25',
    };

    deliverables.value = [
      {
        'id': '1',
        'name': 'UI Design Mockups',
        'type': 'design',
        'files': [
          {'name': 'home_screen.fig', 'size': '2.4 MB', 'uploadDate': '2024-01-05'},
          {'name': 'profile_screen.fig', 'size': '1.8 MB', 'uploadDate': '2024-01-05'},
        ],
        'uploadDate': '2024-01-05',
        'version': '1.0',
        'notes': 'Initial design concepts',
        'clientFeedback': 'Looks good, proceed with development',
      },
      {
        'id': '2',
        'name': 'API Documentation',
        'type': 'document',
        'files': [
          {'name': 'api_docs.pdf', 'size': '3.2 MB', 'uploadDate': '2024-01-10'},
        ],
        'uploadDate': '2024-01-10',
        'version': '1.0',
        'notes': 'Complete API endpoints documentation',
        'clientFeedback': '',
      },
    ];

    isLoading.value = false;
  }

  void addDeliverable(String name, String type, List<Map<String, dynamic>> files, String notes) {
    final newDeliverable = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': name,
      'type': type,
      'files': files,
      'uploadDate': DateTime.now().toString().split(' ')[0],
      'version': '1.0',
      'notes': notes,
      'clientFeedback': '',
    };

    deliverables.add(newDeliverable);
    Get.snackbar('Success', 'Deliverable uploaded');
  }

  void addFileToDeliverable(String deliverableId, Map<String, dynamic> file) {
    final index = deliverables.indexWhere((d) => d['id'] == deliverableId);
    if (index != -1) {
      deliverables[index]['files'].add(file);
      deliverables.refresh();
      Get.snackbar('Success', 'File added');
    }
  }

  void removeFileFromDeliverable(String deliverableId, int fileIndex) {
    final index = deliverables.indexWhere((d) => d['id'] == deliverableId);
    if (index != -1) {
      deliverables[index]['files'].removeAt(fileIndex);
      deliverables.refresh();
      Get.snackbar('Success', 'File removed');
    }
  }

  void updateDeliverableVersion(String deliverableId, String version) {
    final index = deliverables.indexWhere((d) => d['id'] == deliverableId);
    if (index != -1) {
      deliverables[index]['version'] = version;
      deliverables.refresh();
    }
  }

  void deleteDeliverable(String deliverableId) {
    Get.defaultDialog(
      title: 'Delete Deliverable',
      middleText: 'Are you sure you want to delete this deliverable?',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      onConfirm: () {
        deliverables.removeWhere((d) => d['id'] == deliverableId);
        Get.back();
        Get.snackbar('Success', 'Deliverable deleted');
      },
    );
  }

  void notifyClientAboutDeliverable(String deliverableId) {
    Get.defaultDialog(
      title: 'Notify Client',
      middleText: 'Send notification to client about new deliverable?',
      textConfirm: 'Send',
      textCancel: 'Cancel',
      onConfirm: () {
        Get.back();
        Get.snackbar('Success', 'Client notified');
      },
    );
  }

  void simulateFileUpload(String fileName) {
    final uploadId = DateTime.now().millisecondsSinceEpoch.toString();

    uploadingFiles.add({
      'id': uploadId,
      'name': fileName,
      'progress': 0.0,
      'status': 'uploading',
    });

    // Simulate upload progress
    for (int i = 0; i <= 100; i += 10) {
       Future.delayed(Duration(milliseconds: 100));
      final index = uploadingFiles.indexWhere((file) => file['id'] == uploadId);
      if (index != -1) {
        uploadingFiles[index]['progress'] = i.toDouble();
        uploadingFiles.refresh();
      }
    }

    // Mark as completed
    final index = uploadingFiles.indexWhere((file) => file['id'] == uploadId);
    if (index != -1) {
      uploadingFiles[index]['status'] = 'completed';
      uploadingFiles.refresh();
    }
  }
}