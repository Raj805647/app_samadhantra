// lib/app/modules/service_provider/views/service_provider_certifications_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/Service_Provider_Section/modules/service_provider_certifications_screen/service_provider_certifications_screen_controller.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'package:samadhantra/app/constant/custom_appbar.dart';

class ServiceProviderCertificationsScreen extends StatelessWidget {
  final ServiceProviderCertificationsController controller = Get.put(ServiceProviderCertificationsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "My Certifications",actions: [
        IconButton(
          icon: Icon(Icons.add,color: AppColors.white,),
          onPressed: () => _addCertification(),
        ),
      ],),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return _buildCertificationsList();
      }),
    );
  }

  Widget _buildCertificationsList() {
    if (controller.certifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.verified_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No certifications added',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'Add your certifications to build credibility',
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _addCertification(),
              child: Text('Add Certification'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: controller.certifications.length,
      itemBuilder: (context, index) {
        final cert = controller.certifications[index];
        return _buildCertificationCard(cert);
      },
    );
  }

  Widget _buildCertificationCard(Map<String, dynamic> cert) {
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
                    cert['name'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    if (cert['verified'] == true)
                      Tooltip(
                        message: 'Verified',
                        child: Icon(Icons.verified, color: Colors.green),
                      )
                    else
                      Tooltip(
                        message: 'Not Verified',
                        child: Icon(Icons.pending, color: Colors.orange),
                      ),
                    SizedBox(width: 8),
                    PopupMenuButton(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          child: Text('View Details'),
                          value: 'view',
                        ),
                        PopupMenuItem(
                          child: Text('Edit'),
                          value: 'edit',
                        ),
                        if (cert['verified'] != true)
                          PopupMenuItem(
                            child: Text('Mark as Verified'),
                            value: 'verify',
                          ),
                        PopupMenuItem(
                          child: Text('Delete', style: TextStyle(color: Colors.red)),
                          value: 'delete',
                        ),
                      ],
                      onSelected: (value) {
                        switch (value) {
                          case 'view':
                            _viewCertificationDetails(cert);
                            break;
                          case 'edit':
                            _editCertification(cert);
                            break;
                          case 'verify':
                            controller.verifyCertification(cert['id']);
                            break;
                          case 'delete':
                            controller.deleteCertification(cert['id']);
                            break;
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.business, size: 16, color: Colors.grey[600]),
                SizedBox(width: 8),
                Text(
                  'Issuer: ${cert['issuer']}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.date_range, size: 16, color: Colors.grey[600]),
                SizedBox(width: 8),
                Text(
                  'Issued: ${cert['issueDate']}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                if (cert['expiryDate'] != null) ...[
                  SizedBox(width: 16),
                  Icon(Icons.event_busy, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 8),
                  Text(
                    'Expires: ${cert['expiryDate']}',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ],
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.confirmation_number, size: 16, color: Colors.grey[600]),
                SizedBox(width: 8),
                Text(
                  'ID: ${cert['certificateId']}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            SizedBox(height: 12),
            if (cert['document'] != null)
              OutlinedButton.icon(
                onPressed: () {
                  // View/download document
                },
                icon: Icon(Icons.download),
                label: Text('View Certificate'),
              ),
          ],
        ),
      ),
    );
  }

  void _addCertification() {
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
                'Add Certification',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Certification Name *',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Issuing Organization *',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Issue Date',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Expiry Date (Optional)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Certificate ID/Number',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  // Upload certificate document
                },
                icon: Icon(Icons.upload),
                label: Text('Upload Certificate'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Add certification
                  Get.back();
                  Get.snackbar('Success', 'Certification added');
                },
                child: Text('Save Certification'),
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

  void _viewCertificationDetails(Map<String, dynamic> cert) {
    Get.dialog(
      AlertDialog(
        title: Text(cert['name']),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.business),
                title: Text('Issuer'),
                subtitle: Text(cert['issuer']),
              ),
              ListTile(
                leading: Icon(Icons.date_range),
                title: Text('Issue Date'),
                subtitle: Text(cert['issueDate']),
              ),
              if (cert['expiryDate'] != null)
                ListTile(
                  leading: Icon(Icons.event_busy),
                  title: Text('Expiry Date'),
                  subtitle: Text(cert['expiryDate']),
                ),
              ListTile(
                leading: Icon(Icons.confirmation_number),
                title: Text('Certificate ID'),
                subtitle: Text(cert['certificateId']),
              ),
              ListTile(
                leading: Icon(Icons.verified),
                title: Text('Status'),
                subtitle: Text(cert['verified'] == true ? 'Verified' : 'Not Verified'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  void _editCertification(Map<String, dynamic> cert) {
    // Implement edit functionality
    Get.snackbar('Info', 'Edit functionality coming soon');
  }
}