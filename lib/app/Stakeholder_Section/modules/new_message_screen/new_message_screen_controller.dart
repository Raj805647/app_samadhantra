import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/message_screen/message_screen_controller.dart';
import 'package:samadhantra/app/constant/app_color.dart';

class NewMessageController extends GetxController {
  final MessageController _messageController = Get.find();

  // Form key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Text controllers
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  // Reactive variables
  final RxString selectedRequirement = ''.obs;
  final RxString selectedType = 'query'.obs;
  final RxList<String> attachments = <String>[].obs;
  final RxBool isLoading = false.obs;

  // Dropdown options
  final List<String> requirementTypes = [
    'Mobile App Development',
    'UI/UX Design',
    'Website Development',
    'Software Development',
    'Digital Marketing',
  ];

  final List<Map<String, dynamic>> messageTypes = [
    {'value': 'query', 'label': 'General Query', 'icon': Icons.question_answer},
    {'value': 'issue', 'label': 'Report Issue', 'icon': Icons.warning},
    {'value': 'update', 'label': 'Request Update', 'icon': Icons.update},
    {'value': 'payment', 'label': 'Payment Related', 'icon': Icons.payment},
    {'value': 'other', 'label': 'Other', 'icon': Icons.more_horiz},
  ];

  @override
  void onClose() {
    subjectController.dispose();
    messageController.dispose();
    super.onClose();
  }

  void setRequirement(String? value) {
    if (value != null) {
      selectedRequirement.value = value;
    }
  }

  void setMessageType(String type) {
    selectedType.value = type;
  }

  void addAttachment() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.document_scanner, color: AppColors.appColor),
              title: Text('Take Photo'),
              onTap: () => _takePhoto(),
            ),
            ListTile(
              leading: Icon(Icons.image, color: AppColors.appColor),
              title: Text('Choose from Gallery'),
              onTap: () => _chooseFromGallery(),
            ),
            ListTile(
              leading: Icon(Icons.folder, color: AppColors.appColor),
              title: Text('Choose Document'),
              onTap: () => _chooseDocument(),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _takePhoto() {
    Get.back();
    Get.snackbar('Info', 'Camera feature coming soon');
  }

  void _chooseFromGallery() {
    Get.back();
    Get.snackbar('Info', 'Gallery feature coming soon');
  }

  void _chooseDocument() {
    Get.back();
    // Simulate document selection
    final fakeAttachment = '/path/to/document_${DateTime.now().millisecondsSinceEpoch}.pdf';
    attachments.add(fakeAttachment);
    Get.snackbar('Success', 'Document added');
  }

  void removeAttachment(String attachment) {
    attachments.remove(attachment);
  }

  void sendMessage() {
    print("hsfsdf");
    if (!formKey.currentState!.validate()) return;

    if (selectedRequirement.value.isEmpty) {
      Get.snackbar('Error', 'Please select a requirement');
      return;
    }

    isLoading.value = true;

    try {
      // Type-safe way to get values
      final subject = subjectController.text.trim();
      final message = messageController.text.trim();
      final requirement = selectedRequirement.value;

      if (subject.isEmpty || message.isEmpty || requirement.isEmpty) {
        Get.snackbar('Error', 'Please fill in all required fields');
        return;
      }

    /*  _messageController.createNewMessage(
        subject: subject,
        message: message,
        requirementId: requirement,
        attachments: attachments.toList(),
      );*/

      // Clear form
      subjectController.clear();
      messageController.clear();
      selectedRequirement.value = '';
      selectedType.value = 'query';
      attachments.clear();

      Get.back();
      Get.snackbar('Success', 'Message sent successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to send message: $e');
    } finally {
      isLoading.value = false;
    }
  }

  String getTypeLabel(String value) {
    return messageTypes.firstWhere(
          (type) => type['value'] == value,
      orElse: () => {'label': 'General Query'},
    )['label'] as String;
  }

  IconData getTypeIcon(String value) {
    return messageTypes.firstWhere(
          (type) => type['value'] == value,
      orElse: () => {'icon': Icons.question_answer},
    )['icon'] as IconData;
  }

  bool isTypeSelected(String value) {
    return selectedType.value == value;
  }
}