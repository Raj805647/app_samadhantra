import 'package:get/get.dart';
import 'package:samadhantra/app/Service_Provider_Section/modules/service_provider_submit_proposal_screen/service_provider_submit_proposal_screen_controller.dart';

class ServiceProviderSubmitProposalScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceProviderSubmitProposalController>(
          () => ServiceProviderSubmitProposalController(),
    );
  }
}