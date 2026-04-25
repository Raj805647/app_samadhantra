import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/Service_Provider_Section/modules/service_provider_proposal_details_screen/service_provider_proposal_details_screen_controller.dart';
import 'package:samadhantra/app/constant/app_button.dart';
import 'package:samadhantra/app/constant/app_circularprogress_indicator.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'package:samadhantra/app/constant/custom_appbar.dart';

class ServiceProviderProposalDetailsScreen extends StatelessWidget {
  final ServiceProviderProposalDetailsController controller =
      Get.put(ServiceProviderProposalDetailsController());

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: CustomAppBar(
              title: "Proposal Details",
              isBackButton: true,
            ),
            body: Obx(() {
              if (controller.isLoading.value) {
                return _buildLoadingState();
              }

              if (controller.errorMessage.value.isNotEmpty) {
                return _buildErrorState();
              }

              final Map<String, dynamic> proposal =
              Map<String, dynamic>.from(controller.proposal);

              if (proposal.isEmpty) {
                return _buildEmptyState();
              }

              return _buildProposalDetails(proposal, context);
            }),
          );
        },
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'Loading proposal details...',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.red[400],
            ),
            SizedBox(height: 16),
            Text(
              'Error Loading Proposal',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              controller.errorMessage.value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.reload,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.appColor,
                foregroundColor: Colors.white,
              ),
              child: Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.description,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'Proposal Not Found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'The proposal details could not be loaded.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildProposalDetails(Map<String, dynamic> proposal,BuildContext context) {
    return Column(
      children: [
        // Header Section
        _buildHeaderSection(proposal),

        // Tab Bar
        Container(
          color: Colors.white,
          child: TabBar(
            controller: DefaultTabController.of(context),
            tabs: [
              Tab(text: 'Details'),
              Tab(text: 'Milestones'),
              Tab(text: 'Portfolio'),
            ],
            labelColor: AppColors.appColor,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.appColor,
          ),
        ),

        // Tab Content
        Expanded(
          child: TabBarView(
            children: [
              _buildDetailsTab(proposal),
              _buildMilestonesTab(proposal),
              _buildPortfolioTab(proposal),
            ],
          ),
        ),

        // Action Buttons
        _buildActionButtons(proposal),
      ],
    );
  }

  Widget _buildHeaderSection(Map<String, dynamic> proposal) {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  proposal['requirementTitle'] ?? '',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Chip(
                label: Text(
                  controller.getStatusText(proposal['status']),
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                backgroundColor: controller.getStatusColor(proposal['status']),
              ),
            ],
          ),

          SizedBox(height: 16),

          // Key Details
          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  icon: Icons.currency_rupee,
                  label: 'Proposed Amount',
                  value: proposal['proposedAmount'] ?? '',
                ),
              ),
              Expanded(
                child: _buildDetailItem(
                  icon: Icons.schedule,
                  label: 'Timeline',
                  value: proposal['timeline'] ?? '',
                ),
              ),
            ],
          ),

          SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildDetailItem(
                  icon: Icons.calendar_today,
                  label: 'Submitted',
                  value: proposal['submittedDate'] ?? '',
                ),
              ),
              Expanded(
                child: _buildDetailItem(
                  icon: Icons.update,
                  label: 'Last Updated',
                  value: proposal['lastUpdated'] ?? '',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailsTab(Map<String, dynamic> proposal) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          Text(
            'Proposal Description',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Text(
            proposal['description'] ?? '',
            style: TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Colors.grey[700],
            ),
          ),

          SizedBox(height: 24),

          // Attachments
          if (proposal['attachments'] != null && proposal['attachments'].isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Attachments',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                ...proposal['attachments'].map<Widget>((attachment) {
                  return Card(
                    child: ListTile(
                      leading: Icon(
                        attachment['type'] == 'pdf' ? Icons.picture_as_pdf : Icons.insert_drive_file,
                        color: AppColors.appColor,
                      ),
                      title: Text(attachment['name']),
                      subtitle: Text(attachment['size']),
                      trailing: IconButton(
                        icon: Icon(Icons.download),
                        onPressed: () {
                          // Handle download
                        },
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildMilestonesTab(Map<String, dynamic> proposal) {
    final milestones = proposal['milestones'] as List<dynamic>? ?? [];

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: milestones.length,
      itemBuilder: (context, index) {
        final milestone = milestones[index];
        return Card(
          margin: EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  milestone['title'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.schedule, size: 16, color: Colors.grey[600]),
                    SizedBox(width: 8),
                    Text('${milestone['duration']}'),
                    SizedBox(width: 16),
                    Icon(Icons.currency_rupee, size: 16, color: Colors.grey[600]),
                    SizedBox(width: 8),
                    Text('${milestone['amount']}'),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPortfolioTab(Map<String, dynamic> proposal) {
    final portfolioItems = proposal['portfolioItems'] as List<dynamic>? ?? [];

    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.8,
      ),
      itemCount: portfolioItems.length,
      itemBuilder: (context, index) {
        final item = portfolioItems[index];
        return Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
                    image: DecorationImage(
                      image: NetworkImage(item['image']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['title'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      item['description'],
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(Map<String, dynamic> proposal) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: Column(
        children: [
          // Primary Actions
          if (proposal['canEdit'] == true && proposal['status'] == 'Pending')
            AppButton(title: "Edit Proposal",onPressed: controller.editProposal,icon: Icons.edit,),
            // ElevatedButton.icon(
            //   onPressed: controller.editProposal,
            //   icon: Icon(Icons.edit),
            //   label: Text('Edit Proposal'),
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.blue,
            //     minimumSize: Size(double.infinity, 48),
            //   ),
            // ),

          if (proposal['canWithdraw'] == true && proposal['status'] == 'Pending')
            Padding(
              padding: EdgeInsets.only(top: 12),
              child: OutlinedButton.icon(
                onPressed: controller.withdrawProposal,
                icon: Icon(Icons.cancel, color: Colors.red),
                label: Text('Withdraw Proposal'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: BorderSide(color: Colors.red),
                  minimumSize: Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r), // 👈 curve here
                  ),
                ),
              ),
            ),

          // Contact Admin Button (always available)
          Padding(
            padding: EdgeInsets.only(top: 12),
            child: OutlinedButton.icon(
              onPressed: controller.contactAdmin,
              icon: Icon(Icons.admin_panel_settings),
              label: Text('Contact Admin'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.appColor,
                side: BorderSide(color: AppColors.appColor),
                minimumSize: Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r), // 👈 curve here
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}