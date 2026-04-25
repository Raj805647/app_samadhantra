import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServiceProviderProposalDetailsController extends GetxController {
  var isLoading = true.obs;
  RxMap<dynamic, dynamic> proposal = {}.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null) {
      loadProposalDetails(args);
    } else {
      errorMessage.value = 'No proposal ID provided';
      isLoading.value = false;
    }
  }

  void loadProposalDetails(dynamic proposalId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock data - replace with actual API call
      proposal.value = {
        'id': proposalId,
        'requirementTitle': 'Mobile App Development',
        'requirementId': 'REQ001',
        'proposedAmount': '₹50,000',
        'timeline': '30 days',
        'status': 'Pending',
        'submittedDate': '2024-01-10',
        'lastUpdated': '2024-01-10',
        'clientName': 'ABC Enterprises',
        'clientRating': 4.5,
        'messagesCount': 3,
        'canEdit': true,
        'canWithdraw': true,
        'description': 'We propose to develop your mobile app with the following features:\n\n'
            '1. User authentication with OTP verification\n'
            '2. Product catalog with advanced search and filters\n'
            '3. Shopping cart with real-time updates\n'
            '4. Secure payment gateway integration (Razorpay, Stripe)\n'
            '5. Real-time order tracking\n'
            '6. Push notifications using Firebase\n'
            '7. Admin dashboard for content management\n\n'
            'We will follow Agile methodology with weekly sprints and provide regular demos.',
        'milestones': [
          {'title': 'UI/UX Design', 'duration': '5 days', 'amount': '₹10,000'},
          {'title': 'Frontend Development', 'duration': '15 days', 'amount': '₹25,000'},
          {'title': 'Backend Development', 'duration': '10 days', 'amount': '₹15,000'},
        ],
        'attachments': [
          {'name': 'portfolio.pdf', 'size': '2.5 MB', 'type': 'pdf'},
          {'name': 'wireframes.fig', 'size': '1.8 MB', 'type': 'fig'},
        ],
        'portfolioItems': [
          {'title': 'E-commerce App', 'image': 'https://via.placeholder.com/150', 'description': 'Complete e-commerce solution'},
          {'title': 'Food Delivery App', 'image': 'https://via.placeholder.com/150', 'description': 'Food ordering platform'},
        ],
      };

    } catch (e) {
      errorMessage.value = 'Failed to load proposal details';
    } finally {
      isLoading.value = false;
    }
  }

  void reload() {
    final args = Get.arguments;
    if (args != null) {
      loadProposalDetails(args);
    }
  }

  void editProposal() {
    Get.toNamed('/service-provider/edit-proposal', arguments: proposal['id']);
  }

  void withdrawProposal() {
    Get.defaultDialog(
      title: 'Withdraw Proposal',
      middleText: 'Are you sure you want to withdraw this proposal?',
      textConfirm: 'Yes, Withdraw',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      onConfirm: () {
        // Update proposal status
        proposal['status'] = 'Withdrawn';
        proposal['canWithdraw'] = false;
        proposal['canEdit'] = false;
        proposal.refresh();

        Get.back();
        Get.snackbar('Success', 'Proposal withdrawn successfully');
      },
    );
  }

  void contactAdmin() {
    Get.toNamed('/service-provider/new-message', arguments: {
      'proposalId': proposal['id'],
      'subject': 'Regarding Proposal: ${proposal['requirementTitle']}'
    });
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'shortlisted':
        return Colors.blue;
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'withdrawn':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Under Admin Review';
      case 'shortlisted':
        return 'Shortlisted by Admin';
      case 'accepted':
        return 'Accepted';
      case 'rejected':
        return 'Rejected';
      case 'withdrawn':
        return 'Withdrawn';
      default:
        return status;
    }
  }
}