import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'package:samadhantra/app/data/model/stake_holder_model/dynamic_form_model.dart';
import 'complete_profile_screen_controller.dart';

class CompleteProfileScreen extends StatelessWidget {
  CompleteProfileScreen({super.key});

  final CompleteProfileController controller = Get.find<CompleteProfileController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(extendBody: true,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Fixed Header Section
              _buildHeaderSection(),

              // Scrollable Form Section
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: _buildFormContent(),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomButtons(),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Back Button and Title Row
          Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 18,
                    color: Colors.black54,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Complete Your Profile',
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Help us verify your identity and set up your account',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 16),

          // Role Badge
          Obx(() => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.appColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              'Stakeholder: ${controller.selectedRole.value}',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          )),

          // Progress Indicator
          const SizedBox(height: 20),
          Obx(() => _buildProgressIndicator()),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    if (!controller.isFormLoaded) return const SizedBox();

    final totalFields = controller.requiredFieldsCount;
    final filledFields = controller.filledRequiredFieldsCount;

    return Column(
      children: [
        LinearProgressIndicator(
          value: totalFields > 0 ? filledFields / totalFields : 0,
          backgroundColor: Colors.grey[200],
          color: AppColors.appColor,
          minHeight: 6,
          borderRadius: BorderRadius.circular(3),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey[600],
              ),
            ),
            Text(
              '$filledFields/$totalFields required fields completed',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.appColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFormContent() {
    return GetBuilder<CompleteProfileController>(
      builder: (controller) {
        // Show loading state
        if (controller.isLoading.value && !controller.isFormLoaded) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 100),
              child: Column(
                children: [
                  CircularProgressIndicator(color: AppColors.appColor),
                  const SizedBox(height: 20),
                  Text(
                    'Loading form configuration...',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Show error state
        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 100),
              child: Column(
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 48,
                    color: Colors.red[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load form',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.red[400],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    controller.errorMessage.value,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => controller.getUserTypeFormApi(controller.selectedRole.value),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.appColor,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        // Show form
        return Form(
          key: controller.formKey,
          child: _buildDynamicFormSection(),
        );
      },
    );
  }

  Widget _buildDynamicFormSection() {
    return GetBuilder<CompleteProfileController>(
      id: 'dynamic_form',
      builder: (controller) {
        if (!controller.isFormLoaded) {
          return const SizedBox();
        }

        final sortedFields = controller.getSortedFields();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Instruction Text
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                'Please fill in the following details:',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Form Fields
            ...sortedFields.map((field) {
              // Check field visibility
              if (!controller.isFieldVisible(field)) {
                return const SizedBox.shrink();
              }

              return Padding(
                padding: EdgeInsets.only(bottom: 16.h),
                child: _buildFieldWidget(field),
              );
            }).toList(),

            const SizedBox(height: 80), // Extra padding for bottom buttons
          ],
        );
      },
    );
  }

  Widget _buildFieldWidget(DynamicFormField field) {
    // Get current value
    final currentValue = controller.formData[field.key];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Field Label
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: RichText(
            text: TextSpan(
              text: field.label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
              children: [
                if (field.required) TextSpan(
                  text: ' *',
                  style: TextStyle(
                    color: Colors.red[400],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Field Input
        _buildFieldInput(field, currentValue),

        // Field Hint (if any)
        if (field.minLength != null || field.maxLength != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              field.type == 'number'
                  ? (field.min != null && field.max != null
                  ? 'Range: ${field.min} - ${field.max}'
                  : field.min != null
                  ? 'Minimum: ${field.min}'
                  : field.max != null
                  ? 'Maximum: ${field.max}'
                  : '')
                  : (field.minLength != null && field.maxLength != null
                  ? '${field.minLength}-${field.maxLength} characters'
                  : field.minLength != null
                  ? 'Min ${field.minLength} characters'
                  : field.maxLength != null
                  ? 'Max ${field.maxLength} characters'
                  : ''),
              style: TextStyle(
                fontSize: 11.sp,
                color: Colors.grey[500],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildFieldInput(DynamicFormField field, dynamic currentValue) {
    switch (field.type) {
      case 'string':
      case 'email':
      case 'text':
        return TextFormField(
          initialValue: currentValue?.toString() ?? '',
          decoration: InputDecoration(
            hintText: 'Enter ${field.label.toLowerCase()}',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.appColor, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red[400]!),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red[400]!, width: 1.5),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            suffixIcon: field.type == 'email'
                ? Icon(Icons.email_outlined, color: Colors.grey[500], size: 20)
                : null,
          ),
          keyboardType: field.type == 'email'
              ? TextInputType.emailAddress
              : TextInputType.text,
          maxLength: field.maxLength,
          onChanged: (value) {
            controller.updateFormValue(field.key, value);

            // Update dependent fields if this field has dependencies
            final sortedFields = controller.getSortedFields();
            bool hasDependentField = sortedFields.any((f) =>
            f.dependsOn != null && f.dependsOn!.field == field.key);

            if (hasDependentField) {
              controller.update(['dynamic_form']);
            }
          },
          validator: (value) {
            if (field.required && (value == null || value.trim().isEmpty)) {
              return '${field.label} is required';
            }
            if (value != null && field.minLength != null && value.length < field.minLength!) {
              return 'Minimum ${field.minLength} characters required';
            }
            if (value != null && field.type == 'email' && !GetUtils.isEmail(value)) {
              return 'Please enter a valid email';
            }
            return null;
          },
        );

      case 'number':
        return TextFormField(
          initialValue: currentValue?.toString() ?? '',
          decoration: InputDecoration(
            hintText: 'Enter ${field.label.toLowerCase()}',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.appColor, width: 1.5),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            suffixIcon: Icon(Icons.numbers_outlined, color: Colors.grey[500], size: 20),
          ),
          keyboardType: TextInputType.number,
          onChanged: (value) {
            if (value.isEmpty) {
              controller.updateFormValue(field.key, null);
            } else {
              final numValue = num.tryParse(value);
              controller.updateFormValue(field.key, numValue);
            }
          },
          validator: (value) {
            if (field.required && (value == null || value.isEmpty)) {
              return '${field.label} is required';
            }
            if (value != null && value.isNotEmpty) {
              final numValue = num.tryParse(value);
              if (numValue == null) {
                return 'Please enter a valid number';
              }
              if (field.min != null && numValue < field.min!) {
                return 'Minimum value is ${field.min}';
              }
              if (field.max != null && numValue > field.max!) {
                return 'Maximum value is ${field.max}';
              }
            }
            return null;
          },
        );

      case 'textarea':
        return TextFormField(
          initialValue: currentValue?.toString() ?? '',
          decoration: InputDecoration(
            hintText: 'Enter ${field.label.toLowerCase()}',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.appColor, width: 1.5),
            ),
            filled: true,
            fillColor: Colors.grey[50],
            alignLabelWithHint: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          keyboardType: TextInputType.multiline,
          maxLines: 4,
          minLines: 3,
          maxLength: field.maxLength,
          onChanged: (value) => controller.updateFormValue(field.key, value),
          validator: (value) {
            if (field.required && (value == null || value.trim().isEmpty)) {
              return '${field.label} is required';
            }
            if (value != null && field.minLength != null && value.length < field.minLength!) {
              return 'Minimum ${field.minLength} characters required';
            }
            return null;
          },
        );

      case 'select':
        final String? currentValueStr = currentValue?.toString();

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey[50],
          ),
          child: DropdownButtonFormField<String>(
            value: currentValueStr,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.appColor, width: 1.5),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.red[400]!),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.red[400]!, width: 1.5),
              ),
              filled: true,
              fillColor: Colors.transparent,
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            icon: Icon(Icons.arrow_drop_down, color: AppColors.appColor),
            elevation: 2,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14.sp,
            ),
            isExpanded: true,
            hint: Text(
              'Select ${field.label.toLowerCase()}',
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 14.sp,
              ),
            ),
            onChanged: (String? newValue) {
              controller.updateFormValue(field.key, newValue);

              // Update dependent fields
              final sortedFields = controller.getSortedFields();
              bool hasDependentField = sortedFields.any((f) =>
              f.dependsOn != null && f.dependsOn!.field == field.key);

              if (hasDependentField) {
                controller.update(['dynamic_form']);
              }
            },
            items: field.options?.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(fontSize: 14.sp),
                ),
              );
            }).toList() ?? [],
            validator: (value) {
              if (field.required && (value == null || value.isEmpty)) {
                return 'Please select ${field.label.toLowerCase()}';
              }
              return null;
            },
          ),
        );

      default:
        return TextFormField(
          initialValue: currentValue?.toString() ?? '',
          decoration: InputDecoration(
            hintText: 'Enter ${field.label.toLowerCase()}',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onChanged: (value) => controller.updateFormValue(field.key, value),
          validator: (value) {
            if (field.required && (value == null || value.isEmpty)) {
              return '${field.label} is required';
            }
            return null;
          },
        );
    }
  }

  Widget _buildBottomButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Get.back(),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.black,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(color: Colors.grey[300]!),
              ),
              child: Text(
                'Back',
                style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Obx(() => ElevatedButton(
              onPressed: controller.isLoading.value
                  ? null
                  : () async {
                if (controller.formKey.currentState!.validate()) {
                  // FOR SUBMIT FORM AND SHOW REGISTER API
                  await controller.submitForm();
                  // Get.to(()=>PaymentScreen());
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.appColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
                shadowColor: AppColors.appColor.withOpacity(0.4),
              ),
              child: controller.isLoading.value
                  ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
                  : Text(
                'Complete Setup',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )),
          ),
        ],
      ),
    );
  }
}