// lib/app/modules/service_provider/controllers/service_provider_requirement_details_controller.dart
import 'package:get/get.dart';
import 'package:samadhantra/app/global_routes/app_routes.dart';

class ServiceProviderRequirementDetailsController extends GetxController {
  var requirement = {}.obs;
  var isLoading = false.obs;
  var isBookmarked = false.obs;
  var similarRequirements = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    final requirementId = Get.arguments;
    loadRequirementDetails(requirementId);
    loadSimilarRequirements();
  }

  void loadRequirementDetails(String requirementId) async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 1));

    requirement.value = {
      'id': requirementId,
      'title': 'E-commerce Website Development',
      'description': 'Need a complete e-commerce solution with:\n• Product catalog\n• Shopping cart\n• Payment gateway integration\n• Admin panel\n• Mobile responsive design\n• Inventory management\n• Order tracking',
      'budget': 75000,
      'deadline': '2024-01-25',
      'category': 'Technology',
      'postedBy': 'ABC Enterprises',
      'postedDate': '2024-01-10',
      'location': 'Remote',
      'skillsRequired': ['Flutter', 'Node.js', 'MongoDB', 'Payment Gateway', 'AWS'],
      'attachments': [
        {'name': 'project_brief.pdf', 'size': '2.4 MB'},
        {'name': 'design_reference.zip', 'size': '5.1 MB'},
      ],
      'additionalInfo': {
        'projectDuration': '30 days',
        'meetingsRequired': 'Weekly',
        'preferredCommunication': 'Zoom/Google Meet',
        'expectedStartDate': '2024-01-15',
      },
      'clientInfo': {
        'name': 'ABC Enterprises',
        'rating': 4.5,
        'completedProjects': 24,
        'memberSince': '2022-03-15',
      },
    };

    isBookmarked.value = false;
    isLoading.value = false;
  }

  void loadSimilarRequirements() async {
    similarRequirements.value = [
      {
        'id': '3',
        'title': 'Mobile App Development',
        'budget': 50000,
        'category': 'Technology',
        'deadline': '2024-01-30',
      },
      {
        'id': '4',
        'title': 'Website Redesign',
        'budget': 35000,
        'category': 'Design',
        'deadline': '2024-02-05',
      },
    ];
  }

  void toggleBookmark() {
    isBookmarked.value = !isBookmarked.value;
    // Call API to update bookmark
  }

  void submitProposal() {
    Get.toNamed(AppRoutes.serviceProviderSubmitProposal);
    // Get.toNamed('/service-provider/submit-proposal', arguments: {
    //   'requirementId': requirement['id'],
    //   'requirementTitle': requirement['title'],
    // });
  }

  void contactClient() {
    Get.toNamed('/service-provider/messages', arguments: {
      'userId': requirement['clientInfo']['id'],
      'userName': requirement['clientInfo']['name'],
    });
  }

  void viewClientProfile() {
    Get.toNamed('/service-provider/client-profile', arguments: {
      'clientId': requirement['clientInfo']['id'],
    });
  }
}