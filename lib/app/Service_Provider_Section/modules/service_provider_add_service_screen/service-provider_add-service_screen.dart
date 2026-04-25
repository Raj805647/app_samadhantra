import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/Service_Provider_Section/modules/service_provider_add_service_screen/service-provider_add-service_screen_controller.dart';
import 'package:samadhantra/app/constant/app_button.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'package:samadhantra/app/constant/custom_appbar.dart';
import 'package:samadhantra/app/constant/custom_textformfield.dart';

class ServiceProviderAddServiceScreen extends StatelessWidget {
  final ServiceProviderAddServiceController controller =
      Get.find<ServiceProviderAddServiceController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(extendBody: true,
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(title: "Add New Service"),
        body: _buildBody(),
        bottomNavigationBar: _buildBottomNavigation(),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        // Progress Stepper
        _buildStepperHeader(),
        SizedBox(height: 16),

        // Form Content
        Expanded(child: _buildStepContent()),
      ],
    );
  }

  Widget _buildStepperHeader() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStepIndicator(0, 'Basic Info'),
              _buildStepIndicator(1, 'Pricing & Details'),
              _buildStepIndicator(2, 'Additional Info'),
            ],
          ),
          SizedBox(height: 8),
          Obx(
            () => LinearProgressIndicator(
              value: (controller.currentStep.value + 1) / 3,
              backgroundColor: Colors.grey[200],
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int stepNumber, String label) {
    return Obx(() {
      final isActive = controller.currentStep.value == stepNumber;
      final isCompleted = controller.currentStep.value > stepNumber;

      return Column(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: isCompleted
                  ? Colors.green
                  : (isActive ? Colors.blue : Colors.grey[300]),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isCompleted
                  ? Icon(Icons.check, size: 18, color: Colors.white)
                  : Text(
                      '${stepNumber + 1}',
                      style: TextStyle(
                        color: isActive ? Colors.white : Colors.grey[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? Colors.blue : Colors.grey[600],
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildStepContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            switch (controller.currentStep.value) {
              case 0:
                return _buildStep1BasicInfo();
              case 1:
                return _buildStep2PricingDetails();
              case 2:
                return _buildStep3AdditionalInfo();
              default:
                return _buildStep1BasicInfo();
            }
          }),
          SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildStep1BasicInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Basic Information',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Tell us about your service',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        SizedBox(height: 24),

        // Service Name
        Text("Service Name *"),
        SizedBox(height: 5,),
        CustomTextFormField(
          hintText: "e.g., Flutter Mobile App Development",
          controller: controller.serviceNameController,prefixIcon: Icons.business_center,
        ),
        SizedBox(height: 20),

        // Service Description
        Text("Service Description *"),
        SizedBox(height: 5,),
        CustomTextFormField(
          hintText: "Describe what you offer in detail...",
          controller: controller.serviceDescriptionController,prefixIcon: Icons.description,
          maxLines: 4,
        ),
        SizedBox(height: 20),

        // Category Selection
        _buildDropdownField(
          label: 'Category *',
          value: controller.selectedCategory.value,
          items: controller.categories,
          onChanged: (value) => controller.selectedCategory.value = value!,
          icon: Icons.category,
        ),

        SizedBox(height: 16),
        Text(
          '* Required fields',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildStep2PricingDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pricing & Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Set your pricing and service details',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        SizedBox(height: 24),

        // Pricing Model
        _buildPricingModelSelector(),
        SizedBox(height: 20),

        // Pricing Fields based on selected model
        Obx(() => _buildPricingFields()),
        SizedBox(height: 20),

        // Experience Level
        _buildDropdownField(
          label: 'Experience Level',
          value: controller.experienceLevel.value,
          items: controller.experienceLevels,
          onChanged: (value) => controller.experienceLevel.value = value!,
          icon: Icons.timeline,
        ),
        SizedBox(height: 20),

        // Delivery Days
        _buildDropdownField(
          label: 'Delivery Time',
          value: controller.deliveryDays.value,
          items: controller.deliveryOptions.map((opt) => '$opt days').toList(),
          onChanged: (value) {
            final days = value!.replaceAll(' days', '');
            controller.deliveryDays.value = days;
          },
          icon: Icons.access_time,
        ),
        SizedBox(height: 20),

        // Skills Selection
        _buildSkillsSelector(),
      ],
    );
  }

  Widget _buildStep3AdditionalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Information',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        SizedBox(height: 16),
        Text(
          'Add tags and set service visibility',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        SizedBox(height: 24),

        // Tags Selection
        _buildTagsSelector(),
        SizedBox(height: 24),

        // Service Status
        Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Service Status',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                Obx(
                  () => SwitchListTile(
                    title: Text('Active Service'),
                    subtitle: Text('Make this service visible to clients'),
                    value: controller.isActive.value,
                    onChanged: (value) => controller.isActive.value = value,
                  ),
                ),
                Obx(
                  () => SwitchListTile(
                    title: Text('Featured Service'),
                    subtitle: Text('Highlight this service in search results'),
                    value: controller.isFeatured.value,
                    onChanged: (value) => controller.isFeatured.value = value,
                  ),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: 24),

        // Pricing Summary
        _buildPricingSummary(),
      ],
    );
  }

  Widget _buildPricingModelSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pricing Model *',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: 8),
        Obx(
          () => SegmentedButton(
            segments: controller.pricingModels.map((model) {
              return ButtonSegment(
                value: model,
                label: Text(model),
                icon: Icon(_getPricingIcon(model)),
              );
            }).toList(),
            selected: {controller.selectedPricingModel.value},
            onSelectionChanged: (newSelection) {
              controller.selectedPricingModel.value = newSelection.first;
              controller.updatePricing();
            },
          ),
        ),
      ],
    );
  }

  IconData _getPricingIcon(String model) {
    switch (model) {
      case 'Hourly':
        return Icons.access_time;
      case 'Daily':
        return Icons.calendar_today;
      case 'Project-based':
        return Icons.assignment;
      case 'Monthly':
        return Icons.calendar_month;
      default:
        return Icons.attach_money;
    }
  }

  Widget _buildPricingFields() {
    return Column(
      children: [
        if (controller.selectedPricingModel.value == 'Hourly') ...[
          _buildTextField(
            label: 'Hourly Rate (₹) *',
            hintText: 'e.g., 1500',
            value: controller.hourlyRate.value,
            onChanged: (value) {
              controller.hourlyRate.value = value;
              controller.updatePricing();
            },
            keyboardType: TextInputType.number,
            icon: Icons.currency_rupee,
          ),
          SizedBox(height: 12),
          _buildPricingConversion('Daily', controller.calculatedDailyRate),
          SizedBox(height: 12),
          _buildPricingConversion('Project', controller.calculatedProjectRate),
        ] else if (controller.selectedPricingModel.value == 'Daily') ...[
          _buildTextField(
            label: 'Daily Rate (₹) *',
            hintText: 'e.g., 10000',
            value: controller.dailyRate.value,
            onChanged: (value) {
              controller.dailyRate.value = value;
              controller.updatePricing();
            },
            keyboardType: TextInputType.number,
            icon: Icons.currency_rupee,
          ),
          SizedBox(height: 12),
          _buildPricingConversion('Hourly', controller.calculatedHourlyRate),
          SizedBox(height: 12),
          _buildPricingConversion('Project', controller.calculatedProjectRate),
        ] else if (controller.selectedPricingModel.value ==
            'Project-based') ...[
          _buildTextField(
            label: 'Project Rate (₹) *',
            hintText: 'e.g., 50000',
            value: controller.projectRate.value,
            onChanged: (value) {
              controller.projectRate.value = value;
              controller.updatePricing();
            },
            keyboardType: TextInputType.number,
            icon: Icons.currency_rupee,
          ),
          SizedBox(height: 12),
          _buildPricingConversion('Hourly', controller.calculatedHourlyRate),
          SizedBox(height: 12),
          _buildPricingConversion('Daily', controller.calculatedDailyRate),
        ] else if (controller.selectedPricingModel.value == 'Monthly') ...[
          _buildTextField(
            label: 'Monthly Rate (₹)',
            hintText: 'e.g., 200000',
            value: controller.projectRate.value,
            onChanged: (value) => controller.projectRate.value = value,
            keyboardType: TextInputType.number,
            icon: Icons.currency_rupee,
          ),
        ],
      ],
    );
  }

  Widget _buildPricingConversion(String type, double rate) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, size: 16, color: Colors.blue),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Approx. ₹${rate.toStringAsFixed(0)} $type',
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Skills Required *',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            Obx(
              () => Text(
                '${controller.skills.length} selected',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          'Select skills required for this service',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        SizedBox(height: 12),

        // Skills Chips
        Obx(
          () => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: controller.availableSkills.map((skill) {
              final isSelected = controller.skills.contains(skill);
              return FilterChip(
                label: Text(skill),
                selected: isSelected,
                onSelected: (selected) => controller.toggleSkill(skill),
                backgroundColor: isSelected
                    ? Colors.blue[100]
                    : Colors.grey[200],
                selectedColor: Colors.blue[200],
                checkmarkColor: Colors.blue[800],
                labelStyle: TextStyle(
                  color: isSelected ? Colors.blue[800] : Colors.grey[700],
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              );
            }).toList(),
          ),
        ),

        SizedBox(height: 12),

        // Add Custom Skill
        _buildAddCustomItem(
          hint: 'Add custom skill...',
          onAdd: (value) => controller.addCustomSkill(value),
        ),
      ],
    );
  }

  Widget _buildTagsSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tags (Optional)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            Obx(
              () => Text(
                '${controller.tags.length} selected',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          'Add tags to help clients find your service',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        SizedBox(height: 12),

        // Tags Chips
        Obx(
          () => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: controller.availableTags.map((tag) {
              final isSelected = controller.tags.contains(tag);
              return FilterChip(
                label: Text(tag),
                selected: isSelected,
                onSelected: (selected) => controller.toggleTag(tag),
                backgroundColor: isSelected
                    ? Colors.green[100]
                    : Colors.grey[200],
                selectedColor: Colors.green[200],
                checkmarkColor: Colors.green[800],
                labelStyle: TextStyle(
                  color: isSelected ? Colors.green[800] : Colors.grey[700],
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              );
            }).toList(),
          ),
        ),

        SizedBox(height: 12),

        // Add Custom Tag
        _buildAddCustomItem(
          hint: 'Add custom tag...',
          onAdd: (value) => controller.addCustomTag(value),
        ),
      ],
    );
  }

  Widget _buildAddCustomItem({
    required String hint,
    required Function(String) onAdd,
  }) {
    final textController = TextEditingController();

    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: textController,
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            onSubmitted: (value) {
              if (value.isNotEmpty) {
                onAdd(value);
                textController.clear();
              }
            },
          ),
        ),
        SizedBox(width: 8),
        IconButton(
          icon: Icon(Icons.add_circle, color: Colors.blue),
          onPressed: () {
            final value = textController.text.trim();
            if (value.isNotEmpty) {
              onAdd(value);
              textController.clear();
            }
          },
        ),
      ],
    );
  }

  Widget _buildPricingSummary() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pricing Summary',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryItem(
                    label: 'Hourly',
                    value:
                        '₹${controller.calculatedHourlyRate.toStringAsFixed(0)}',
                    icon: Icons.access_time,
                  ),
                ),
                Expanded(
                  child: _buildSummaryItem(
                    label: 'Daily',
                    value:
                        '₹${controller.calculatedDailyRate.toStringAsFixed(0)}',
                    icon: Icons.calendar_today,
                  ),
                ),
                Expanded(
                  child: _buildSummaryItem(
                    label: 'Project',
                    value:
                        '₹${controller.calculatedProjectRate.toStringAsFixed(0)}',
                    icon: Icons.assignment,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Divider(),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Delivery Time',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  '${controller.deliveryDays.value} days',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryItem({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue, size: 24),
        SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String hintText,
    required String value,
    required Function(String) onChanged,
    IconData? icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    bool isRequired = false,
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
            children: isRequired
                ? [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]
                : [],
          ),
        ),
        SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: icon != null ? Icon(icon, color: Colors.blue) : null,
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
          controller: TextEditingController(text: value),
          keyboardType: keyboardType,
          maxLines: maxLines,
        ),
      ],
    );
  }

  Widget _buildTextArea({
    required String label,
    required String hintText,
    required String value,
    required Function(String) onChanged,
    IconData? icon,
    int maxLines = 4,
    bool isRequired = false,
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
            children: isRequired
                ? [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]
                : [],
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
                  hintText: hintText,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
                onChanged: onChanged,
                controller: TextEditingController(text: value),
                maxLines: maxLines,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  border: Border(top: BorderSide(color: Colors.grey[300]!)),
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
                        'Be clear and detailed about what you offer',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    IconData? icon,
    bool isRequired = false,
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
            children: isRequired
                ? [
                    TextSpan(
                      text: ' *',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]
                : [],
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[400]!),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: DropdownButton<String>(
              value: items.contains(value) ? value : null,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
              underline: SizedBox(),
              items: items.map((String item) {
                return DropdownMenuItem<String>(value: item, child: Text(item));
              }).toList(),
              onChanged: onChanged,
              hint: Text(
                'Select $label',
                style: TextStyle(color: Colors.grey[500]),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: EdgeInsets.all(16),
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
        child: Obx(
          () => Row(
            children: [
              if (controller.currentStep.value > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: controller.previousStep,
                    child: Text('Previous'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              if (controller.currentStep.value > 0) SizedBox(width: 12),
              Expanded(
                child: AppButton(
                  title: controller.currentStep.value == 2
                      ? 'Publish Service'
                      : 'Next',
                  onPressed: controller.isSubmitting.value
                      ? null
                      : controller.nextStep,
                ),
              ),
              // Expanded(
              //   child: ElevatedButton(
              //     onPressed: controller.isSubmitting.value
              //         ? null
              //         : controller.nextStep,
              //     child: controller.isSubmitting.value
              //         ? SizedBox(
              //             height: 20,
              //             width: 20,
              //             child: CircularProgressIndicator(
              //               strokeWidth: 2,
              //               color: Colors.white,
              //             ),
              //           )
              //         : Text(
              //             controller.currentStep.value == 2
              //                 ? 'Publish Service'
              //                 : 'Next',
              //             style: TextStyle(fontWeight: FontWeight.bold),
              //           ),
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: controller.currentStep.value == 2
              //           ? Colors.green
              //           : Colors.blue,
              //       foregroundColor: Colors.white,
              //       padding: EdgeInsets.symmetric(vertical: 14),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
