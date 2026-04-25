// lib/app/modules/service_provider/views/service_provider_milestone_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/Service_Provider_Section/modules/service_provider_milestone_screen/service_provider_milestone_screen_controller.dart';

class ServiceProviderMilestoneScreen extends StatelessWidget {
  final ServiceProviderMilestoneController controller = Get.put(ServiceProviderMilestoneController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Milestone Management'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Assignment Info
              _buildAssignmentInfo(),
              SizedBox(height: 24),

              // Milestones List
              _buildMilestonesList(),

              SizedBox(height: 32),

              // Add Milestone Button
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => _addMilestone(),
                  icon: Icon(Icons.add),
                  label: Text('Add New Milestone'),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildAssignmentInfo() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              controller.assignment['title'] ?? '',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.person, size: 16, color: Colors.grey[600]),
                SizedBox(width: 8),
                Text('Client: ${controller.assignment['client']}'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.currency_rupee, size: 16, color: Colors.grey[600]),
                SizedBox(width: 8),
                Text('Budget: ₹${controller.assignment['totalBudget']}'),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                SizedBox(width: 8),
                Text('Deadline: ${controller.assignment['deadline']}'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMilestonesList() {
    if (controller.milestones.isEmpty) {
      return Center(
        child: Column(
          children: [
            Icon(Icons.flag, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No milestones added',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Add milestones to track project progress',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Milestones',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        ...controller.milestones.asMap().entries.map((entry) {
          final index = entry.key;
          final milestone = entry.value;
          return _buildMilestoneCard(milestone, index);
        }).toList(),
      ],
    );
  }

  Widget _buildMilestoneCard(Map<String, dynamic> milestone, int index) {
    Color statusColor = _getMilestoneStatusColor(milestone['status']);

    return Card(
      margin: EdgeInsets.only(bottom: 16),
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
                    milestone['title'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Chip(
                  label: Text(
                    milestone['status'],
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  backgroundColor: statusColor,
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              milestone['description'],
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                _buildMilestoneDetail(
                  icon: Icons.calendar_today,
                  text: 'Due: ${milestone['dueDate']}',
                ),
                SizedBox(width: 16),
                _buildMilestoneDetail(
                  icon: Icons.currency_rupee,
                  text: 'Amount: ₹${milestone['amount']}',
                ),
              ],
            ),
            if (milestone['completionDate'] != null) ...[
              SizedBox(height: 8),
              Row(
                children: [
                  _buildMilestoneDetail(
                    icon: Icons.check_circle,
                    text: 'Completed: ${milestone['completionDate']}',
                  ),
                ],
              ),
            ],
            if (milestone['notes'] != null && milestone['notes'].isNotEmpty) ...[
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Notes:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(milestone['notes']),
                  ],
                ),
              ),
            ],
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _viewDeliverables(milestone),
                    icon: Icon(Icons.attach_file),
                    label: Text(
                      'Deliverables (${milestone['deliverables']?.length ?? 0})',
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _updateMilestoneStatus(milestone),
                    child: Text('Update Status'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            if (milestone['status'] == 'Completed')
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => controller.requestMilestonePayment(milestone['id']),
                  icon: Icon(Icons.payment),
                  label: Text('Request Payment'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMilestoneDetail({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 14)),
      ],
    );
  }

  Color _getMilestoneStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'in progress':
        return Colors.blue;
      case 'pending':
        return Colors.orange;
      case 'delayed':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _addMilestone() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add New Milestone',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Milestone Title *',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Amount (₹) *',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Due Date *',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Add milestone
                  Get.back();
                  Get.snackbar('Success', 'Milestone added');
                },
                child: Text('Add Milestone'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateMilestoneStatus(Map<String, dynamic> milestone) {
    String selectedStatus = milestone['status'];

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Update Milestone Status',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: selectedStatus,
              decoration: InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              items: ['Pending', 'In Progress', 'Completed', 'Delayed'].map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (value) => selectedStatus = value!,
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Notes (Optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    child: Text('Cancel'),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      controller.updateMilestoneStatus(milestone['id'], selectedStatus);
                      Get.back();
                    },
                    child: Text('Update'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _viewDeliverables(Map<String, dynamic> milestone) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            Text(
              'Deliverables - ${milestone['title']}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: milestone['deliverables'] == null || milestone['deliverables'].isEmpty
                  ? Center(
                child: Text('No deliverables added'),
              )
                  : ListView.builder(
                itemCount: milestone['deliverables'].length,
                itemBuilder: (context, index) {
                  final deliverable = milestone['deliverables'][index];
                  return Card(
                    child: ListTile(
                      leading: Icon(Icons.attachment),
                      title: Text(deliverable['name'] ?? ''),
                      subtitle: Text(deliverable['size'] ?? ''),
                      trailing: IconButton(
                        icon: Icon(Icons.download),
                        onPressed: () {},
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () => _uploadDeliverable(milestone),
              icon: Icon(Icons.upload),
              label: Text('Upload Deliverable'),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _uploadDeliverable(Map<String, dynamic> milestone) {
    Get.snackbar('Info', 'Upload functionality coming soon');
  }
}