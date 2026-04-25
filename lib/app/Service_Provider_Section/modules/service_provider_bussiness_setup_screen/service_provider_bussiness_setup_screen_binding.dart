import 'package:get/get.dart';
import 'package:samadhantra/app/Service_Provider_Section/modules/service_provider_bussiness_setup_screen/service_provider_bussiness_setup_screen_controller.dart';

class ServiceProviderBussinessSetupScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceProviderBusinessSetupController>(
          () => ServiceProviderBusinessSetupController(),
    );
  }
}