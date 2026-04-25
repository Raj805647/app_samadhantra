// lib/app/modules/service_provider/controllers/service_provider_opportunities_controller.dart
import 'package:get/get.dart';

class ServiceProviderOpportunitiesController extends GetxController {
  var requirements = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var selectedCategory = 'All'.obs;
  var searchQuery = ''.obs;

  final categories = <String>[
    'All',
    'Technology',
    'Design',
    'Marketing',
    'Consulting',
    'Writing',
    'Other',
  ].obs;

  @override
  void onInit() {
    super.onInit();
    loadRequirements();
  }

  void loadRequirements() async {
    isLoading.value = true;
    // Simulate API call
    await Future.delayed(Duration(seconds: 1));

    requirements.value = [
      {
        'id': '1',
        'title': 'E-commerce Website Development',
        'description': 'Need a complete e-commerce solution with payment gateway integration',
        'budget': '₹75,000 - ₹1,00,000',
        'deadline': '15 days',
        'category': 'Technology',
        'postedBy': 'ABC Enterprises',
        'postedDate': '2024-01-10',
        'proposalCount': 12,
        'isBookmarked': false,
      },
      {
        'id': '2',
        'title': 'Corporate Branding Package',
        'description': 'Logo, business cards, letterhead design',
        'budget': '₹20,000 - ₹30,000',
        'deadline': '7 days',
        'category': 'Design',
        'postedBy': 'XYZ Corp',
        'postedDate': '2024-01-09',
        'proposalCount': 8,
        'isBookmarked': true,
      },
    ];

    isLoading.value = false;
  }

  void toggleBookmark(int index) {
    requirements[index]['isBookmarked'] = !requirements[index]['isBookmarked'];
    requirements.refresh();
  }

  List<Map<String, dynamic>> get filteredRequirements {
    var filtered = requirements;

    if (selectedCategory.value != 'All') {
      filtered = filtered.where((req) => req['category'] == selectedCategory.value).toList().obs;
    }

    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((req) =>
      req['title'].toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          req['description'].toLowerCase().contains(searchQuery.value.toLowerCase())
      ).toList().obs;
    }

    return filtered;
  }
}