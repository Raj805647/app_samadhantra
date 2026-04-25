// controllers/proposal_detail_controller.dart
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/constant/custom_snackbar.dart';
import 'package:samadhantra/app/data/model/stake_proposal_detail_model.dart';

class ProposalDetailController extends GetxController {
  final Rx<ProposalDetailModel?> proposal = Rx<ProposalDetailModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString selectedTab = 'Details'.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isProvider = false.obs;
  final TextEditingController messageController = TextEditingController();
  final RxList<MessageModel> messages = <MessageModel>[].obs;

  String? proposalId;
  String? requirementId;

  @override
  void onInit() {
    super.onInit();
    getIdsFromRoute();
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }

  void getIdsFromRoute() {

    final dynamic args = Get.arguments;

    if (args is Map<String, dynamic>) {
      proposalId = args['proposalId']?.toString();
      requirementId = args['requirementId']?.toString();
      isProvider.value = args['isProvider'] ?? false;
    }

    if (proposalId != null && proposalId!.isNotEmpty) {
      loadProposalDetails(proposalId!);
    } else {
      errorMessage.value = 'Proposal ID not found';
    }
  }

  Future<void> loadProposalDetails(String id) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock data for demonstration
      final mockProposals = {
        'p1': ProposalDetailModel(
          id: 'p1',
          requirementId: '1',
          requirementTitle: 'Mobile App Development',
          providerId: 'provider_001',
          providerName: 'Tech Solutions Inc.',
          providerImage: '',
          providerRating: '4.8',
          providerCompletedProjects: 124,
          providerDescription:
              'We are a team of experienced developers specializing in Flutter mobile applications with 5+ years of experience.',
          price: '₹75,000',
          timeline: '25 Days',
          description:
              'We propose to develop your e-commerce mobile app with the following features:\n\n1. User authentication with OTP verification\n2. Product catalog with advanced search and filters\n3. Shopping cart with real-time updates\n4. Secure payment gateway integration (Razorpay, Stripe)\n5. Real-time order tracking\n6. Push notifications using Firebase\n7. Admin dashboard for content management\n\nWe will follow Agile methodology with weekly sprints and provide regular demos.',
          status: 'submitted',
          submittedDate: DateTime.now().subtract(const Duration(days: 2)),
          attachments: [
            'Proposal_Document.pdf',
            'Technical_Architecture.docx',
            'Timeline_Gantt_Chart.xlsx',
            'Portfolio_Samples.zip',
          ],
          messages: [
            MessageModel(receiverId: '',

              id: 'm1',
              senderId: 'provider_001',
              senderName: 'Tech Solutions Inc.',
              message:
                  'Hello! We have submitted our proposal for your mobile app development project.',
              timestamp: DateTime.now().subtract(
                const Duration(days: 2, hours: 3),
              ),
              isRead: true,
            ),
            MessageModel(
              receiverId: '',
              id: 'm2',
              senderId: 'client_001',
              senderName: 'You',
              message:
                  'Thanks for your proposal. Can you provide some references of similar apps you have built?',
              timestamp: DateTime.now().subtract(
                const Duration(days: 2, hours: 1),
              ),
              isRead: true,
            ),
            MessageModel(
              receiverId: '',
              id: 'm3',
              senderId: 'provider_001',
              senderName: 'Tech Solutions Inc.',
              message:
                  'Sure! We have built e-commerce apps for FashionHub and TechMart. You can check them on the Play Store.',
              timestamp: DateTime.now().subtract(
                const Duration(days: 1, hours: 5),
              ),
              isRead: true,
            ),
          ],
          termsAndConditions:
              '1. 30% advance payment before starting the project\n2. 40% after completion of UI/UX design\n3. 30% upon final delivery\n4. 3 months free maintenance after deployment\n5. All source code will be delivered\n6. One year of technical support included',
          additionalNotes:
              'We can start the project within 3 days of approval. Our team includes 1 Project Manager, 2 Flutter Developers, and 1 UI/UX Designer.',
        ),
        'p2': ProposalDetailModel(
          id: 'p2',
          requirementId: '1',
          requirementTitle: 'Mobile App Development',
          providerId: 'provider_002',
          providerName: 'Mobile App Masters',
          providerImage: '',
          providerRating: '4.6',
          providerCompletedProjects: 89,
          providerDescription:
              'Specialized in Flutter development with 50+ apps delivered on both iOS and Android platforms.',
          price: '₹90,000',
          timeline: '28 Days',
          description:
              'We offer premium Flutter development services with focus on performance and scalability.',
          status: 'submitted',
          submittedDate: DateTime.now().subtract(const Duration(days: 1)),
          attachments: ['Proposal.pdf'],
          messages: [],
          termsAndConditions: '',
          additionalNotes: '',
        ),
        'p3': ProposalDetailModel(
          id: 'p3',
          requirementId: '1',
          requirementTitle: 'Mobile App Development',
          providerId: 'provider_003',
          providerName: 'Digital Innovators',
          providerImage: '',
          providerRating: '4.9',
          providerCompletedProjects: 156,
          providerDescription:
              'Award-winning development agency with expertise in enterprise applications.',
          price: '₹65,000',
          timeline: '35 Days',
          description:
              'We offer comprehensive solution with 6 months free maintenance and regular updates.',
          status: 'accepted',
          submittedDate: DateTime.now().subtract(const Duration(days: 3)),
          acceptedDate: DateTime.now().subtract(const Duration(days: 1)),
          attachments: ['Proposal_Accepted.pdf'],
          messages: [],
          termsAndConditions: '',
          additionalNotes: '',
        ),
      };

