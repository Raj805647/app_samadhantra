// lib/app/modules/service_provider/controllers/service_provider_milestone_controller.dart
import 'package:get/get.dart';

class ServiceProviderMilestoneController extends GetxController {
  var isLoading = false.obs;
  var assignmentId = ''.obs;
  var assignment = {}.obs;
  var milestones = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    assignmentId.value = Get.arguments ?? '';
    loadAssignmentDetails();
  }

  void loadAssignmentDetails() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 1));

    assignment.value = {
      'id': assignmentId.value,
      'title': 'Mobile App Development',
      'client': 'ABC Enterprises',
      'deadline': '2024-01-25',
      'totalBudget': 50000,
    };

    milestones.value = [
      {
        'id': '1',
        'title': 'UI Design Completion',
        'description': 'Complete all UI screens with client approval',
        'dueDate': '2024-01-10',
        'amount': 15000,
        'status': 'Completed',
        'completionDate': '2024-01-09',
        'deliverables': ['ui_design.pdf', 'prototype_link'],
        'notes': 'Client approved with minor changes',
      },
      {
        'id': '2',
        'title': 'Backend API Development',
        'description': 'Develop and test all backend APIs',
        'dueDate': '2024-01-15',
        'amount': 15000,
        'status': 'In Progress',
        'completionDate': null,
        'deliverables': [],
        'notes': 'API documentation in progress',
      },
      {
        'id': '3',
        'title': 'Frontend Integration',
        'description': 'Integrate frontend with backend APIs',
        'dueDate': '2024-01-20',
        'amount': 10000,
        'status': 'Pending',
        'completionDate': null,
        'deliverables': [],
        'notes': '',
      },
    ];

    isLoading.value = false;
  }

  void updateMilestoneStatus(String milestoneId, String status) {
    final index = milestones.indexWhere((m) => m['id'] == milestoneId);
    if (index != -1) {
      milestones[index]['status'] = status;
      if (status == 'Completed') {
        milestones[index]['completionDate'] = DateTime.now().toString().split(' ')[0];
      }
      milestones.refresh();

      // Update assignment progress
      updateAssignmentProgress();
    }
  }

  void updateAssignmentProgress() {
    final totalMilestones = milestones.length;
    final completedMilestones = milestones.where((m) => m['status'] == 'Completed').length;
    final progress = (completedMilestones / totalMilestones * 100).round();

    // Update assignment progress via API
  }

  void addDeliverable(String milestoneId, Map<String, dynamic> deliverable) {
    final index = milestones.indexWhere((m) => m['id'] == milestoneId);
    if (index != -1) {
      milestones[index]['deliverables'].add(deliverable);
      milestones.refresh();
    }
  }

  void addNote(String milestoneId, String note) {
    final index = milestones.indexWhere((m) => m['id'] == milestoneId);
    if (index != -1) {
      milestones[index]['notes'] = note;
      milestones.refresh();
    }
  }

  void requestMilestonePayment(String milestoneId) {
    final milestone = milestones.firstWhere((m) => m['id'] == milestoneId);
    if (milestone['status'] != 'Completed') {
      Get.snackbar('Error', 'Complete milestone before requesting payment');
      return;
    }

    Get.toNamed('/service-provider/request-payment', arguments: {
      'assignmentId': assignmentId.value,
      'milestoneId': milestoneId,
      'amount': milestone['amount'],
      'description': milestone['title'],
    });
  }

  void notifyClient(String milestoneId) {
    final milestone = milestones.firstWhere((m) => m['id'] == milestoneId);

    Get.defaultDialog(
      title: 'Notify Client',
      middleText: 'Send notification to client about milestone update?',
      textConfirm: 'Send',
      textCancel: 'Cancel',
      onConfirm: () {
        Get.back();
        Get.snackbar('Success', 'Client notified');
      },
    );
  }
}