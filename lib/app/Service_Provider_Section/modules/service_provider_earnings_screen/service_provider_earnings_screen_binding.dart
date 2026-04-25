import 'package:get/get.dart';
import 'package:samadhantra/app/Service_Provider_Section/modules/service_provider_earnings_screen/service_provider_earnings_screen_controller.dart';

class ServiceProviderEarningsScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceProviderEarningsController>(
          () => ServiceProviderEarningsController(),
    );
  }
}