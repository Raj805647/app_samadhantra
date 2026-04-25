import 'package:get/get.dart';
import 'package:samadhantra/app/Service_Provider_Section/modules/service_provider_profile_screen/service_provider_profile_screen_controller.dart';

class ServiceProviderProfileScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceProviderProfileController>(
          () => ServiceProviderProfileController(),
    );
  }
}