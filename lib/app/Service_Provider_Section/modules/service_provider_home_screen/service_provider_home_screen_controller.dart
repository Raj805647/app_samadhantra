// lib/app/modules/service_provider/controllers/service_provider_home_controller.dart
import 'package:get/get.dart';

class ServiceProviderHomeController extends GetxController {
  var isLoading = false.obs;
  var activeProposals = 5.obs;
  var activeAssignments = 3.obs;
  var totalEarnings = 25000.0.obs;
  var pendingPayments = 15000.0.obs;
  var recentOpportunities = <Map<String, dynamic>>[].obs;
  var recentAssignments = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  void loadDashboardData() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 1));

    recentOpportunities.value = [
      {
        'id': '1',
        'title': 'Mobile App Development',
        'budget': '₹50,000',
        'posted': '2 hours ago',
        'category': 'Technology',
      },
      {
        'id': '2',
        'title': 'Logo Design',
        'budget': '₹10,000',
        'posted': '5 hours ago',
        'category': 'Design',
      },
    ];

    recentAssignments.value = [
      {
        'id': '1',
        'title': 'E-commerce Website',
        'client': 'ABC Corp',
        'status': 'In Progress',
        'deadline': 'Tomorrow',
      },
      {
        'id': '2',
        'title': 'Brand Identity',
        'client': 'XYZ Ltd',
        'status': 'Active',
        'deadline': '3 days',
      },
    ];

    isLoading.value = false;
  }

  void refreshDashboard() {
    loadDashboardData();
  }
}