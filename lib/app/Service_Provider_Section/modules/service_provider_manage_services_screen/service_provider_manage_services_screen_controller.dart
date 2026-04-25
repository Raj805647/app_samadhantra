import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:samadhantra/app/constant/custom_snackbar.dart';
import 'package:samadhantra/app/data/model/service_service_model.dart';
import 'package:samadhantra/app/global_routes/app_routes.dart';

class ServiceProviderManageServicesController extends GetxController {
  var isLoading = false.obs;
  var isRefreshing = false.obs;
  var selectedFilter = ServiceFilter.all.obs;
  var searchQuery = ''.obs;
  var selectedServices = <String>[].obs;
  var isSelectionMode = false.obs;

  var services = <ServiceModel>[].obs;

  final List<ServiceFilter> filters = [
    ServiceFilter.all,
    ServiceFilter.active,
    ServiceFilter.inactive,
    ServiceFilter.featured,
  ];

  final List<String> categories = [
    'All',
    'Web Development',
    'Mobile App Development',
    'UI/UX Design',
    'Graphic Design',
    'Digital Marketing',
    'SEO',
    'Content Writing',
    'Video Editing',
    'Consulting',
    'E-commerce',
    'Cloud Services',
  ];

  final List<String> experienceLevels = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'Expert',
  ];

  final List<String> pricingModels = [
    'Hourly',
    'Daily',
    'Project-based',
    'Monthly',
  ];

  @override
  void onInit() {
    super.onInit();
    loadServices();
  }

  void loadServices() async {
    isLoading.value = true;

    // Simulate API call
    await Future.delayed(Duration(seconds: 1));

    // Sample services data
    services.value = [
      ServiceModel(
        id: '1',
        name: 'Flutter Mobile App Development',
        description: 'Build cross-platform mobile applications using Flutter framework with clean architecture and best practices.',
        hourlyRate: 1500,
        dailyRate: 10000,
        projectRate: 50000,
        category: 'Mobile App Development',
        tags: ['Flutter', 'Dart', 'Firebase', 'REST API'],
        isActive: true,
        isFeatured: true,
        createdAt: DateTime.now().subtract(Duration(days: 30)),
        skills: ['Flutter', 'Dart', 'Firebase', 'State Management', 'API Integration'],
        experienceLevel: 'Advanced',
        deliveryDays: 14,
        icon: 'mobile',
      ),
      ServiceModel(
        id: '2',
        name: 'Responsive Web Design',
        description: 'Create beautiful, responsive websites that work perfectly on all devices with modern design principles.',
        hourlyRate: 1200,
        dailyRate: 8000,
        projectRate: 35000,
        category: 'Web Development',
        tags: ['HTML', 'CSS', 'JavaScript', 'Responsive'],
        isActive: true,
        isFeatured: false,
        createdAt: DateTime.now().subtract(Duration(days: 45)),
        skills: ['HTML5', 'CSS3', 'JavaScript', 'Bootstrap', 'Responsive Design'],
        experienceLevel: 'Intermediate',
        deliveryDays: 7,
        icon: 'web',
      ),
      ServiceModel(
        id: '3',
        name: 'UI/UX Design',
        description: 'Design intuitive user interfaces and user experiences for web and mobile applications.',
        hourlyRate: 1800,
        dailyRate: 12000,
        projectRate: 60000,
        category: 'UI/UX Design',
        tags: ['Figma', 'Adobe XD', 'Wireframing', 'Prototyping'],
        isActive: true,
        isFeatured: true,
        createdAt: DateTime.now().subtract(Duration(days: 60)),
        skills: ['Figma', 'Adobe XD', 'User Research', 'Wireframing', 'Prototyping'],
        experienceLevel: 'Expert',
        deliveryDays: 10,
        icon: 'design',
      ),
      ServiceModel(
        id: '4',
        name: 'SEO Optimization',
        description: 'Improve your website\'s search engine ranking and increase organic traffic.',
        hourlyRate: 1000,
        dailyRate: 7000,
        projectRate: 30000,
        category: 'SEO',
        tags: ['SEO', 'Google Analytics', 'Keyword Research'],
        isActive: false,
        isFeatured: false,
        createdAt: DateTime.now().subtract(Duration(days: 90)),
        skills: ['SEO', 'Google Analytics', 'Keyword Research', 'On-page SEO', 'Off-page SEO'],
        experienceLevel: 'Intermediate',
        deliveryDays: 30,
        icon: 'seo',
      ),
      ServiceModel(
        id: '5',
        name: 'Social Media Marketing',
        description: 'Create and manage social media campaigns to increase brand awareness and engagement.',
        hourlyRate: 900,
        dailyRate: 6000,
        projectRate: 25000,
        category: 'Digital Marketing',
        tags: ['Social Media', 'Marketing', 'Content Creation'],
        isActive: true,
        isFeatured: false,
        createdAt: DateTime.now().subtract(Duration(days: 120)),
        skills: ['Social Media Strategy', 'Content Creation', 'Analytics', 'Campaign Management'],
        experienceLevel: 'Intermediate',
        deliveryDays: 15,
        icon: 'marketing',
      ),
    ];

    isLoading.value = false;
  }

  void refreshServices() async {
    isRefreshing.value = true;
    await Future.delayed(Duration(seconds: 1));
    loadServices();
    isRefreshing.value = false;
  }

  void filterServices(ServiceFilter filter) {
    selectedFilter.value = filter;
  }

  List<ServiceModel> get filteredServices {
    var filtered = services.toList();

    // Apply search filter
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((service) {
        return service.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
            service.description.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
            service.tags.any((tag) => tag.toLowerCase().contains(searchQuery.value.toLowerCase()));
      }).toList();
    }

    // Apply category filter
    if (selectedFilter.value != ServiceFilter.all) {
      switch (selectedFilter.value) {
        case ServiceFilter.active:
          filtered = filtered.where((service) => service.isActive).toList();
          break;
        case ServiceFilter.inactive:
          filtered = filtered.where((service) => !service.isActive).toList();
          break;
        case ServiceFilter.featured:
          filtered = filtered.where((service) => service.isFeatured).toList();
          break;
        default:
          break;
      }
    }

    return filtered;
  }

  void toggleServiceSelection(String serviceId) {
    if (selectedServices.contains(serviceId)) {
      selectedServices.remove(serviceId);
    } else {
      selectedServices.add(serviceId);
    }

    if (selectedServices.isEmpty) {
      isSelectionMode.value = false;
    }
  }

  void selectAllServices() {
    if (selectedServices.length == filteredServices.length) {
      selectedServices.clear();
    } else {
      selectedServices.value = filteredServices.map((s) => s.id).toList();
    }
  }

  void toggleSelectionMode() {
    isSelectionMode.value = !isSelectionMode.value;
    if (!isSelectionMode.value) {
      selectedServices.clear();
    }
  }

  void addNewService() {
    Get.toNamed(AppRoutes.serviceProviderAddService);
  }

  void editService(String serviceId) {
    final service = services.firstWhere((s) => s.id == serviceId);
    Get.toNamed('/service-provider/edit-service', arguments: service);
  }

  void deleteService(String serviceId) {
    Get.defaultDialog(
      title: 'Delete Service',
      middleText: 'Are you sure you want to delete this service? This action cannot be undone.',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      onConfirm: () {
        services.removeWhere((s) => s.id == serviceId);
        selectedServices.remove(serviceId);
        Get.back();
        CustomSnackBar.show(message: "Service deleted successfully",type: ContentType.success,title: "Deleted");
      },
    );
  }

  void deleteSelectedServices() {
    if (selectedServices.isEmpty) return;

    Get.defaultDialog(
      title: 'Delete Services',
      middleText: 'Are you sure you want to delete ${selectedServices.length} selected service(s)?',
      textConfirm: 'Delete ${selectedServices.length} Services',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      onConfirm: () {
        services.removeWhere((s) => selectedServices.contains(s.id));
        selectedServices.clear();
        isSelectionMode.value = false;
        Get.back();
        CustomSnackBar.show(message: "Selected services deleted",type: ContentType.success,title: "Deleted");
      },
    );
  }

  void toggleServiceStatus(String serviceId) {
    final index = services.indexWhere((s) => s.id == serviceId);
    if (index != -1) {
      final service = services[index];
      services[index] = service.copyWith(
        isActive: !service.isActive,
        updatedAt: DateTime.now(),
      );
      services.refresh();
      CustomSnackBar.show(message: "Service ${service.isActive ? 'activated' : 'deactivated'}",type: ContentType.success,title: "Status Updated");
    }
  }

  void toggleFeaturedStatus(String serviceId) {
    final index = services.indexWhere((s) => s.id == serviceId);
    if (index != -1) {
      final service = services[index];
      services[index] = service.copyWith(
        isFeatured: !service.isFeatured,
        updatedAt: DateTime.now(),
      );
      services.refresh();
      CustomSnackBar.show(message: "Service ${service.isFeatured ? 'marked as featured' : 'removed from featured'}",type: ContentType.success,title: "Featured Updated");
    }
  }

  void updateServiceRates(String serviceId, double hourly, double daily, double project) {
    final index = services.indexWhere((s) => s.id == serviceId);
    if (index != -1) {
      final service = services[index];
      services[index] = service.copyWith(
        hourlyRate: hourly,
        dailyRate: daily,
        projectRate: project,
        updatedAt: DateTime.now(),
      );
      services.refresh();
    }
  }

  void viewServiceDetails(String serviceId) {
    final service = services.firstWhere((s) => s.id == serviceId);
    Get.toNamed(AppRoutes.serviceProviderProposalDetails, arguments: service);
  }

  void duplicateService(String serviceId) {
    final service = services.firstWhere((s) => s.id == serviceId);
    final newService = service.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: '${service.name} (Copy)',
      createdAt: DateTime.now(),
      isActive: false,
      isFeatured: false,
    );

    services.insert(0, newService);
    CustomSnackBar.show(message: "Service duplicated successfully",type: ContentType.success,title: "Duplicated");

  }

  void exportServices() {
    // Export services to CSV/PDF
    CustomSnackBar.show(message: "Service data export in progress",type: ContentType.success,title: "Export Started");
  }

  void sortServices(String sortBy) {
    switch (sortBy) {
      case 'name':
        services.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'rate_high':
        services.sort((a, b) => b.hourlyRate.compareTo(a.hourlyRate));
        break;
      case 'rate_low':
        services.sort((a, b) => a.hourlyRate.compareTo(b.hourlyRate));
        break;
      case 'newest':
        services.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'oldest':
        services.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
    }
    services.refresh();
  }

  int get activeServicesCount => services.where((s) => s.isActive).length;
  int get featuredServicesCount => services.where((s) => s.isFeatured).length;
  double get averageHourlyRate => services.isEmpty ? 0 : services.map((s) => s.hourlyRate).reduce((a, b) => a + b) / services.length;
}

enum ServiceFilter {
  all,
  active,
  inactive,
  featured,
}