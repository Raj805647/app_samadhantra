import 'package:get/get.dart';
import 'package:samadhantra/app/Service_Provider_Section/modules/service_provider_home_screen/service_provider_home_screen_controller.dart';

class ServiceProviderHomeScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceProviderHomeController>(
          () => ServiceProviderHomeController(),
    );
  }
}