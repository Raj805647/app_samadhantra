// lib/app/modules/service_provider/controllers/service_provider_proposals_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/global_routes/app_routes.dart';

class ServiceProviderProposalsController extends GetxController {
  var proposals = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var selectedStatus = 'All'.obs;
  var searchQuery = ''.obs;

  final List<String> statuses = [
    'All',
    'Pending',
    'Shortlisted',
    'Accepted',
    'Rejected',
    'Withdrawn',
  ];

  @override
  void onInit() {
    super.onInit();
    loadProposals();
  }

  void loadProposals() async {
    isLoading.value = true;
    await Future.delayed(Duration(seconds: 1));

    proposals.value = [
      {
        'id': '1',
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
      },
      {
        'id': '2',
        'requirementTitle': 'Logo Design',
        'requirementId': 'REQ002',
        'proposedAmount': '₹10,000',
        'timeline': '15 days',
        'status': 'Shortlisted',
        'submittedDate': '2024-01-09',
        'lastUpdated': '2024-01-11',
        'clientName': 'XYZ Corp',
        'clientRating': 4.8,
        'messagesCount': 5,
        'canEdit': false,
        'canWithdraw': true,
      },
      {
        'id': '3',
        'requirementTitle': 'Website Redesign',
        'requirementId': 'REQ003',
        'proposedAmount': '₹35,000',
        'timeline': '25 days',
        'status': 'Accepted',
        'submittedDate': '2024-01-08',
        'lastUpdated': '2024-01-12',
        'clientName': 'Startup Co.',
        'clientRating': 4.2,
        'messagesCount': 12,
        'canEdit': false,
        'canWithdraw': false,
      },
    ];

    isLoading.value = false;
  }

  void withdrawProposal(String proposalId) {
    Get.defaultDialog(
      title: 'Withdraw Proposal',
      middleText: 'Are you sure you want to withdraw this proposal?',
      textConfirm: 'Yes, Withdraw',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      onConfirm: () {
        final index = proposals.indexWhere((p) => p['id'] == proposalId);
        if (index != -1) {
          proposals[index]['status'] = 'Withdrawn';
          proposals[index]['canWithdraw'] = false;
          proposals.refresh();
        }
        Get.back();
        Get.snackbar('Success', 'Proposal withdrawn successfully');
      },
    );
  }

  void editProposal(String proposalId) {
    final proposal = proposals.firstWhere((p) => p['id'] == proposalId);
    Get.toNamed('/service-provider/edit-proposal', arguments: proposal);
  }

  void viewProposalDetails(String proposalId) {
    final proposal = proposals.firstWhere((p) => p['id'] == proposalId);
    Get.toNamed(AppRoutes.serviceProviderProposalDetails, arguments: proposal['id']);
  }

  void contactClient(String proposalId) {
    final proposal = proposals.firstWhere((p) => p['id'] == proposalId);
    // For now, redirect to admin contact since direct client contact is not allowed
    Get.toNamed('/service-provider/contact-admin', arguments: {
      'proposalId': proposalId,
      'subject': 'Regarding Proposal: ${proposal['requirementTitle']}'
    });
  }

  List<Map<String, dynamic>> get filteredProposals {
    var filtered = proposals.toList();

    // Status filter
    if (selectedStatus.value != 'All') {
      filtered = filtered.where((p) => p['status'] == selectedStatus.value).toList();
    }

    // Search filter
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((p) =>
      p['requirementTitle'].toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          p['clientName'].toLowerCase().contains(searchQuery.value.toLowerCase())
      ).toList();
    }

    return filtered;
  }
}