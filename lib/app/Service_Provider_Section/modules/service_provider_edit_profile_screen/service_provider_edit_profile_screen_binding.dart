import 'package:get/get.dart';
import 'package:samadhantra/app/Service_Provider_Section/modules/service_provider_edit_profile_screen/service_provider_edit_profile_screen_controller.dart';

class ServiceProviderEditProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceProviderEditProfileController>(
          () => ServiceProviderEditProfileController(),
    );
  }
}