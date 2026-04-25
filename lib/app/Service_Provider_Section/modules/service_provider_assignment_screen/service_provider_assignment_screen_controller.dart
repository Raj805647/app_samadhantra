// lib/app/modules/service_provider/controllers/service_provider_assignments_controller.dart
import 'package:get/get.dart';

class ServiceProviderAssignmentsController extends GetxController {
  var assignments = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var selectedStatus = 'All'.obs;

  final List<String> statuses = [
    'All',
    'Active',
    'In Progress',
    'On Hold',
    'Completed',
    'Cancelled',
  ];

  @override
  void onInit() {
    super.onInit();
    loadAssignments();
  }

  void loadAssignments() async {
    isLoading.value = true;

    // Simulate API call
    await Future.delayed(Duration(seconds: 1));

    assignments.value = [
      {
        'id': '1',
        'title': 'Mobile App Development',
        'client': 'ABC Enterprises',
        'status': 'In Progress',
        'deadline': '2024-01-25',
        'budget': '₹50,000',
        'progress': 60,
        'milestone': 'Development Phase',
      },
      {
        'id': '2',
        'title': 'Logo Design',
        'client': 'XYZ Corp',
        'status': 'Active',
        'deadline': '2024-01-20',
        'budget': '₹10,000',
        'progress': 30,
        'milestone': 'Initial Concepts',
      },
    ];

    isLoading.value = false;
  }

  void updateMilestone(String assignmentId) {
    Get.toNamed('/service-provider/update-milestone', arguments: assignmentId);
  }

  void uploadDeliverables(String assignmentId) {
    Get.toNamed('/service-provider/upload-deliverables', arguments: assignmentId);
  }

  void requestPayment(String assignmentId) {
    Get.toNamed('/service-provider/request-payment', arguments: assignmentId);
  }

  List<Map<String, dynamic>> get filteredAssignments {
    if (selectedStatus.value == 'All') return assignments;
    return assignments.where((a) => a['status'] == selectedStatus.value).toList();
  }
}