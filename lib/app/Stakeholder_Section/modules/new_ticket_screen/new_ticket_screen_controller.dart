import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/support_screen/support_screen_controller.dart';
import 'package:samadhantra/app/constant/app_camera_popup.dart';

class NewTicketController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString selectedCategory = ''.obs;
  final RxString selectedPriority = 'medium'.obs;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final RxList<File> attachments = <File>[].obs;

  String getFileSize(File file) {
    final bytes = file.lengthSync();
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  // Ticket categories
  final List<String> categories = [
    'billing',
    'technical',
    'general',
    'account',
    'service',
    'other'
  ];

  final Map<String, String> categoryLabels = {
    'billing': 'Billing & Payments',
    'technical': 'Technical Issues',
    'general': 'General Inquiry',
    'account': 'Account Related',
    'service': 'Service Related',
    'other': 'Other',
  };

  final Map<String, IconData> categoryIcons = {
    'billing': Icons.payment,
    'technical': Icons.construction,
    'general': Icons.help_outline,
    'account': Icons.person,
    'service': Icons.handyman,
    'other': Icons.more_horiz,
  };

  // Priority options
  final List<String> priorities = ['low', 'medium', 'high', 'urgent'];

  final Map<String, String> priorityLabels = {
    'low': 'Low',
    'medium': 'Medium',
    'high': 'High',
    'urgent': 'Urgent',
  };

  final Map<String, Color> priorityColors = {
    'low': Colors.green,
    'medium': Colors.orange,
    'high': Colors.red,
    'urgent': Colors.purple,
  };

  final Map<String, String> priorityDescriptions = {
    'low': 'Minor issue, no urgency',
    'medium': 'Standard priority',
    'high': 'Important issue, needs attention',
    'urgent': 'Critical issue, immediate attention needed',
  };

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  void setCategory(String category) {
    selectedCategory.value = category;
  }

  void setPriority(String priority) {
    selectedPriority.value = priority;
  }

// Add attachment (Camera / Gallery popup)
  Future<void> addAttachment() async {
    try {
      final File? file = await AppCameraDialog.show();

      if (file != null) {
        attachments.add(file); // same behavior as before
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to add attachment');
    }
  }

  void removeAttachment(File fileName) {
    attachments.remove(fileName);
  }

  bool validateForm() {
    if (titleController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a title for your ticket',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (selectedCategory.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select a category',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (descriptionController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please describe your issue',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }

  Future<void> submitTicket() async {
    if (!validateForm()) return;

    try {
      isLoading.value = true;

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Get the main support controller
      final SupportController supportController = Get.find<SupportController>();

      // Create the ticket
      supportController.createTicket(
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        category: selectedCategory.value,
        priority: selectedPriority.value,
      );

      Get.back(); // Close new ticket screen
      Get.until((route) => route.isFirst); // Go back to support screen

      Get.snackbar(
        'Success',
        'Support ticket created successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create ticket: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    titleController.clear();
    descriptionController.clear();
    selectedCategory.value = '';
    selectedPriority.value = 'medium';
    attachments.clear();
  }

  void showCategoryInfo(String category) {
    Get.defaultDialog(
      title: categoryLabels[category] ?? category,
      content: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Icon(
              categoryIcons[category] ?? Icons.help_outline,
              size: 48,
              color: Colors.blue,
            ),
            const SizedBox(height: 16),
            Text(
              _getCategoryDescription(category),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
      textConfirm: 'OK',
      onConfirm: Get.back,
    );
  }

  String _getCategoryDescription(String category) {
    switch (category) {
      case 'billing':
        return 'Issues related to payments, invoices, billing, and transactions.';
      case 'technical':
        return 'Technical problems, bugs, app crashes, or functionality issues.';
      case 'general':
        return 'General questions, feedback, or non-urgent inquiries.';
      case 'account':
        return 'Account management, profile updates, or security concerns.';
      case 'service':
        return 'Questions about our services, features, or provider assignments.';
      case 'other':
        return 'Any other issues not covered by the categories above.';
      default:
        return 'General support inquiry.';
    }
  }

  Color getCategoryColor(String category) {
    switch (category) {
      case 'billing':
        return Colors.green;
      case 'technical':
        return Colors.orange;
      case 'general':
        return Colors.blue;
      case 'account':
        return Colors.purple;
      case 'service':
        return Colors.teal;
      case 'other':
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }
}