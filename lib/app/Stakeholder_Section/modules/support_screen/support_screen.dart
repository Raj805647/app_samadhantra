import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/support_screen/support_screen_controller.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'package:samadhantra/app/constant/custom_appbar.dart';
import 'package:samadhantra/app/data/model/stake_support_ticket_model.dart';
import 'package:samadhantra/app/global_routes/app_routes.dart';

class SupportScreen extends StatelessWidget {
  final SupportController controller = Get.put(SupportController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: "Support Tickets",
        isBackButton: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // Quick Actions
            Container(
              padding: EdgeInsets.all(16),
              color: Colors.grey[50],
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Get.toNamed(AppRoutes.newTicketScreen),
                      icon: Icon(Icons.add, size: 20, color: Colors.white),
                      label: Text('New Ticket', style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.appColor,
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _showFaq,
                      icon: Icon(Icons.help_outline, size: 20),
                      label: Text('FAQ'),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.appColor),
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Tabs
            DefaultTabController(
              length: 2,
              child: Expanded(
                child: Column(
                  children: [
                    Container(
                      color: Colors.white,
                      child: TabBar(
                        labelColor: AppColors.appColor,
                        unselectedLabelColor: Colors.grey,
                        indicatorColor: AppColors.appColor,
                        tabs: [
                          Tab(text: 'Open (${controller.openTickets.length})'),
                          Tab(text: 'Resolved (${controller.resolvedTickets.length})'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildTicketsList(controller.openTickets),
                          _buildTicketsList(controller.resolvedTickets),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildTicketsList(List<SupportTicket> tickets) {
    if (tickets.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.support_agent,
              size: 80,
              color: Colors.grey[300],
            ),
            SizedBox(height: 20),
            Text(
              'No tickets found',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Create a new ticket for assistance',
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
      padding: EdgeInsets.all(16),
      itemCount: tickets.length,
      itemBuilder: (context, index) {
        final ticket = tickets[index];
        return _buildTicketCard(ticket);
      },
    );
  }

  Widget _buildTicketCard(SupportTicket ticket) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _showTicketDetailsDialog(ticket),
        borderRadius: BorderRadius.circular(12),
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
                      ticket.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getPriorityColor(ticket.priority).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      ticket.priority.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        color: _getPriorityColor(ticket.priority),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),

              Text(
                ticket.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 12),

              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(ticket.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      ticket.status.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        color: _getStatusColor(ticket.status),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      ticket.category.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(
                    ticket.formattedCreatedAt,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),

              if (ticket.assignedTo != null) ...[
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.person, size: 14, color: Colors.grey[600]),
                    SizedBox(width: 4),
                    Text(
                      'Assigned to: ${ticket.assignedTo}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],

              SizedBox(height: 8),
              Divider(),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.message, size: 14, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Text(
                    '${ticket.messages.length} messages',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () => _showTicketDetailsDialog(ticket),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.appColor,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    ),
                    child: Text('View Ticket', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTicketDetailsDialog(SupportTicket ticket) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.appColor.withOpacity(0.05),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Ticket Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.appColor,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.close, color: Colors.grey[600]),
                      splashRadius: 20,
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Ticket Title
                    Text(
                      ticket.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),

                    // Description
                    Text(
                      ticket.description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 16),

                    // Ticket Info Grid
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      childAspectRatio: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      children: [
                        _buildInfoItem(
                          label: 'Status',
                          value: ticket.status.toUpperCase(),
                          valueColor: _getStatusColor(ticket.status),
                        ),
                        _buildInfoItem(
                          label: 'Priority',
                          value: ticket.priority.toUpperCase(),
                          valueColor: _getPriorityColor(ticket.priority),
                        ),
                        _buildInfoItem(
                          label: 'Category',
                          value: ticket.category.toUpperCase(),
                          valueColor: AppColors.appColor,
                        ),
                        _buildInfoItem(
                          label: 'Created',
                          value: _formatDateTime(ticket.createdAt),
                          valueColor: Colors.grey[600]!,
                        ),
                        if (ticket.updatedAt != null)
                          _buildInfoItem(
                            label: 'Last Updated',
                            value: _formatDateTime(ticket.updatedAt!),
                            valueColor: Colors.grey[600]!,
                          ),
                        _buildInfoItem(
                          label: 'Messages',
                          value: '${ticket.messages.length}',
                          valueColor: Colors.grey[600]!,
                        ),
                      ],
                    ),

                    if (ticket.assignedTo != null) ...[
                      SizedBox(height: 16),
                      Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.person, size: 16, color: Colors.blue),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Assigned to: ${ticket.assignedTo}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue[800],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Messages Preview
                    if (ticket.messages.isNotEmpty) ...[
                      SizedBox(height: 16),
                      Text(
                        'Recent Messages',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 8),
                      ...ticket.messages.take(3).map((message) => _buildMessagePreview(message)).toList(),
                      if (ticket.messages.length > 3)
                        Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: TextButton(
                            onPressed: () => Get.toNamed('/support/ticket/${ticket.id}'),
                            child: Text('View all ${ticket.messages.length} messages'),
                          ),
                        ),
                    ],

                    SizedBox(height: 16),

                    // Action Buttons
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => Get.toNamed('/support/ticket/${ticket.id}'),
                            icon: Icon(Icons.chat, size: 18),
                            label: Text('Open Full Chat'),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              side: BorderSide(color: AppColors.appColor),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Get.back();
                              _showReplyDialog(ticket);
                            },
                            icon: Icon(Icons.reply, size: 18, color: Colors.white),
                            label: Text('Reply', style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.appColor,
                              padding: EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  Widget _buildInfoItem({required String label, required String value, required Color? valueColor}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        // border: Border.all(color: Colors.grey[200]),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: valueColor ?? Colors.grey[600]!,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildMessagePreview(TicketMessage message) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: message.senderType == 'user' ? AppColors.appColor.withOpacity(0.1) : Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: message.senderType == 'user' ? AppColors.appColor : Colors.grey,
                child: Text(
                  message.senderName[0],
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 8),
              Text(
                message.senderName,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: message.senderType == 'user' ? AppColors.appColor : Colors.grey[700],
                ),
              ),
              Spacer(),
              Text(
                _formatTime(message.timestamp),
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
          SizedBox(height: 6),
          Text(
            message.message,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  void _showReplyDialog(SupportTicket ticket) {
    final TextEditingController replyController = TextEditingController();

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.appColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.reply, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Reply to Ticket',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.close, color: Colors.white),
                      splashRadius: 20,
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ticket: ${ticket.title}',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Your message will be sent to the support team',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 16),

                    TextField(
                      controller: replyController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: 'Type your message here...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(color: AppColors.appColor),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Get.back(),
                            child: Text('Cancel'),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              // side: BorderSide(color: Colors.grey[400]),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              if (replyController.text.trim().isNotEmpty) {
                                controller.sendMessage(ticket.id, replyController.text.trim());
                                Get.back();
                                Get.snackbar(
                                  'Message Sent',
                                  'Your reply has been sent to support team',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.appColor,
                              padding: EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Text('Send Reply',style: TextStyle(color: AppColors.white),),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'low':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'high':
        return Colors.red;
      case 'urgent':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return Colors.blue;
      case 'in-progress':
        return Colors.orange;
      case 'resolved':
        return Colors.green;
      case 'closed':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  void _showFaq() {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Frequently Asked Questions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildFaqItem(
                    question: 'How do I get assigned a service provider?',
                    answer: 'After you submit a requirement, our admin team reviews it and assigns the most suitable provider within 24-48 hours.',
                  ),
                  _buildFaqItem(
                    question: 'How are payments processed?',
                    answer: 'Payments are securely processed through our platform. You\'ll receive invoices and can make payments online.',
                  ),
                  _buildFaqItem(
                    question: 'Can I communicate directly with the provider?',
                    answer: 'All communication happens through Samadhantra Admin to ensure quality control and dispute resolution.',
                  ),
                  _buildFaqItem(
                    question: 'What happens if I\'m not satisfied with the work?',
                    answer: 'Contact Samadhantra Admin immediately. We have a quality assurance process and will work to resolve any issues.',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem({required String question, required String answer}) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.help, color: AppColors.appColor, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    question,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              answer,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}