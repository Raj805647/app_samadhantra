import 'package:get/get.dart';
import 'package:samadhantra/app/Service_Provider_Section/modules/service_provider_proposal_screen/service_provider_proposal_screen_controller.dart';

class ServiceProviderProposalScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceProviderProposalsController>(
          () => ServiceProviderProposalsController(),
    );
  }
}