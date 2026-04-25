import 'package:get/get.dart';
import 'package:samadhantra/app/Service_Provider_Section/modules/service_provider_milestone_screen/service_provider_milestone_screen_controller.dart';

class ServiceProviderMilestoneScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceProviderMilestoneController>(
          () => ServiceProviderMilestoneController(),
    );
  }
}