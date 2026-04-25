import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/Service_Provider_Section/modules/service_provider_assignment_screen/service_provider_assignment_screen_controller.dart';
import 'package:samadhantra/app/constant/app_button.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'package:samadhantra/app/constant/custom_appbar.dart';

class ServiceProviderAssignmentsScreen extends StatelessWidget {
  final ServiceProviderAssignmentsController controller =
  Get.put(ServiceProviderAssignmentsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: "My Assignments",isBackButton: false,actions: [
        IconButton(
          icon: Icon(Icons.filter_list,color: AppColors.white,),
          onPressed: () => _showFilterDialog(),
        ),
      ],),

      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        final filteredAssignments = controller.filteredAssignments;

        if (filteredAssignments.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.assignment, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No assignments found',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: filteredAssignments.length,
          itemBuilder: (context, index) {
            final assignment = filteredAssignments[index];
            return _buildAssignmentCard(assignment);
          },
        );
      }),
    );
  }

  Widget _buildAssignmentCard(Map<String, dynamic> assignment) {
    Color statusColor = _getStatusColor(assignment['status']);

    return Card(
      color: AppColors.white,
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Assignment Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    assignment['title'],
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Chip(
                  label: Text(
                    assignment['status'],
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: statusColor,
                ),
              ],
            ),

            SizedBox(height: 12),

            // Client Info
            Row(
              children: [
                Icon(Icons.person, size: 16, color: Colors.grey[600]),
                SizedBox(width: 8),
                Text('Client: ${assignment['client']}'),
              ],
            ),

            SizedBox(height: 8),

            // Budget & Deadline
            Row(
              children: [
                _buildAssignmentDetail(
                  icon: Icons.currency_rupee,
                  text: assignment['budget'],
                ),
                SizedBox(width: 16),
                _buildAssignmentDetail(
                  icon: Icons.calendar_today,
                  text: assignment['deadline'],
                ),
              ],
            ),

            SizedBox(height: 12),

            // Progress Bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Progress'),
                    Text('${assignment['progress']}%'),
                  ],
                ),
                SizedBox(height: 4),
                LinearProgressIndicator(
                  value: assignment['progress'] / 100,
                  backgroundColor: Colors.grey[200],
                  color: Colors.blue,
                ),
              ],
            ),

            SizedBox(height: 12),

            // Current Milestone
            Row(
              children: [
                Icon(Icons.flag, size: 16, color: Colors.grey[600]),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Current: ${assignment['milestone']}',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            // Action Buttons
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ActionChip(
                  avatar: Icon(Icons.update, size: 16),
                  label: Text('Update Milestone'),
                  onPressed: () => controller.updateMilestone(assignment['id']),
                ),
                ActionChip(
                  avatar: Icon(Icons.upload, size: 16),
                  label: Text('Upload Deliverables'),
                  onPressed: () => controller.uploadDeliverables(assignment['id']),
                ),
                ActionChip(
                  avatar: Icon(Icons.payment, size: 16),
                  label: Text('Request Payment'),
                  onPressed: () => controller.requestPayment(assignment['id']),
                ),
                ActionChip(
                  avatar: Icon(Icons.message, size: 16),
                  label: Text('Message Client'),
                  onPressed: () => _messageClient(assignment['client']),
                ),
              ],
            ),

            SizedBox(height: 8),

            // View Details Button
            AppButton(title: "View Full Details",onPressed: (){
              Get.toNamed(
                '/service-provider/assignment-details',
                arguments: assignment['id'],
              );
            },),
            // Center(
            //   child: TextButton(
            //     onPressed: () => Get.toNamed(
            //       '/service-provider/assignment-details',
            //       arguments: assignment['id'],
            //     ),
            //     child: Text('View Full Details'),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildAssignmentDetail({required IconData icon, required String text}) {
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
      case 'active':
        return Colors.blue;
      case 'in progress':
        return Colors.orange;
      case 'on hold':
        return Colors.yellow[700]!;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _messageClient(String clientName) {
    Get.toNamed('/service-provider/message-client', arguments: {
      'clientName': clientName,
    });
  }

  void _showFilterDialog() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Filter Assignments',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Obx(() => Column(
              children: controller.statuses.map((status) => RadioListTile(
                title: Text(status),
                value: status,
                groupValue: controller.selectedStatus.value,
                onChanged: (value) {
                  controller.selectedStatus.value = value.toString();
                },
              )).toList(),
            )),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Get.back(),
              child: Text('Apply Filters'),
            ),
          ],
        ),
      ),
    );
  }
}