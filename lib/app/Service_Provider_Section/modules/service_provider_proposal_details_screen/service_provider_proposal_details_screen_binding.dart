import 'package:get/get.dart';
import 'package:samadhantra/app/Service_Provider_Section/modules/service_provider_proposal_details_screen/service_provider_proposal_details_screen_controller.dart';

class ServiceProviderProposalDetailsScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceProviderProposalDetailsController>(
      () => ServiceProviderProposalDetailsController(),
    );
  }
}