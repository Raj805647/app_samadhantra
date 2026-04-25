import 'package:get/get.dart';
import 'package:samadhantra/app/Service_Provider_Section/modules/service_provider_portfolio_screen/service_provider_portfolio_screen_controller.dart';

class ServiceProviderPortfolioScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceProviderPortfolioController>(
          () => ServiceProviderPortfolioController(),
    );
  }
}