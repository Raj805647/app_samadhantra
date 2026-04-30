import 'package:get/get.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/create_required_agreement/create_required_agreement_controller.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/privacy_policy/privacy_policy_controller.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/settings_screen/settings_controller.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/terms_condition/terms_condition_controller.dart';
import '../Service_Provider_Section/modules/service_provider_add_service_screen/service-provider_add-service_screen_controller.dart';
import '../Service_Provider_Section/modules/service_provider_assignment_screen/service_provider_assignment_screen_controller.dart';
import '../Stakeholder_Section/modules/active_target_list/active_target_list_controller.dart';
import '../Stakeholder_Section/modules/assignment_details/assignment_details_controller.dart';
import '../Stakeholder_Section/modules/assignment_screen/assignment_screen_controller.dart';
import '../Stakeholder_Section/modules/blog/blog_controller.dart';
import '../Stakeholder_Section/modules/bottom_nav_screen/bottom_nav_screen_controller.dart';
import '../Stakeholder_Section/modules/complete_profile_screen/complete_profile_screen_controller.dart';
import '../Stakeholder_Section/modules/event/event_controller.dart';
import '../Stakeholder_Section/modules/faq/faq_controller.dart';
import '../Stakeholder_Section/modules/home_screen/home_screen_controller.dart';
import '../Stakeholder_Section/modules/message_details_screen/message_details_screen_controller.dart';
import '../Stakeholder_Section/modules/message_screen/message_screen_controller.dart';
import '../Stakeholder_Section/modules/my_agreement/my_agreement_controller.dart';
import '../Stakeholder_Section/modules/my_requirement/my_requirement_controller.dart';
import '../Stakeholder_Section/modules/new_message_screen/new_message_screen_controller.dart';
import '../Stakeholder_Section/modules/new_ticket_screen/new_ticket_screen_controller.dart';
import '../Stakeholder_Section/modules/notification_screen/notification_screen_controller.dart';
import '../Stakeholder_Section/modules/payment_details_screen/payment_details_screen_controller.dart';
import '../Stakeholder_Section/modules/payment_history_screen/payment_history_screen_controller.dart';
import '../Stakeholder_Section/modules/payment_screen/payment_screen_controller.dart';
import '../Stakeholder_Section/modules/post_requirement_screen/post_requirement_screen_controller.dart';
import '../Stakeholder_Section/modules/profile_screen/profile_screen_controller.dart';
import '../Stakeholder_Section/modules/proposals_details_screen/proposals_details_screen_controller.dart';
import '../Stakeholder_Section/modules/razorpay_screen/razorpay_controller.dart';
import '../Stakeholder_Section/modules/requirement_details_screen/requirement_details_screen_controller.dart';
import '../Stakeholder_Section/modules/requiremnent_list_screen/requiremnent_list_screen_controller.dart';
import '../Stakeholder_Section/modules/review_service_screen/review_service_screen_controller.dart';
import '../Stakeholder_Section/modules/support_screen/support_screen_controller.dart';
import '../Stakeholder_Section/modules/update_profile/update_profile_controller.dart';
import '../modules/auth/forgot_otp_screen/forgot_otp_screen_controller.dart';
import '../modules/auth/login_screen/login_screen_controller.dart';
import '../modules/auth/onboarding_screen/onboarding_screen_controller.dart';
import '../modules/auth/otp_screen/otp_screen_controller.dart';
import '../modules/auth/reset_password_screen/reset_password_screen_controller.dart';
import '../modules/auth/role_selection_screen/role_selection_screen_controller.dart';
import '../modules/auth/signup_screen/signup_screen_controller.dart';
import '../modules/auth/splash_screen/splash_screen_controller.dart';
import '../modules/auth/stakeholder_signup2_screen/stakeholder_signup2_screen_controller.dart';

class ServiceProviderAddServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceProviderAddServiceController>(
          () => ServiceProviderAddServiceController(),
    );
  }
}

class ServiceProviderAssignmentScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceProviderAssignmentsController>(
          () => ServiceProviderAssignmentsController(),
    );
  }
}
class ActiveTargetListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ActiveTargetListController>(
          () => ActiveTargetListController(),
    );
  }
}

class AssignmentBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AssignmentController());
  }
}

class BottomNavScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomNavController>(
          () => BottomNavController(),
    );
  }
}

class CompleteProfileBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<RazorpayController>()) {
      Get.put(RazorpayController(), permanent: true);
    }
    Get.lazyPut<CompleteProfileController>(
          () => CompleteProfileController(),
    );
  }
}

class HomeScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeScreenController>(
          () => HomeScreenController(),
    );
  }
}

class MessageThreadBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MessageDetailsController>(
          () => MessageDetailsController(),
      fenix: true,
    );
  }
}

class MessagesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MessageController>(
          () => MessageController(),
    );
  }
}

class MyRequiremntBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyRequirementController>(
          () => MyRequirementController(),
    );
  }
}

class MyRequirementDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyRequirementController>(
          () => MyRequirementController(),
    );
  }
}

class NewMessageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewMessageController>(
          () => NewMessageController(),
      fenix: true,
    );
  }
}

class NewTicketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NewTicketController());
  }
}

class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotificationsController>(
          () => NotificationsController(),
    );
  }
}

class PaymentDetailsScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PaymentDetailController());
  }
}


class ServiceProviderSettingsScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingsController>(
          () => SettingsController(),
    );
  }
}

class RoleSelectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RoleSelectionController>(
          () => RoleSelectionController(),
    );
  }
}

class ReviewServiceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ReviewServiceController());
  }
}

class RequiremnentListScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RequirementsController>(
          () => RequirementsController(),
    );
  }
}

class RequirementDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RequirementDetailsScreenController>(
          () => RequirementDetailsScreenController(),
    );
  }
}


class ProposalDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProposalDetailController());
  }
}

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(
          () => ProfileController(),
    );
  }
}

class PostRequirementScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PostRequirementController>(
          () => PostRequirementController(),
    );
  }
}


class PaymentBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PaymentController());
  }
}

class PaymentHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PaymentHistoryController());
  }
}

class SupportBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SupportController());
  }
}

class ForgotOtpScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ForgotOtpScreenController>(() => ForgotOtpScreenController());
  }
}

class LoginScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginScreenController>(() => LoginScreenController());
  }
}

class OtpScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtpScreenController>(() => OtpScreenController());
  }
}


class ResetPasswordScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ResetPasswordScreenController>(() => ResetPasswordScreenController());
  }
}


class SignupScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SignupScreenController>(() => SignupScreenController());
  }
}

class StakehodlerSignUp2ScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StakeholderSignup2ScreenController>(() => StakeholderSignup2ScreenController());
  }
}

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OnboardingController());
  }
}

class SplashScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashScreenController>(() => SplashScreenController());
  }
}

class UpdateProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpdateProfileController>(() => UpdateProfileController());
  }
}

class FaqBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FaqController>(() => FaqController());
  }
}

class FaqChatBoxBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FaqController>(() => FaqController());
  }
}

class BlogBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BlogController>(() => BlogController());
  }
}

class BlogDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BlogController>(() => BlogController());
  }
}

class EventDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BlogController>(() => BlogController());
  }
}

class EventBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EventController>(() => EventController());
  }
}

class CreateRequiredAgreementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateRequiredAgreementController>(() => CreateRequiredAgreementController());
  }
}

class MyAgreementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyAgreementController>(() => MyAgreementController());
  }
}


class PrivacyPolicyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PrivacyPolicyController>(() => PrivacyPolicyController());
  }
}

class TermsConditionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TermsConditionsController>(() => TermsConditionsController());
  }
}

class AssignmentDetailBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AssignmentDetailsController>(() => AssignmentDetailsController());
  }
}

class MyAgreementDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyAgreementController>(() => MyAgreementController());
  }
}
