import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/requirement_details_screen/requirement_details_screen_controller.dart';
import 'package:samadhantra/app/constant/app_circularprogress_indicator.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'package:samadhantra/app/constant/custom_appbar.dart';


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/constant/token_storage_service.dart';

import '../../../constant/custom_snackbar.dart';
import '../../../constant/custom_textformfield.dart';

class RequirementDetailsScreen extends StatelessWidget {
  RequirementDetailsScreen({super.key});

  final controller = Get.put(RequirementDetailsScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: "Requirement Details",
        isBackButton: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CustomProgressIndicator());
        }

        final requirement = controller.requirementDetails.value;

        if (requirement == null) {
          return const Center(child: Text("No Data Found"));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderCard(requirement),
              const SizedBox(height: 20),

              _buildSectionTitle("Problem Description"),
              _buildDescriptionCard(requirement.problemDescription),
              const SizedBox(height: 20),

              _buildSectionTitle("Expected Outcome"),
              _buildDescriptionCard(requirement.expectedOutcome),
              const SizedBox(height: 20),

              _buildDetailsCard(requirement),
              const SizedBox(height: 30),

              if (requirement.userId != controller.userId.value)
                _buildBidForm(),
            ],
          ),
        );
      }),
    );
  }

  // ================= HEADER =================

  Widget _buildHeaderCard(dynamic requirement) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Text(
                requirement.requirementCategory ?? '',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            _buildStatusChip(requirement.status),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String? status) {
    final isActive = status == "active";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive
            ? Colors.green.withOpacity(0.1)
            : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status?.toUpperCase() ?? '',
        style: TextStyle(
          color: isActive ? Colors.green : Colors.grey,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ================= SECTION TITLE =================

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  // ================= DESCRIPTION CARD =================

  Widget _buildDescriptionCard(String? text) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          text ?? '',
          style: const TextStyle(height: 1.5),
        ),
      ),
    );
  }

  // ================= DETAILS CARD =================

  Widget _buildDetailsCard(dynamic requirement) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildDetailRow(Icons.schedule, "Timeline",
                requirement.timeline ?? ''),
            const Divider(),
            _buildDetailRow(Icons.attach_money, "Budget",
                "₹ ${requirement.budgetRange ?? ''}"),
            const Divider(),
            _buildDetailRow(Icons.location_on, "Location",
                requirement.preferredLocation ?? ''),
            const Divider(),
            _buildDetailRow(Icons.work_outline, "Engagement",
                requirement.engagementTypes?.join(", ") ?? ''),
            const Divider(),
            _buildDetailRow(Icons.calendar_today, "Created At",
                requirement.createdAt?.toString().substring(0, 10) ?? ''),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.blueGrey),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      fontSize: 12, color: Colors.grey[600])),
              const SizedBox(height: 4),
              Text(value,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }

  // ================= BID FORM =================

  Widget _buildBidForm() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Submit Your Bid",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              controller:controller.amountController,
              labelText: "Bid Amount",
              hintText : "Enter your amount",
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),

            CustomTextFormField(
             controller: controller.timelineController,
              labelText:"Delivery Timeline",
              hintText:"Enter timeline (e.g. 7 days)",
            ),
            const SizedBox(height: 12),

            CustomTextFormField(
             controller:  controller.proposalController,
             labelText:  "Proposal",
             hintText:  "Describe your proposal",
              maxLines: 3,
            ),
            const SizedBox(height: 12),

            CustomTextFormField(
              controller:controller.experienceController,
             labelText: "Experience",
              hintText:"Your relevant experience",
              maxLines: 2,
            ),
            const SizedBox(height: 20),

            Obx(()=>controller.isSubmit.value
                ? Center(child: CircularProgressIndicator())
                :  SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (){
                    if(controller.amountController.text.isNotEmpty &&
                    controller.timelineController.text.isNotEmpty &&
                    controller.proposalController.text.isNotEmpty &&
                    controller.experienceController.text.isNotEmpty) {
                      controller.submitBid();
                    }else{
                      CustomSnackBar.warning('please fill the all Details');
                    }
                  },
                  child: const Text("Submit Bid"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}/*
class RequirementDetailScreen extends StatelessWidget {
  RequirementDetailScreen({super.key});

  final  controller = Get.put(RequirementDetailsScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: "Requirement Details",
        isBackButton: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildLoadingState();
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return _buildErrorState();
        }

        final requirement = controller.requirementDetails.value;

        if (requirement == null) {
          return _buildEmptyState();
        }

        // return Center(child: Text("Coming Soon"),);
         return _buildRequirementDetails(requirement);
      }),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            'Loading requirement details...',
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
            const SizedBox(height: 16),
            Text(
              'Error Loading Requirement',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.red[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.errorMessage.value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.reload,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.appColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Try Again'),
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
            Icons.assignment,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Requirement Not Found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'The requirement you are looking for does not exist',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.appColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementDetails(requirement) {
    return Column(
      children: [
        // Tab Bar
        Container(
          color: Colors.white,
          child: Obx(() => Row(
            children: ['Details', 'Proposals'].map((tab) {
              final isSelected = controller.selectedTab.value == tab;
              return Expanded(
                child: InkWell(
                  onTap: () => controller.changeTab(tab),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isSelected ? AppColors.appColor : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        tab,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: isSelected ? AppColors.appColor : Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          )),
        ),

        // Tab Content
        Expanded(
          child: Obx(() {
            if (controller.selectedTab.value == 'Details') {
              return _buildDetailsTab(requirement);
            } else {
              return _buildProposalsTab();
            }
          }),
        ),
      ],
    );
  }

  Widget _buildDetailsTab(requirement) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Requirement Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          requirement.requirementCategory,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.appColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.appColor),
                        ),
                        child: Text(
                          requirement.timeline,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.appColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Category & Date
                      // Icon(Icons.category, size: 16, color: Colors.grey[600]),
                      // const SizedBox(width: 8),
                      // Text(
                      //   requirement.requirementCategory,
                      //   style: TextStyle(
                      //     color: Colors.grey[600],
                      //     fontSize: 14,
                      //   ),
                      // ),
                      // const Spacer(),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                          const SizedBox(width: 8),
                          Text(
                            DateFormat("dd-MM-yyyy")
                                .format(DateTime.parse(requirement.createdAt)),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),


                  const SizedBox(height: 20),

                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    requirement.problemDescription,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Details Grid
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildDetailRow(
                          icon: Icons.attach_money,
                          label: 'Budget',
                          value: requirement.budgetRange,
                          color: Colors.green,
                        ),
                        const SizedBox(height: 12),
                        if (requirement.timeline != null)
                          Column(
                            children: [
                              _buildDetailRow(
                                icon: Icons.schedule,
                                label: 'Deadline',
                                value: requirement.timeline ?? '',
                                color: Colors.orange,
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        if (requirement.preferredLocation != null)
                          Column(
                            children: [
                              _buildDetailRow(
                                icon: Icons.location_on,
                                label: 'Location',
                                value: requirement.preferredLocation!,
                                color: Colors.blue,
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        // _buildDetailRow(
                        //   icon: Icons.group,
                        //   label: 'Proposals',
                        //   value: '${requirement.proposalsCount} received',
                        //   color: AppColors.appColor,
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Attachments
          // if (requirement.attachments.isNotEmpty) ...[
          //   const Text(
          //     'Attachments',
          //     style: TextStyle(
          //       fontSize: 18,
          //       fontWeight: FontWeight.w600,
          //       color: Colors.black,
          //     ),
          //   ),
          //   const SizedBox(height: 12),
          //   ...requirement.attachments.map((file) => _buildAttachmentCard(file)).toList(),
          // ],
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAttachmentCard(String fileName) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.appColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.insert_drive_file,
            color: AppColors.appColor,
          ),
        ),
        title: Text(
          fileName,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        trailing: IconButton(
          icon: Icon(Icons.download, color: AppColors.appColor),
          onPressed: () {
            Get.snackbar(
              'Download',
              'Downloading $fileName',
              snackPosition: SnackPosition.BOTTOM,
            );
          },
        ),
      ),
    );
  }

  Widget _buildProposalsTab() {
    return Obx(() {
      if (controller.proposals.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.assignment_turned_in,
                size: 80,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No Proposals Yet',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Service providers will submit proposals here',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: controller.proposals.length,
        itemBuilder: (context, index) {
          final proposal = controller.proposals[index];
          return _buildProposalCard(proposal);
        },
      );
    });
  }

  Widget _buildProposalCard(proposal) {
    return GestureDetector(
      onTap: (){
        Get.toNamed(
          '/proposalDetails',
          arguments: {
            'proposalId': proposal.id,
            'requirementId': controller.requirement.value?.id,
            'isProvider': false, // Set to true if viewing as provider
          },
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Provider Info
              Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.appColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: Text(
                        proposal.providerName.isNotEmpty ? proposal.providerName[0] : '?',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.appColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          proposal.providerName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.star, size: 14, color: Colors.orange),
                            const SizedBox(width: 4),
                            Text(
                              proposal.providerRating,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.appColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.appColor),
                    ),
                    child: Text(
                      "proposal.statusText",
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.appColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Proposal Details
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildProposalDetail(
                            icon: Icons.attach_money,
                            label: 'Price',
                            value: proposal.price,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildProposalDetail(
                            icon: Icons.schedule,
                            label: 'Timeline',
                            value: proposal.timeline,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      proposal.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Actions
              if (proposal.status == 'submitted')
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => controller.rejectProposal(proposal.id),
                        icon: const Icon(Icons.close, size: 18),
                        label: const Text('Reject'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red,
                          side: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => controller.acceptProposal(proposal.id),
                        icon: const Icon(Icons.check, size: 18),
                        label: const Text('Accept'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProposalDetail({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}*/
