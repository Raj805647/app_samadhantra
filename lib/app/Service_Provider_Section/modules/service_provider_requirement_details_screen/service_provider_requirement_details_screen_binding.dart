import 'package:get/get.dart';
import 'package:samadhantra/app/Service_Provider_Section/modules/service_provider_requirement_details_screen/service_provider_requirement_details_screen_controller.dart';

class ServiceProviderRequirementDetailsScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceProviderRequirementDetailsController>(
          () => ServiceProviderRequirementDetailsController(),
    );
  }
}