      proposal.value = mockProposals[id];

      if (proposal.value != null) {
        messages.value = proposal.value!.messages;
        print(
          '✅ Proposal loaded successfully: ${proposal.value!.providerName}',
        );
      } else {
        errorMessage.value = 'Proposal not found';
        print('❌ Proposal not found with ID: $id');
      }
    } catch (e) {
      errorMessage.value = 'Failed to load proposal: $e';
      print('❌ Error loading proposal: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void changeTab(String tabName) {
    selectedTab.value = tabName;
  }

  void acceptProposal() {
    if (proposal.value != null) {
      final updatedProposal = ProposalDetailModel(
        id: proposal.value!.id,
        requirementId: proposal.value!.requirementId,
        requirementTitle: proposal.value!.requirementTitle,
        providerId: proposal.value!.providerId,
        providerName: proposal.value!.providerName,
        providerImage: proposal.value!.providerImage,
        providerRating: proposal.value!.providerRating,
        providerCompletedProjects: proposal.value!.providerCompletedProjects,
        providerDescription: proposal.value!.providerDescription,
        price: proposal.value!.price,
        timeline: proposal.value!.timeline,
        description: proposal.value!.description,
        status: 'accepted',
        submittedDate: proposal.value!.submittedDate,
        acceptedDate: DateTime.now(),
        attachments: proposal.value!.attachments,
        messages: proposal.value!.messages,
        termsAndConditions: proposal.value!.termsAndConditions,
        additionalNotes: proposal.value!.additionalNotes,
      );

      proposal.value = updatedProposal;

      CustomSnackBar.show(
        title: "Proposal Accepted",
        message:
            "You have accepted the proposal from ${proposal.value!.providerName}",
        type: ContentType.success,
      );

    }
  }

  void rejectProposal() {
    if (proposal.value != null) {
      final updatedProposal = ProposalDetailModel(
        id: proposal.value!.id,
        requirementId: proposal.value!.requirementId,
        requirementTitle: proposal.value!.requirementTitle,
        providerId: proposal.value!.providerId,
        providerName: proposal.value!.providerName,
        providerImage: proposal.value!.providerImage,
        providerRating: proposal.value!.providerRating,
        providerCompletedProjects: proposal.value!.providerCompletedProjects,
        providerDescription: proposal.value!.providerDescription,
        price: proposal.value!.price,
        timeline: proposal.value!.timeline,
        description: proposal.value!.description,
        status: 'rejected',
        submittedDate: proposal.value!.submittedDate,
        rejectedDate: DateTime.now(),
        attachments: proposal.value!.attachments,
        messages: proposal.value!.messages,
        termsAndConditions: proposal.value!.termsAndConditions,
        additionalNotes: proposal.value!.additionalNotes,
      );

      proposal.value = updatedProposal;

      CustomSnackBar.show(
        title: "Proposal Rejected",
        message:
        "You have accepted the proposal from ${proposal.value!.providerName}",
        type: ContentType.failure,
      );

    }
  }

  void sendMessage() {
    final message = messageController.text.trim();
    if (message.isEmpty) return;

    final newMessage = MessageModel(
      receiverId: '',
      id: 'm${messages.length + 1}',
      senderId: isProvider.value ? 'provider_id' : 'client_id',
      senderName: isProvider.value
          ? proposal.value?.providerName ?? 'Provider'
          : 'You',
      message: message,
      timestamp: DateTime.now(),
      isRead: false,
    );

    messages.add(newMessage);
    messageController.clear();

    // Scroll to bottom would be handled in the UI
    update();
  }

  void downloadAttachment(String fileName) {
    Get.snackbar(
      'Download Started',
      'Downloading $fileName',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void viewAttachment(String fileName) {
    Get.snackbar(
      'Viewing',
      'Opening $fileName',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void reload() {
    if (proposalId != null) {
      loadProposalDetails(proposalId!);
    }
  }

  bool get showActions {
    return !isProvider.value && proposal.value?.status == 'submitted';
  }
}
