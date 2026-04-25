import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'package:samadhantra/app/constant/custom_appbar.dart';
import 'package:samadhantra/app/constant/app_circularprogress_indicator.dart';
import 'package:samadhantra/app/constant/custom_textformfield.dart';
import 'new_ticket_screen_controller.dart';

class NewTicketScreen extends StatelessWidget {
  NewTicketScreen({super.key});

  final NewTicketController controller = Get.put(NewTicketController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: "Create New Ticket",
        isBackButton: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _buildLoadingState();
        }

        return _buildForm();
      }),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomProgressIndicator(),
          const SizedBox(height: 20),
          Text(
            'Creating your ticket...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please wait a moment',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return GestureDetector(
      onTap: () => FocusScope.of(Get.context!).unfocus(),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(),

            const SizedBox(height: 24),

            // Title Field
            _buildTitleField(),

            const SizedBox(height: 24),

            // Category Selection
            _buildCategorySection(),

            const SizedBox(height: 24),

            // Priority Selection
            _buildPrioritySection(),

            const SizedBox(height: 24),

            // Description Field
            _buildDescriptionField(),

            const SizedBox(height: 24),

            // Attachments
            _buildAttachmentsSection(),

            const SizedBox(height: 32),

            // Submit Button
            _buildSubmitButton(),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[100]!),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: Colors.blue[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Please provide detailed information about your issue for faster resolution.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.blue[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ticket Title *',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        CustomTextFormField(hintText: "Brief title of your issue", controller: controller.titleController),
        const SizedBox(height: 8),
        Text(
          'Keep it clear and concise (e.g., "Payment not reflecting", "Unable to upload documents")',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Category *',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: controller.categories.map((category) {
            final isSelected = controller.selectedCategory.value == category;
            return _buildCategoryChip(category, isSelected);
          }).toList(),
        ),
        const SizedBox(height: 8),
        Text(
          'Choose the category that best describes your issue',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChip(String category, bool isSelected) {
    return GestureDetector(
      onTap: () => controller.setCategory(category),
      onLongPress: () => controller.showCategoryInfo(category),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? controller.getCategoryColor(category).withOpacity(0.2)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? controller.getCategoryColor(category)
                : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: controller.getCategoryColor(category).withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              controller.categoryIcons[category] ?? Icons.help_outline,
              size: 18,
              color: isSelected
                  ? controller.getCategoryColor(category)
                  : Colors.grey[600],
            ),
            const SizedBox(width: 8),
            Text(
              controller.categoryLabels[category] ?? category,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? controller.getCategoryColor(category)
                    : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrioritySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Priority *',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: controller.priorities.map((priority) {
            final isSelected = controller.selectedPriority.value == priority;
            return _buildPriorityChip(priority, isSelected);
          }).toList(),
        ),
        const SizedBox(height: 8),
        Obx(() => Text(
          controller.priorityDescriptions[controller.selectedPriority.value] ?? '',
          style: TextStyle(
            fontSize: 12,
            color: controller.priorityColors[controller.selectedPriority.value] ?? Colors.grey[500],
          ),
        )),
      ],
    );
  }

  Widget _buildPriorityChip(String priority, bool isSelected) {
    return GestureDetector(
      onTap: () => controller.setPriority(priority),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? controller.priorityColors[priority]!.withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? controller.priorityColors[priority]!
                : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: controller.priorityColors[priority]!,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              controller.priorityLabels[priority] ?? priority,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? controller.priorityColors[priority]!
                    : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description *',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: controller.descriptionController,
            maxLines: 8,
            decoration: const InputDecoration(
              hintText: 'Describe your issue in detail...\n\n• What happened?\n• When did it occur?\n• What have you tried?',
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
            ),
            style: const TextStyle(fontSize: 14),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.lightbulb_outline, size: 14, color: Colors.orange),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                'Provide as much detail as possible for faster resolution',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAttachmentsSection() {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Attachments (Optional)',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),

        if (controller.attachments.isEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!, style: BorderStyle.solid),
            ),
            child: Column(
              children: [
                Icon(Icons.attach_file, size: 40, color: Colors.grey[400]),
                const SizedBox(height: 12),
                Text(
                  'No attachments added',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Add screenshots or documents to help us understand your issue',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          )
        else
          Column(
            children: [
              ...controller.attachments.map((fileName) => _buildAttachmentItem(fileName)),
              const SizedBox(height: 8),
            ],
          ),

        const SizedBox(height: 12),

        OutlinedButton.icon(
          onPressed: controller.addAttachment,
          icon: const Icon(Icons.add, size: 18),
          label: const Text('Add Attachment'),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppColors.appColor),
          ),
        ),
      ],
    ));
  }

  Widget _buildAttachmentItem(File file) {
    final String filePath = file.path;
    final String fileName = filePath.split('/').last;

    final bool isImage = filePath.endsWith('.png') ||
        filePath.endsWith('.jpg') ||
        filePath.endsWith('.jpeg') ||
        filePath.endsWith('.gif');

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          // IMAGE PREVIEW OR FILE ICON
          isImage
              ? ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.file(
              file,
              width: 40,
              height: 40,
              fit: BoxFit.cover,
            ),
          )
              : const Icon(Icons.insert_drive_file, color: Colors.blue),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  controller.getFileSize(file),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            icon: const Icon(Icons.close, size: 18),
            onPressed: () => controller.removeAttachment(file),
            color: Colors.grey[500],
            splashRadius: 20,
          ),
        ],
      ),
    );
  }


  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: controller.submitTicket,
        icon: const Icon(Icons.send, size: 20),
        label: const Text(
          'Submit Ticket',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.appColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
    );
  }

  void _showClearConfirmation() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Text('Discard Changes?'),
        content: const Text(
          'You have unsaved changes. Are you sure you want to discard them?',
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.back();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
  }
}