import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:samadhantra/app/Stakeholder_Section/modules/post_requirement_screen/post_requirement_screen_controller.dart';
import 'package:samadhantra/app/constant/app_button.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'package:samadhantra/app/constant/custom_appbar.dart';
import 'package:samadhantra/app/constant/custom_textformfield.dart';
import 'package:samadhantra/app/constant/validators.dart';
import 'package:samadhantra/app/data/model/user_data_model.dart';

class PostRequirementScreen extends StatelessWidget {
  PostRequirementScreen({super.key});

  final PostRequirementController controller = Get.put(
    PostRequirementController(),
  );
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(title: "Post Your Requirement"),
        body: Form(
          key: controller.formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stakeholder Section

                Obx(() =>
                   Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2563EB), // Blue background (Tailwind blue-600 style)
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                    child: Text(
                      'Stakeholder: ${controller.profileController.profileData.value?.userType ?? ""}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                                     ),
                ),

                 SizedBox(height: 15.h),

                // Requirement Title Section
                _buildSectionTitle("Requirement Title"),
                const SizedBox(height: 8),
                _buildRequirementTitleDropdown(),

                SizedBox(height: 15.h),

                // Problem / Need Description
                _buildSectionTitle("Problem / Need Description"),
                const SizedBox(height: 8),
                CustomTextFormField(
                  hintText: "Describe your requirement clearly",
                  controller: controller.problemController,
                  prefixIcon: Iconsax.document_text,
                  maxLines: 4,
                  validator: (value) => Validators.requiredField(minLength: 20,
                    value,
                    // fieldName: "problem description",
                  ),
                ),

                SizedBox(height: 15.h),
                // Expected Outcome
                _buildSectionTitle("Expected Outcome"),
                const SizedBox(height: 8),
                CustomTextFormField(
                  keyboardType: TextInputType.emailAddress,
                  hintText: "What result are you expecting?",
                  controller: controller.outcomeController,
                  prefixIcon: Iconsax.task_square,
                  maxLines: 3,
                  validator: (value) => Validators.requiredField(minLength: 20,
                    value,
                    // fieldName: ,
                  ),
                ),

                SizedBox(height: 15.h),

                // Timeline

                Row(
                  children: [
                    Expanded(child: _buildTimelineDropdown()),
                    const SizedBox(width: 10),
                    Expanded(child: _buildBudgetSelector()),
                  ],
                ),

                // Budget Range

                SizedBox(height: 15.h),

                // Preferred Location
                _buildSectionTitle("Preferred Location (Optional)"),
                const SizedBox(height: 8),
                CustomTextFormField(
                  hintText: "City / Remote",
                  controller: TextEditingController(
                    text: controller.selectedLocation.value,
                  ),
                  prefixIcon: Iconsax.location,
                  onChanged: (value) =>
                      controller.selectedLocation.value = value,
                ),

                SizedBox(height: 15.h),

                // Engagement Type
                _buildSectionTitle("Engagement Type"),
                const SizedBox(height: 8),
                _buildEngagementTypeSelector(),

                SizedBox(height: 15.h),

                // Urgency Level

                const SizedBox(height: 30),

                // Submit Button
                AppButton(
                  title: "Submit Requirement",
                  icon: Iconsax.cloud_add,
                  // onPressed: controller.submitRequirement,
                    onPressed: () {
                      if (controller.formKey.currentState!.validate()) {

                        if (controller.requirementData.value.id == null) {
                          // Create new requirement
                          controller.postRequirementApi(context);
                        } else {
                          // Update existing requirement
                          controller.updateRequirementList();
                        }

                      }
                    }
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildStakeholderDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Obx(
        () => DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.selectedStakeholder.value,
            isExpanded: true,
            icon: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
            ),
            items: controller.stakeholders
                .map(
                  (stakeholder) => DropdownMenuItem(
                    value: stakeholder,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(stakeholder),
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) => controller.selectedStakeholder.value = value!,
          ),
        ),
      ),
    );
  }

  Widget _buildRequirementTitleDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Obx(
        () => DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: controller.selectedRequirementTitle.value.isEmpty
                ? null
                : controller.selectedRequirementTitle.value,
            isExpanded: true,
            icon: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
            ),
            hint: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Select Requirement Title",
                style: TextStyle(color: Colors.grey[500],fontSize: 12.sp),
              ),
            ),
            items: controller.requirementTitles
                .map(
                  (title) => DropdownMenuItem(
                    value: title,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(title),
                    ),
                  ),
                )
                .toList(),
            onChanged: (value) =>
                controller.selectedRequirementTitle.value = value!,
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineDropdown() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Timeline"),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Obx(
            () => DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: controller.selectedTimeline.value,
                isExpanded: true,
                icon: Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
                ),
                items: controller.timelines
                    .map(
                      (timeline) => DropdownMenuItem(
                        value: timeline,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(timeline,style: TextStyle(fontSize: 12.sp),),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) => controller.selectedTimeline.value = value!,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBudgetSelector() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Budget Range"),
        const SizedBox(height: 8),
        CustomTextFormField(
          hintText: "10,000 - 50,000",
          controller: controller.budgetRangeController,
          keyboardType: TextInputType.number,
          prefixIcon: Icons.currency_rupee,  inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,

        ],
        ),
      ],
    );
    // Column(
    //   children: [
    //     // Predefined budget ranges
    //     Wrap(
    //       spacing: 8,
    //       runSpacing: 8,
    //       children: controller.budgetRanges.map((range) {
    //         return Obx(
    //           () => ChoiceChip(
    //             label: Text(range),
    //             selected: controller.budgetDisplay == range,
    //             onSelected: (selected) {
    //               if (selected) {
    //                 controller.setBudgetFromRange(range);
    //               }
    //             },
    //             backgroundColor: Colors.grey[50],
    //             selectedColor: AppColors.appColor.withOpacity(0.2),
    //             labelStyle: TextStyle(
    //               color: controller.budgetDisplay == range
    //                   ? AppColors.appColor
    //                   : Colors.grey[700],
    //             ),
    //             shape: RoundedRectangleBorder(
    //               borderRadius: BorderRadius.circular(8),
    //               side: BorderSide(
    //                 color: controller.budgetDisplay == range
    //                     ? AppColors.appColor
    //                     : Colors.grey[300]!,
    //               ),
    //             ),
    //           ),
    //         );
    //       }).toList(),
    //     ),
    //
    //     const SizedBox(height: 12),
    //
    //     // Custom budget input (if "Custom" is selected)
    //     Obx(() {
    //       if (controller.budgetMin.value.isEmpty ||
    //           controller.budgetDisplay == 'Select Budget Range') {
    //         return Container();
    //       }
    //
    //       return Row(
    //         children: [
    //           Expanded(
    //             child: Container(
    //               padding: const EdgeInsets.all(16),
    //               decoration: BoxDecoration(
    //                 color: AppColors.appColor.withOpacity(0.1),
    //                 borderRadius: BorderRadius.circular(12),
    //                 border: Border.all(color: AppColors.appColor),
    //               ),
    //               child: Column(
    //                 crossAxisAlignment: CrossAxisAlignment.center,
    //                 children: [
    //                   Text(
    //                     "Selected Budget",
    //                     style: TextStyle(fontSize: 12, color: Colors.grey[600]),
    //                   ),
    //                   const SizedBox(height: 4),
    //                   Text(
    //                     controller.budgetDisplay,
    //                     style: TextStyle(
    //                       fontSize: 16,
    //                       fontWeight: FontWeight.w600,
    //                       color: AppColors.appColor,
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ),
    //           ),
    //         ],
    //       );
    //     }),
    //   ],
    // );
  }

  Widget _buildEngagementTypeSelector() {
    return Column(
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: controller.engagementTypes.map((type) {
            return Obx(
              () => ChoiceChip(
                label: Text(type),
                selected: controller.selectedEngagementTypes.contains(type),
                onSelected: (selected) => controller.toggleEngagementType(type),
                backgroundColor: Colors.grey[50],
                selectedColor: AppColors.appColor.withOpacity(0.2),
                labelStyle: TextStyle(
                  color: controller.selectedEngagementTypes.contains(type)
                      ? AppColors.appColor
                      : Colors.grey[700],fontSize: 13.sp
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(
                    color: controller.selectedEngagementTypes.contains(type)
                        ? AppColors.appColor
                        : Colors.grey[300]!,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        Obx(
          () => Text(
            controller.selectedEngagementTypes.isEmpty
                ? "Select at least one option"
                : "Selected: ${controller.selectedEngagementTypes.join(', ')}",
            style: TextStyle(
              fontSize: 12,
              color: controller.selectedEngagementTypes.isEmpty
                  ? Colors.orange
                  : Colors.green,
            ),
          ),
        ),
      ],
    );
  }

}
