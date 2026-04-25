import 'package:get/get.dart';
import 'package:samadhantra/app/Service_Provider_Section/modules/service_provider_opportunities_screen/service_provider_opportunities_screen_controller.dart';

class ServiceProviderOpportunitiesScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceProviderOpportunitiesController>(
          () => ServiceProviderOpportunitiesController(),
    );
  }
}