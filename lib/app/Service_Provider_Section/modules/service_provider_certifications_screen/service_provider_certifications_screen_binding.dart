import 'package:get/get.dart';
import 'package:samadhantra/app/Service_Provider_Section/modules/service_provider_certifications_screen/service_provider_certifications_screen_controller.dart';

class ServiceProviderCertificationsScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceProviderCertificationsController>(
          () => ServiceProviderCertificationsController(),
    );
  }
}