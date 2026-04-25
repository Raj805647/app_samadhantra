// lib/app/modules/service_provider/views/service_provider_deliverables_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/Service_Provider_Section/modules/service_provider_deliverables_screen/service_provider_deliverables_screen_controller.dart';

class ServiceProviderDeliverablesScreen extends StatelessWidget {
  final ServiceProviderDeliverablesController controller = Get.put(ServiceProviderDeliverablesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deliverables Management'),
        actions: [
          IconButton(
            icon: Icon(Icons.upload),
            onPressed: () => _uploadDeliverable(),
            tooltip: 'Upload Deliverable',
          ),
        ],
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

              // Uploading Files
              if (controller.uploadingFiles.isNotEmpty) _buildUploadingFiles(),

              // Deliverables List
              _buildDeliverablesList(),
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
            Row(
              children: [
                Icon(Icons.assignment, color: Colors.blue),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    controller.assignment['title'] ?? 'Assignment',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                _buildInfoItem(
                  icon: Icons.person,
                  label: 'Client',
                  value: controller.assignment['client'] ?? '',
                ),
                SizedBox(width: 16),
                _buildInfoItem(
                  icon: Icons.calendar_today,
                  label: 'Deadline',
                  value: controller.assignment['deadline'] ?? '',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
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
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            Text(value, style: TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
      ],
    );
  }

  Widget _buildUploadingFiles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Uploading Files',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        ...controller.uploadingFiles.map((file) {
          return Card(
            child: ListTile(
              leading: Icon(Icons.upload),
              title: Text(file['name']),
              subtitle: LinearProgressIndicator(
                value: file['progress'] / 100,
                backgroundColor: Colors.grey[200],
              ),
              trailing: file['status'] == 'completed'
                  ? Icon(Icons.check_circle, color: Colors.green)
                  : file['status'] == 'failed'
                  ? Icon(Icons.error, color: Colors.red)
                  : null,
            ),
          );
        }).toList(),
        SizedBox(height: 24),
      ],
    );
  }

  Widget _buildDeliverablesList() {
    if (controller.deliverables.isEmpty) {
      return Center(
        child: Column(
          children: [
            Icon(Icons.folder_open, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No deliverables uploaded',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Upload files, documents, or deliverables for this assignment',
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => _uploadDeliverable(),
              icon: Icon(Icons.upload),
              label: Text('Upload First Deliverable'),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Deliverables (${controller.deliverables.length})',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        ...controller.deliverables.map((deliverable) {
          return _buildDeliverableCard(deliverable);
        }).toList(),
      ],
    );
  }

  Widget _buildDeliverableCard(Map<String, dynamic> deliverable) {
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
                    deliverable['name'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                PopupMenuButton(
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text('Add Files'),
                      value: 'add',
                    ),
                    PopupMenuItem(
                      child: Text('Edit'),
                      value: 'edit',
                    ),
                    PopupMenuItem(
                      child: Text('Update Version'),
                      value: 'version',
                    ),
                    PopupMenuItem(
                      child: Text('Notify Client'),
                      value: 'notify',
                    ),
                    PopupMenuItem(
                      child: Text('Delete', style: TextStyle(color: Colors.red)),
                      value: 'delete',
                    ),
                  ],
                  onSelected: (value) {
                    switch (value) {
                      case 'add':
                        _addFilesToDeliverable(deliverable['id']);
                        break;
                      case 'edit':
                        _editDeliverable(deliverable);
                        break;
                      case 'version':
                        _updateVersion(deliverable['id']);
                        break;
                      case 'notify':
                        controller.notifyClientAboutDeliverable(deliverable['id']);
                        break;
                      case 'delete':
                        controller.deleteDeliverable(deliverable['id']);
                        break;
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 8),
            Chip(
              label: Text(deliverable['type'] ?? 'Document'),
              backgroundColor: _getDeliverableTypeColor(deliverable['type']),
            ),
            SizedBox(height: 12),
            Text(
              'Version: ${deliverable['version']}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            Text(
              'Uploaded: ${deliverable['uploadDate']}',
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 12),
            if (deliverable['notes'] != null && deliverable['notes'].isNotEmpty)
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(deliverable['notes']),
              ),
            SizedBox(height: 12),
            Text(
              'Files (${deliverable['files']?.length ?? 0}):',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ..._buildFileList(deliverable['files'] ?? [], deliverable['id']),
            SizedBox(height: 12),
            if (deliverable['clientFeedback'] != null && deliverable['clientFeedback'].isNotEmpty)
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Client Feedback:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(deliverable['clientFeedback']),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildFileList(List<dynamic> files, String deliverableId) {
    if (files.isEmpty) {
      return [
        Text(
          'No files uploaded',
          style: TextStyle(color: Colors.grey[600]),
        ),
      ];
    }

    return files.asMap().entries.map((entry) {
      final index = entry.key;
      final file = entry.value;

      return ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Icon(
          _getFileIcon(file['name']),
          color: Colors.blue,
        ),
        title: Text(file['name']),
        subtitle: Text('${file['size']} • ${file['uploadDate']}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.download, size: 20),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(Icons.delete, size: 20, color: Colors.red),
              onPressed: () {
                Get.defaultDialog(
                  title: 'Delete File',
                  middleText: 'Are you sure you want to delete this file?',
                  textConfirm: 'Delete',
                  textCancel: 'Cancel',
                  onConfirm: () {
                    controller.removeFileFromDeliverable(deliverableId, index);
                    Get.back();
                  },
                );
              },
            ),
          ],
        ),
      );
    }).toList();
  }

  IconData _getFileIcon(String fileName) {
    final ext = fileName.toLowerCase().split('.').last;
    switch (ext) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        return Icons.image;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'xls':
      case 'xlsx':
        return Icons.table_chart;
      case 'zip':
      case 'rar':
        return Icons.folder_zip;
      default:
        return Icons.insert_drive_file;
    }
  }

  Color _getDeliverableTypeColor(String? type) {
    switch (type?.toLowerCase()) {
      case 'design':
        return Colors.purple[100]!;
      case 'document':
        return Colors.blue[100]!;
      case 'code':
        return Colors.green[100]!;
      case 'report':
        return Colors.orange[100]!;
      default:
        return Colors.grey[100]!;
    }
  }

  void _uploadDeliverable() {
    String name = '';
    String type = 'Document';
    String notes = '';

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
                'Upload Deliverable',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Deliverable Name *',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => name = value,
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: type,
                decoration: InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(),
                ),
                items: ['Document', 'Design', 'Code', 'Report', 'Other'].map((t) {
                  return DropdownMenuItem(
                    value: t,
                    child: Text(t),
                  );
                }).toList(),
                onChanged: (value) => type = value!,
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Notes (Optional)',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onChanged: (value) => notes = value,
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => _selectFiles(),
                icon: Icon(Icons.attach_file),
                label: Text('Select Files'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (name.isNotEmpty) {
                    // Simulate file upload
                    controller.simulateFileUpload('sample_file.pdf');
                    Get.back();
                  }
                },
                child: Text('Upload Deliverable'),
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

  void _selectFiles() {
    Get.snackbar('Info', 'File selection coming soon');
  }

  void _addFilesToDeliverable(String deliverableId) {
    Get.snackbar('Info', 'Add files functionality coming soon');
  }

  void _editDeliverable(Map<String, dynamic> deliverable) {
    Get.snackbar('Info', 'Edit functionality coming soon');
  }

  void _updateVersion(String deliverableId) {
    String newVersion = '';

    Get.dialog(
      AlertDialog(
        title: Text('Update Version'),
        content: TextField(
          decoration: InputDecoration(
            labelText: 'New Version Number',
            hintText: 'e.g., 2.0, v1.1',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => newVersion = value,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (newVersion.isNotEmpty) {
                controller.updateDeliverableVersion(deliverableId, newVersion);
                Get.back();
              }
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }
}