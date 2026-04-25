import 'package:get/get.dart';
import 'package:samadhantra/app/Service_Provider_Section/modules/service_provider_service_details_screen/service_provider_service_details_screen_controller.dart';

class ServiceProviderServiceDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceProviderServiceDetailsController>(
          () => ServiceProviderServiceDetailsController(),
    );
  }
}