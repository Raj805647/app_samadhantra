import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:samadhantra/app/constant/app_button.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'package:samadhantra/app/constant/custom_appbar.dart';
import 'package:samadhantra/app/constant/custom_textformfield.dart';
import 'package:samadhantra/app/constant/validators.dart';

import 'new_message_screen_controller.dart';

class NewMessageScreen extends StatelessWidget {
  const NewMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NewMessageController>(
      init: NewMessageController(),
      builder: (controller) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: CustomAppBar(title: "New Message to Admin"),
          body: _buildBody(controller),
        );
      },
    );
  }

  // PreferredSizeWidget _buildAppBar(NewMessageController controller) {
  //   return CustomAppBar(
  //     title: "New Message to Admin",
  //     isBackButton: true,
  //     actions: [
  //       Obx(() => controller.isLoading.value
  //           ? Padding(
  //         padding: EdgeInsets.symmetric(horizontal: 16),
  //         child: SizedBox(
  //           width: 20,
  //           height: 20,
  //           child: CircularProgressIndicator(strokeWidth: 2),
  //         ),
  //       )
  //           : TextButton(
  //         onPressed: controller.sendMessage,
  //         child: Text(
  //           'Send',
  //           style: TextStyle(color: AppColors.appColor),
  //         ),
  //       )),
  //     ],
  //   );
  // }

  Widget _buildBody(NewMessageController controller) {
    return Form(
      key: controller.formKey,
      child: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Requirement Selection
          _buildRequirementSection(controller),
          SizedBox(height: 20),

          // Message Type
          _buildMessageTypeSection(controller),
          SizedBox(height: 20),

          // Subject
          _buildSubjectField(controller),
          SizedBox(height: 16),

          // Message
          _buildMessageField(controller),
          SizedBox(height: 20),

          // Attachments
          _buildAttachmentsSection(controller),
          SizedBox(height: 40),
          AppButton(title: "Send", onPressed: () => controller.sendMessage()),
        ],
      ),
    );
  }

  Widget _buildRequirementSection(NewMessageController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Related Requirement',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => DropdownButtonFormField<String>(
            value: controller.selectedRequirement.value.isNotEmpty
                ? controller.selectedRequirement.value
                : null,
            decoration: InputDecoration(
              hintText: 'Select requirement',
              prefixIcon: const Icon(Icons.description),
              filled: true,
              fillColor: Colors.grey.shade50,

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: Theme.of(Get.context!).primaryColor,
                  width: 1.2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Colors.redAccent, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: Colors.redAccent,
                  width: 1.2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
            ),
            items: controller.requirementTypes.map((req) {
              return DropdownMenuItem(value: req, child: Text(req));
            }).toList(),
            onChanged: controller.setRequirement,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a requirement';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMessageTypeSection(NewMessageController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Message Type',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: controller.messageTypes.map((type) {
            return Obx(() {
              bool isSelected = controller.isTypeSelected(
                type['value'] as String,
              );
              return ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(type['icon'] as IconData, size: 16),
                    SizedBox(width: 4),
                    Text(type['label'] as String),
                  ],
                ),
                selected: isSelected,
                onSelected: (_) =>
                    controller.setMessageType(type['value'] as String),
                backgroundColor: isSelected
                    ? Colors.grey.withOpacity(0.6)
                    : Colors.grey[100],
                selectedColor: Colors.grey,
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.appColor : Colors.grey[700],
                ),
              );
            });
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSubjectField(NewMessageController controller) {
    return CustomTextFormField(
      hintText: "Subject",
      controller: controller.subjectController,
      prefixIcon: Iconsax.book_1,
      validator:(value) => Validators.name(value,fieldName: "subject"),
    );
  }

  Widget _buildMessageField(NewMessageController controller) {
    return CustomTextFormField(
      hintText: "Message",
      controller: controller.subjectController,
      validator:(value) => Validators.name(value,fieldName: "message"),
      maxLines: 4,
    );

      TextFormField(
      controller: controller.messageController,
      maxLines: 8,
      decoration: InputDecoration(
        labelText: 'Message',
        border: OutlineInputBorder(),
        alignLabelWithHint: true,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your message';
        }
        return null;
      },
    );
  }

  Widget _buildAttachmentsSection(NewMessageController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Attachments',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.attach_file, color: AppColors.appColor),
              onPressed: controller.addAttachment,
            ),
          ],
        ),
        SizedBox(height: 8),
        Obx(
          () => controller.attachments.isEmpty
              ? _buildEmptyAttachments()
              : _buildAttachmentsList(controller),
        ),
      ],
    );
  }

  Widget _buildEmptyAttachments() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        // border: Border.all(color: Colors.grey[300], style: BorderStyle.dashed),
      ),
      child: Column(
        children: [
          Icon(Icons.cloud_upload, size: 40, color: Colors.grey[400]),
          SizedBox(height: 8),
          Text('No files attached', style: TextStyle(color: Colors.grey[500])),
        ],
      ),
    );
  }

  Widget _buildAttachmentsList(NewMessageController controller) {
    return Column(
      children: controller.attachments.map((attachment) {
        return Card(
          margin: EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Icon(Icons.insert_drive_file, color: AppColors.appColor),
            title: Text(
              attachment.split('/').last,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text('PDF Document'),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => controller.removeAttachment(attachment),
            ),
          ),
        );
      }).toList(),
    );
  }
}
