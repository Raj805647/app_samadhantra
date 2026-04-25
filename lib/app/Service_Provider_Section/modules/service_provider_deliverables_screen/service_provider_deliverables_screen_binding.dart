import 'package:get/get.dart';
import 'package:samadhantra/app/Service_Provider_Section/modules/service_provider_deliverables_screen/service_provider_deliverables_screen_controller.dart';

class ServiceProviderDeliverablesScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceProviderDeliverablesController>(
          () => ServiceProviderDeliverablesController(),
    );
  }
}