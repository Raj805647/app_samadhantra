import 'package:flutter/material.dart';
import 'package:samadhantra/app/Service_Provider_Section/modules/service_provider_proposal_screen/service_provider_proposal_screen_controller.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'package:samadhantra/app/constant/custom_appbar.dart';
import 'package:samadhantra/app/global_routes/app_routes.dart';
import 'package:get/get.dart';

class ServiceProviderProposalsScreen extends StatelessWidget {
  final ServiceProviderProposalsController controller =
  Get.put(ServiceProviderProposalsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: "My Proposals",isBackButton: false ,),
      // AppBar(
      //   title: Text('My Proposals'),
      // ),
      body: Column(
        children: [
          SizedBox(height: 10,),
          // Status Filter
          Container(
            height: 50,
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Obx(() => ListView.builder(
              key: ValueKey(controller.selectedStatus.value),
              scrollDirection: Axis.horizontal,
              itemCount: controller.statuses.length,
              itemBuilder: (context, index) {
                final status = controller.statuses[index];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(status),
                    selected: controller.selectedStatus.value == status,
                    onSelected: (selected) {
                      controller.selectedStatus.value = status;
                    },
                  ),
                );
              },
            )),
          ),

          SizedBox(height: 8),

          // Proposals List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              final filteredProposals = controller.filteredProposals;

              if (filteredProposals.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.description, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No proposals found',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: filteredProposals.length,
                itemBuilder: (context, index) {
                  final proposal = filteredProposals[index];
                  return _buildProposalCard(proposal);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildProposalCard(Map<String, dynamic> proposal) {
    Color statusColor = _getStatusColor(proposal['status']);

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    proposal['requirementTitle'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Chip(
                  label: Text(
                    proposal['status'],
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: statusColor,
                ),
              ],
            ),

            SizedBox(height: 12),

            Row(
              children: [
                _buildProposalDetail(
                  icon: Icons.currency_rupee,
                  text: proposal['proposedAmount'],
                ),
                SizedBox(width: 16),
                _buildProposalDetail(
                  icon: Icons.date_range,
                  text: proposal['submittedDate'],
                ),
              ],
            ),

            SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.toNamed(
                      AppRoutes.serviceProviderProposalDetails,
                      arguments: proposal['id'],
                    ),
                    child: Text('View Details'),
                  ),
                ),

                SizedBox(width: 12),

                if (proposal['status'] == 'Pending')
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.toNamed(
                        '/service-provider/edit-proposal',
                        arguments: proposal['id'],
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                      ),
                      child: Text('Edit'),
                    ),
                  ),
              ],
            ),

            if (proposal['status'] == 'Pending')
              SizedBox(height: 12),

            if (proposal['status'] == 'Pending')
              Center(
                child: TextButton(
                  onPressed: () => controller.withdrawProposal(proposal['id']),
                  child: Text(
                    'Withdraw Proposal',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProposalDetail({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        SizedBox(width: 4),
        Text(text),
      ],
    );
  }

  Color _getStatusColor(String status) {
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
}