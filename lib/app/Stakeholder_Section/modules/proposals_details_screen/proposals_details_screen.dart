import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/proposals_details_screen/proposals_details_screen_controller.dart';
import 'package:samadhantra/app/constant/app_circularprogress_indicator.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'package:samadhantra/app/constant/custom_appbar.dart';
import 'package:samadhantra/app/data/model/stake_proposal_detail_model.dart';

class ProposalDetailScreen extends StatelessWidget {
  ProposalDetailScreen({super.key});

  final ProposalDetailController controller = Get.put(ProposalDetailController());

  @override
  Widget build(BuildContext context) {
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

        final proposal = controller.proposal.value;

        if (proposal == null) {
          return _buildEmptyState();
        }

        return _buildProposalDetails(proposal);
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
            const SizedBox(height: 16),
            Text(
              'Error Loading Proposal',
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
            Icons.description,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Proposal Not Found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'The proposal you are looking for does not exist',
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

  Widget _buildProposalDetails(ProposalDetailModel proposal) {
    return Column(
      children: [
        // Status Banner
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: proposal.statusColor.withOpacity(0.1),
            border: Border(
              bottom: BorderSide(color: proposal.statusColor.withOpacity(0.3)),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: proposal.statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Status: ${proposal.statusText}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: proposal.statusColor,
                    ),
                  ),
                ],
              ),
              Text(
                'Submitted ${proposal.timeAgo}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),

        // Tab Bar
        Container(
          color: Colors.white,
          child: Obx(() => Row(
            children: ['Details', 'Documents'].map((tab) {
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
            switch (controller.selectedTab.value) {
              case 'Details':
                return _buildDetailsTab(proposal);
              case 'Documents':
                return _buildDocumentsTab(proposal);
              default:
                return _buildDetailsTab(proposal);
            }
          }),
        ),

        // Action Buttons (only show for client on submitted proposals)
        Obx(() {
          if (!controller.showActions) return const SizedBox.shrink();

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Colors.grey[200]!),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: controller.rejectProposal,
                    icon: const Icon(Icons.close, size: 18),
                    label: const Text('Reject Proposal'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: controller.acceptProposal,
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('Accept Proposal'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDetailsTab(ProposalDetailModel proposal) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Provider Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.appColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            proposal.providerName.isNotEmpty ? proposal.providerName[0] : '?',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.appColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              proposal.providerName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.star, size: 16, color: Colors.orange),
                                const SizedBox(width: 4),
                                Text(
                                  '${proposal.providerRating} Rating',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Icon(Icons.work, size: 16, color: Colors.blue),
                                const SizedBox(width: 4),
                                Text(
                                  '${proposal.providerCompletedProjects} Projects',
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
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    proposal.providerDescription,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Requirement Info
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.assignment, size: 20, color: Colors.blue[700]),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Requirement: ${proposal.requirementTitle}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue[800],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Proposal submitted for this requirement',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Proposal Details Card
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
                  const Text(
                    'Proposal Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Price & Timeline
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Expanded(
                          child: _buildDetailItem(
                            icon: Icons.currency_rupee,
                            title: 'Proposed Price',
                            value: proposal.price,
                            color: Colors.green,
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 40,
                          color: Colors.grey[300],
                        ),
                        Expanded(
                          child: _buildDetailItem(
                            icon: Icons.schedule,
                            title: 'Delivery Timeline',
                            value: proposal.timeline,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Description
                  const Text(
                    'Proposal Description',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      proposal.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Additional Notes
                  if (proposal.additionalNotes.isNotEmpty) ...[
                    const Text(
                      'Additional Notes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        proposal.additionalNotes,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Terms & Conditions
                  if (proposal.termsAndConditions.isNotEmpty) ...[
                    const Text(
                      'Terms & Conditions',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        proposal.termsAndConditions,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, size: 24, color: color),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  // Widget _buildCommunicationTab(ProposalDetailModel proposal) {
  //   return Column(
  //     children: [
  //       Expanded(
  //         child: Obx(() {
  //           if (controller.messages.isEmpty) {
  //             return Center(
  //               child: Column(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   Icon(
  //                     Icons.chat_bubble_outline,
  //                     size: 80,
  //                     color: Colors.grey[400],
  //                   ),
  //                   const SizedBox(height: 16),
  //                   Text(
  //                     'No Messages Yet',
  //                     style: TextStyle(
  //                       fontSize: 18,
  //                       color: Colors.grey[600],
  //                       fontWeight: FontWeight.w500,
  //                     ),
  //                   ),
  //                   const SizedBox(height: 8),
  //                   Text(
  //                     'Start a conversation about this proposal',
  //                     style: TextStyle(
  //                       fontSize: 14,
  //                       color: Colors.grey[500],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           }
  //
  //           return ListView.builder(
  //             padding: const EdgeInsets.all(16),
  //             reverse: false,
  //             itemCount: controller.messages.length,
  //             itemBuilder: (context, index) {
  //               final message = controller.messages[index];
  //               return _buildMessageBubble(message);
  //             },
  //           );
  //         }),
  //       ),
  //
  //       // Message Input
  //       Container(
  //         padding: const EdgeInsets.all(12),
  //         decoration: BoxDecoration(
  //           color: Colors.white,
  //           border: Border(
  //             top: BorderSide(color: Colors.grey[200]!),
  //           ),
  //         ),
  //         child: Row(
  //           children: [
  //             Expanded(
  //               child: TextField(
  //                 controller: controller.messageController,
  //                 decoration: InputDecoration(
  //                   hintText: 'Type your message...',
  //                   border: OutlineInputBorder(
  //                     borderRadius: BorderRadius.circular(24),
  //                     borderSide: BorderSide(color: Colors.grey[300]!),
  //                   ),
  //                   contentPadding: const EdgeInsets.symmetric(
  //                     horizontal: 16,
  //                     vertical: 12,
  //                   ),
  //                   suffixIcon: IconButton(
  //                     icon: Icon(Icons.attach_file, color: Colors.grey[600]),
  //                     onPressed: () {
  //                       // Handle attachment
  //                     },
  //                   ),
  //                 ),
  //                 maxLines: 3,
  //                 minLines: 1,
  //               ),
  //             ),
  //             const SizedBox(width: 12),
  //             Container(
  //               decoration: BoxDecoration(
  //                 color: AppColors.appColor,
  //                 shape: BoxShape.circle,
  //               ),
  //               child: IconButton(
  //                 icon: const Icon(Icons.send, color: Colors.white),
  //                 onPressed: controller.sendMessage,
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildMessageBubble(MessageModel message) {
    final isMe = message.senderName == 'You';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe)
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.blue[100],
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  message.senderName.isNotEmpty ? message.senderName[0] : '?',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(
                    left: isMe ? 40 : 8,
                    right: isMe ? 0 : 40,
                  ),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isMe ? AppColors.appColor : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isMe)
                        Text(
                          message.senderName,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                      Text(
                        message.message,
                        style: TextStyle(
                          fontSize: 14,
                          color: isMe ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: isMe ? 0 : 48,
                    right: isMe ? 48 : 0,
                    top: 4,
                  ),
                  child: Text(
                    '${message.formattedTime}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[500],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (isMe)
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.appColor.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.person,
                  size: 16,
                  color: AppColors.appColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDocumentsTab(ProposalDetailModel proposal) {
    if (proposal.attachments.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.folder_open,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No Documents',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No documents attached to this proposal',
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
      itemCount: proposal.attachments.length,
      itemBuilder: (context, index) {
        final fileName = proposal.attachments[index];
        return _buildDocumentCard(fileName);
      },
    );
  }

  Widget _buildDocumentCard(String fileName) {
    final extension = fileName.split('.').last.toLowerCase();
    IconData icon;
    Color color;

    switch (extension) {
      case 'pdf':
        icon = Icons.picture_as_pdf;
        color = Colors.red;
        break;
      case 'doc':
      case 'docx':
        icon = Icons.description;
        color = Colors.blue;
        break;
      case 'xls':
      case 'xlsx':
        icon = Icons.table_chart;
        color = Colors.green;
        break;
      case 'zip':
      case 'rar':
        icon = Icons.folder_zip;
        color = Colors.orange;
        break;
      default:
        icon = Icons.insert_drive_file;
        color = Colors.grey;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        title: Text(
          fileName,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          '${_formatFileSize(1024 * 500)} • $extension',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.visibility, color: AppColors.appColor),
              onPressed: () => controller.viewAttachment(fileName),
            ),
            IconButton(
              icon: Icon(Icons.download, color: AppColors.appColor),
              onPressed: () => controller.downloadAttachment(fileName),
            ),
          ],
        ),
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}