// lib/app/modules/service_provider/bindings/service_provider_notifications_binding.dart
import 'package:get/get.dart';
import 'package:samadhantra/app/Service_Provider_Section/modules/service_provider_notifications_screen/service_provider_notifications_screen_controller.dart';


class ServiceProviderNotificationsScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceProviderNotificationsController>(
          () => ServiceProviderNotificationsController(),
    );
  }
}