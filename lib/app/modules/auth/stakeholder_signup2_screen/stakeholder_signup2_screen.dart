import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/constant/app_button.dart';
import 'package:samadhantra/app/constant/app_style.dart';
import 'package:samadhantra/app/constant/custom_dropdown.dart';
import 'package:samadhantra/app/constant/custom_textformfield.dart';
import 'package:samadhantra/app/constant/dropdown_controller.dart';
import 'package:samadhantra/app/constant/multi_select_dropdown/multi_select_dropdown.dart';
import 'package:samadhantra/app/constant/validators.dart';
import 'package:samadhantra/app/global_routes/app_routes.dart';
import 'package:samadhantra/app/modules/auth/stakeholder_signup2_screen/stakeholder_signup2_screen_controller.dart';
import 'package:samadhantra/app/utils/widgets/place_search_widget.dart';

class StakeholderSignup2Screen extends StatelessWidget {
  StakeholderSignup2Screen({super.key});

  final StakeholderSignup2ScreenController controller = Get.put(
    StakeholderSignup2ScreenController(),
  );
  final objectivesController = DropdownController<String>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with Back Button
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
                              'Additional Details Screen',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Help us verify your identity and set up your account',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                  const Divider(height: 1),
                  const SizedBox(height: 20),

                  // Reference Number
                  Text(
                    "Reference Number",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 5),
                  CustomTextFormField(
                    hintText: "REF12345",
                    controller: controller.referenceController,
                    prefixIcon: Icons.link,
                    // validator: Validators.requiredField,
                  ),

                  SizedBox(height: AppStyle.heightPercent(context, 2)),

                  // Address
                  Text(
                    "Address",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 5),
                  PlaceSearchWidget(
                    controller: controller,
                    // validator: Validators.requiredField,
                  ),
                  // const SizedBox(height: 20),

                  const SizedBox(height: 20),
                  // Reference Number

                  Text(
                      "About Yourself",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  const SizedBox(height: 5),
                  CustomTextFormField(
                    hintText: "About YourSelf",
                    controller: controller.aboutYourselfController,
                    prefixIcon: Icons.person,
                    maxLines: 3,
                    validator: Validators.requiredField,
                  ),
                  const SizedBox(height: 20),

                  // Objectives
                  Text(
                    "Objective *",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 5),
                  CustomDropdown(
                    controller: controller.objectiveController,
                    items: controller.items,
                    displayText: (item) => item,
                  ),

                  const SizedBox(height: 20),

                  // Categories
                  Text(
                    "Categories *",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 5),
                  MultiSelectCustomDropdown<String>(
                    controller: controller.categoriesController,
                    items: controller.categories,
                    displayText: (subject) => subject,
                    hintText: 'Select Categories',
                    icon: Icons.category,
                    maxItemsToShow: 2,
                    onSelectionChanged: (selectedItems) {
                      print('Selected items: ${selectedItems.join(', ')}');
                    },
                  ),



                  Obx(() => controller.isOtherSelected
                      ? Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20,),
                          Text(
                            "Custom Category",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 5),
                          CustomTextFormField(
                                              hintText: "Custom Category",
                                              controller: controller.customCategpryController,
                                            ),
                        ],
                      )
                      : const SizedBox()),


                  const SizedBox(height: 20),

                  // Sub Category
                  Text(
                    "Sub Categories *",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 5),
                  MultiSelectCustomDropdown<String>(
                    controller: controller.subCategoriesController,
                    items: controller.subCategories,
                    displayText: (subject) => subject,
                    hintText: 'Select Sub-Categories',
                    icon: Icons.subdirectory_arrow_right,
                    maxItemsToShow: 2,
                    onSelectionChanged: (selectedItems) {
                      print('Selected items: ${selectedItems.join(', ')}');
                    },
                  ),

                  Obx(() => controller.isSubOtherSelected
                      ? Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20,),
                      Text(
                        "Custom Sub Category",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 5),
                      CustomTextFormField(
                        hintText: "Custom Sub Category",
                        controller: controller.customSubCategpryController,
                      ),
                    ],
                  )
                      : const SizedBox()),

                  const SizedBox(height: 20),
                  _buildAboutField(),

                  SizedBox(height: 20),

                  // Next Button
                  AppButton(
                    title: "Next",
                    onPressed: () {
                      if (controller.formKey.currentState?.validate() ??
                          false) {
                        controller.updateLocationInfo(
                          aboutYourself: controller.aboutYourselfController.text.trim(),
                          city: controller.mapController.selectedPlace.value?.city,
                          state: controller.mapController.selectedPlace.value?.state,
                          referenceNumber: controller.referenceController.text
                              .trim(),
                          address:
                              controller
                                  .mapController
                                  .selectedPlace
                                  .value
                                  ?.address
                                  .toString() ??
                              "",
                          latitude:
                              controller.mapController.selectedPlace.value?.lat
                                  .toDouble() ??
                              0.0,
                          longitude:
                              controller.mapController.selectedPlace.value?.lat
                                  .toDouble() ??
                              0.0,
                          objective:
                              controller.objectiveController.selectedItem.value,
                          category:
                              controller.categoriesController.selectedItemsObs,
                          customCategory: controller.customCategpryController.text.trim().isEmpty
                              ? null
                              : controller.customCategpryController.text.trim(),
                          subCategory: controller
                              .subCategoriesController
                              .selectedItemsObs,
                          customSubCategory: controller.customSubCategpryController.text.trim().isEmpty
                              ? null
                              : controller.customSubCategpryController.text.trim(),
                          describeYourNeed: controller.describeYourNeedController.text
                              .trim(),
                        );
                        Get.toNamed(AppRoutes.roleSelection);
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAboutField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Describe Your Need *',
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 5),
        CustomTextFormField(
          hintText: "You May Describe Your Future Need/Requirements Here",
          controller: controller.describeYourNeedController,
          maxLines: 4,
          validator: Validators.requiredField,
          // prefixIcon: Icons.nearby_error,
        ),
      ],
    );
  }
}
