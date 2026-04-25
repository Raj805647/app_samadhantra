import 'package:get/get.dart';
import 'package:samadhantra/app/Service_Provider_Section/modules/service_provider_reviews_screen/service_provider_reviews_screen_controller.dart';

class ServiceProviderReviewsScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceProviderReviewsController>(
          () => ServiceProviderReviewsController(),
    );
  }
}