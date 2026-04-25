import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:samadhantra/app/Service_Provider_Section/modules/service_provider_submit_proposal_screen/service_provider_submit_proposal_screen_controller.dart';
import 'package:samadhantra/app/constant/app_button.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'package:samadhantra/app/constant/custom_appbar.dart';

class ServiceProviderSubmitProposalScreen extends StatelessWidget {
  final ServiceProviderSubmitProposalController controller =
  Get.put(ServiceProviderSubmitProposalController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: "Submit Proposal",
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: controller.submitProposal,
            tooltip: 'Submit Proposal',
          ),
      ],),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeaderSection(),
            SizedBox(height: 24),

            // Proposal Form
            _buildProposalForm(),
            SizedBox(height: 32),

            // Portfolio Section
            _buildPortfolioSection(),
            SizedBox(height: 24),

            // Attachments Section
            _buildAttachmentsSection(),
            SizedBox(height: 32),

            // Submit Button
            _buildSubmitButton(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildHeaderSection() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.description, color: Colors.blue, size: 24),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Submit Proposal',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Divider(),
            SizedBox(height: 12),
            Obx(() => Text(
              'Requirement ID: ${controller.requirementId.value}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            )),
            SizedBox(height: 8),
            Text(
              'Fill out all required fields to submit your proposal. Make sure to provide detailed information about your approach.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProposalForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Proposal Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        SizedBox(height: 16),

        // Proposed Amount
        _buildFormField(
          label: 'Proposed Amount (₹)',
          hintText: 'Enter your proposed amount',
          icon: Icons.currency_rupee,
          isRequired: true,
          keyboardType: TextInputType.number,
          onChanged: (value) => controller.proposedAmount.value = value,
        ),
        SizedBox(height: 16),

        // Timeline
        _buildTimelineField(),
        SizedBox(height: 16),

        // Description
        _buildDescriptionField(),
        SizedBox(height: 8),
        Text(
          '* Please provide detailed description including your approach, methodology, and why you are the best fit for this project.',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildFormField({
    required String label,
    required String hintText,
    required IconData icon,
    required bool isRequired,
    TextInputType keyboardType = TextInputType.text,
    required Function(String) onChanged,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
            children: isRequired ? [
              TextSpan(
                text: ' *',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ] : [],
          ),
        ),
        SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(icon, color: Colors.blue),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[400]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: maxLines > 1 ? 16 : 0,
            ),
          ),
          onChanged: onChanged,
          keyboardType: keyboardType,
          maxLines: maxLines,
        ),
      ],
    );
  }

  Widget _buildTimelineField() {
    final timelineOptions = [
      '1 week',
      '2 weeks',
      '3 weeks',
      '1 month',
      '2 months',
      '3 months',
      'Custom'
    ];

    String selectedTimeline = '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Project Timeline',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
            children: [
              TextSpan(
                text: ' *',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            Get.bottomSheet(
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'Select Timeline',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Divider(height: 0),
                    Expanded(
                      child: ListView.builder(
                        itemCount: timelineOptions.length,
                        itemBuilder: (context, index) {
                          final option = timelineOptions[index];
                          return RadioListTile(
                            title: Text(option),
                            value: option,
                            groupValue: selectedTimeline,
                            onChanged: (value) {
                              selectedTimeline = value.toString();
                              controller.timeline.value = value.toString();
                              Get.back();
                            },
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        border: Border(
                          top: BorderSide(color: Colors.grey[300]!),
                        ),
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Or enter custom timeline...',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onChanged: (value) {
                          selectedTimeline = value;
                          controller.timeline.value = value;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              isScrollControlled: true,
            );
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[400]!),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Icon(Icons.access_time, color: Colors.blue),
                SizedBox(width: 12),
                Expanded(
                  child: Obx(() => Text(
                    controller.timeline.value.isEmpty
                        ? 'Select project timeline'
                        : controller.timeline.value,
                    style: TextStyle(
                      color: controller.timeline.value.isEmpty
                          ? Colors.grey[500]
                          : Colors.black,
                    ),
                  )),
                ),
                Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: 'Proposal Description',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
            children: [
              TextSpan(
                text: ' *',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[400]!),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Describe your approach, methodology, and why you\'re the best fit...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
                onChanged: (value) => controller.description.value = value,
                maxLines: 8,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  border: Border(
                    top: BorderSide(color: Colors.grey[300]!),
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Be specific about your approach and include relevant experience',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPortfolioSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Portfolio Items',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            TextButton.icon(
              onPressed: _addPortfolioItem,
              icon: Icon(Icons.add, size: 18),
              label: Text('Add Item'),
            ),
          ],
        ),
        SizedBox(height: 12),
        Obx(() => controller.portfolioItems.isEmpty
            ? _buildEmptyState(
          icon: Icons.work_outline,
          title: 'No portfolio items added',
          subtitle: 'Add relevant portfolio items to showcase your work',
          actionText: 'Add First Item',
          onAction: _addPortfolioItem,
        )
            : Column(
          children: [
            ...controller.portfolioItems.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return _buildPortfolioItemCard(item, index);
            }).toList(),
          ],
        )),
      ],
    );
  }

  Widget _buildPortfolioItemCard(String item, int index) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.work, color: Colors.blue, size: 24),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Portfolio Item',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _removePortfolioItem(index),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Attachments',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Add supporting documents, files, or additional materials',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildAttachmentButton(
              icon: Icons.attach_file,
              label: 'Add Document',
              color: Colors.blue,
              onTap: _addDocument,
            ),
            _buildAttachmentButton(
              icon: Icons.image,
              label: 'Add Images',
              color: Colors.green,
              onTap: _addImages,
            ),
            _buildAttachmentButton(
              icon: Icons.folder,
              label: 'Add Folder',
              color: Colors.orange,
              onTap: _addFolder,
            ),
          ],
        ),
        SizedBox(height: 16),
        Obx(() => controller.attachments.isEmpty
            ? _buildEmptyState(
          icon: Icons.attach_file_outlined,
          title: 'No attachments added',
          subtitle: 'Add supporting documents or files',
          actionText: 'Add First Attachment',
          onAction: _addDocument,
        )
            : Column(
          children: [
            ...controller.attachments.asMap().entries.map((entry) {
              final index = entry.key;
              final attachment = entry.value;
              return _buildAttachmentCard(attachment, index);
            }).toList(),
          ],
        )),
      ],
    );
  }

  Widget _buildAttachmentButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 110,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 28),
            SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachmentCard(String attachmentPath, int index) {
    final fileName = attachmentPath.split('/').last;
    final fileExtension = fileName.split('.').last.toLowerCase();

    IconData icon;
    Color iconColor;

    switch (fileExtension) {
      case 'pdf':
        icon = Icons.picture_as_pdf;
        iconColor = Colors.red;
        break;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
        icon = Icons.image;
        iconColor = Colors.green;
        break;
      case 'doc':
      case 'docx':
        icon = Icons.description;
        iconColor = Colors.blue;
        break;
      case 'zip':
      case 'rar':
        icon = Icons.folder_zip;
        iconColor = Colors.orange;
        break;
      default:
        icon = Icons.insert_drive_file;
        iconColor = Colors.grey;
    }

    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 1,
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        title: Text(
          fileName,
          style: TextStyle(fontWeight: FontWeight.w500),
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '${fileExtension.toUpperCase()} File',
          style: TextStyle(fontSize: 12),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.visibility_outlined, size: 20),
              onPressed: () => _previewAttachment(attachmentPath),
            ),
            IconButton(
              icon: Icon(Icons.delete_outline, size: 20, color: Colors.red),
              onPressed: () => _removeAttachment(index),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    required String actionText,
    required VoidCallback onAction,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 16),
          OutlinedButton(
            onPressed: onAction,
            child: Text(actionText),
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return
      Obx(() => controller.isLoading.value
        ? Center(child: CircularProgressIndicator())
        : Column(
      children: [

        AppButton(title: "Submit Proposal",icon: Iconsax.send1,onPressed: (){
          controller.submitProposal;
        },),
        SizedBox(height: 12),
        Text(
          'By submitting, you agree to our terms and conditions',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    ));
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => Get.back(),
                icon: Icon(Icons.arrow_back, size: 18),
                label: Text('Back'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _saveDraft(),
                icon: Icon(Icons.save, size: 18),
                label: Text('Save Draft'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.grey[800],
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addPortfolioItem() {
    final TextEditingController textController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: Text('Add Portfolio Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add a link or description of your portfolio item',
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(height: 16),
              TextField(
                controller: textController,
                decoration: InputDecoration(
                  labelText: 'Portfolio Item',
                  hintText: 'e.g., https://example.com/work or "E-commerce website project"',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[50],
                ),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final item = textController.text.trim();
              if (item.isNotEmpty) {
                controller.addPortfolioItem(item);
                Get.back();
                Get.snackbar(
                  'Success',
                  'Portfolio item added',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  void _removePortfolioItem(int index) {
    Get.defaultDialog(
      title: 'Remove Portfolio Item',
      middleText: 'Are you sure you want to remove this portfolio item?',
      textConfirm: 'Remove',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      onConfirm: () {
        controller.portfolioItems.removeAt(index);
        Get.back();
        Get.snackbar(
          'Removed',
          'Portfolio item removed',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      },
    );
  }

  void _addDocument() {
    // Simulate file picker
    final fakeFilePaths = [
      'project_proposal.pdf',
      'technical_specs.docx',
      'cost_breakdown.xlsx',
      'reference_material.zip'
    ];

    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Select Document',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(height: 0),
            Expanded(
              child: ListView.builder(
                itemCount: fakeFilePaths.length,
                itemBuilder: (context, index) {
                  final file = fakeFilePaths[index];
                  return ListTile(
                    leading: Icon(Icons.insert_drive_file, color: Colors.blue),
                    title: Text(file),
                    trailing: IconButton(
                      icon: Icon(Icons.add_circle, color: Colors.green),
                      onPressed: () {
                        controller.addAttachment('/documents/$file');
                        Get.back();
                        Get.snackbar(
                          'Added',
                          'Document added to attachments',
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(top: BorderSide(color: Colors.grey[300]!)),
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  // Simulate camera/document picker
                  Get.back();
                  _simulateFileUpload();
                },
                icon: Icon(Icons.cloud_upload),
                label: Text('Upload New Document'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _addImages() {
    // Simulate image picker
    final fakeImages = [
      'design_mockup.jpg',
      'reference_image.png',
      'previous_work_1.jpg',
      'previous_work_2.jpg'
    ];

    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Select Images',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(height: 0),
            Expanded(
              child: GridView.builder(
                padding: EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1,
                ),
                itemCount: fakeImages.length,
                itemBuilder: (context, index) {
                  final image = fakeImages[index];
                  return GestureDetector(
                    onTap: () {
                      controller.addAttachment('/images/$image');
                      Get.back();
                      Get.snackbar(
                        'Added',
                        'Image added to attachments',
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                      );
                    },
                    child: Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image, size: 40, color: Colors.grey[400]),
                          SizedBox(height: 8),
                          Text(
                            image,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 10),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(top: BorderSide(color: Colors.grey[300]!)),
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.back();
                  _simulateFileUpload();
                },
                icon: Icon(Icons.camera_alt),
                label: Text('Take Photo or Upload'),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void _addFolder() {
    Get.snackbar(
      'Info',
      'Folder upload functionality coming soon',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void _previewAttachment(String filePath) {
    final fileName = filePath.split('/').last;

    Get.dialog(
      AlertDialog(
        title: Text('File Preview'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.insert_drive_file, size: 64, color: Colors.blue),
              SizedBox(height: 16),
              Text(
                fileName,
                style: TextStyle(fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Preview not available in demo',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Download Started',
                'File download in progress',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            icon: Icon(Icons.download),
            label: Text('Download'),
          ),
        ],
      ),
    );
  }

  void _removeAttachment(int index) {
    Get.defaultDialog(
      title: 'Remove Attachment',
      middleText: 'Are you sure you want to remove this attachment?',
      textConfirm: 'Remove',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      onConfirm: () {
        controller.attachments.removeAt(index);
        Get.back();
        Get.snackbar(
          'Removed',
          'Attachment removed',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      },
    );
  }

  void _saveDraft() {
    Get.defaultDialog(
      title: 'Save Draft',
      middleText: 'Save this proposal as draft to continue later?',
      textConfirm: 'Save Draft',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        Get.snackbar(
          'Draft Saved',
          'Proposal saved as draft successfully',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.back();
      },
    );
  }

  void _simulateFileUpload() {
    Get.dialog(
      AlertDialog(
        title: Text('Uploading File'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Uploading file... Please wait'),
          ],
        ),
      ),
    );

    Future.delayed(Duration(seconds: 2), () {
      Get.back();
      controller.addAttachment('/uploads/new_file_${DateTime.now().millisecondsSinceEpoch}.pdf');
      Get.snackbar(
        'Upload Complete',
        'File uploaded successfully',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    });
  }
}