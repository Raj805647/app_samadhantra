import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:samadhantra/app/Service_Provider_Section/modules/service_provider_edit_profile_screen/service_provider_edit_profile_screen_controller.dart';
import 'package:samadhantra/app/constant/app_button.dart';
import 'package:samadhantra/app/constant/app_color.dart';
import 'package:samadhantra/app/constant/custom_appbar.dart';

class ServiceProviderEditProfileScreen extends StatelessWidget {
  final ServiceProviderEditProfileController controller = Get.put(
    ServiceProviderEditProfileController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: "Edit Profile"),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        return _buildFormContent();
      }),
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text('Edit Profile'),
      leading: IconButton(
        icon: Icon(Icons.close),
        onPressed: controller.cancelEdit,
        tooltip: 'Cancel',
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.restart_alt),
          onPressed: controller.resetForm,
          tooltip: 'Reset Form',
        ),
      ],
    );
  }

  Widget _buildFormContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile Image Section
          _buildProfileImageSection(),
          SizedBox(height: 24),

          // Basic Information
          _buildBasicInfoSection(),
          SizedBox(height: 24),

          // Contact Information
          _buildContactInfoSection(),
          SizedBox(height: 24),

          // Business Details
          _buildBusinessDetailsSection(),
          SizedBox(height: 24),

          // Services
          _buildServicesSection(),
          SizedBox(height: 24),

          // Description
          _buildDescriptionSection(),
          SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildProfileImageSection() {
    return Center(
      child: Column(
        children: [
          Obx(() {
            final hasImage =
                controller.profileImagePath.value.isNotEmpty ||
                controller.profileImageUrl.value.isNotEmpty;

            return Stack(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.blue, width: 3),
                  ),
                  child: ClipOval(
                    child: hasImage
                        ? Container(
                            color: Colors.blue[50],
                            child: Icon(
                              Icons.business,
                              size: 60,
                              color: Colors.blue,
                            ),
                          )
                        : Container(
                            color: Colors.grey[200],
                            child: Icon(
                              Icons.add_a_photo,
                              size: 40,
                              color: Colors.grey[600],
                            ),
                          ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.camera_alt,
                        size: 18,
                        color: Colors.white,
                      ),
                      onPressed: _pickProfileImage,
                      padding: EdgeInsets.all(6),
                    ),
                  ),
                ),
              ],
            );
          }),
          SizedBox(height: 8),
          Obx(() {
            if (controller.profileImagePath.value.isNotEmpty ||
                controller.profileImageUrl.value.isNotEmpty) {
              return TextButton.icon(
                onPressed: controller.removeProfileImage,
                icon: Icon(Icons.delete_outline, size: 16),
                label: Text('Remove Photo'),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
              );
            }
            return SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Basic Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        SizedBox(height: 16),

        // Business Name
        _buildTextField(
          label: 'Business Name *',
          hintText: 'Enter your business name',
          icon: Icons.business,
          value: controller.businessName.value,
          onChanged: (value) => controller.businessName.value = value,
          isRequired: true,
        ),
        SizedBox(height: 16),

        // Business Type
        _buildDropdownField(
          label: 'Business Type',
          icon: Icons.category,
          value: controller.businessType.value,
          items: controller.businessTypes,
          onChanged: (value) => controller.businessType.value = value,
        ),
      ],
    );
  }

  Widget _buildContactInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Contact Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        SizedBox(height: 16),

        // Email
        _buildTextField(
          label: 'Email Address *',
          hintText: 'Enter your email address',
          icon: Icons.email,
          value: controller.email.value,
          onChanged: (value) => controller.email.value = value,
          isRequired: true,
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 16),

        // Phone
        _buildTextField(
          label: 'Phone Number *',
          hintText: 'Enter your phone number',
          icon: Icons.phone,
          value: controller.phone.value,
          onChanged: (value) => controller.phone.value = value,
          isRequired: true,
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: 16),

        // Website
        _buildTextField(
          label: 'Website (Optional)',
          hintText: 'Enter your website URL',
          icon: Icons.language,
          value: controller.website.value,
          onChanged: (value) => controller.website.value = value,
          keyboardType: TextInputType.url,
        ),
      ],
    );
  }

  Widget _buildBusinessDetailsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Business Details',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: _buildDropdownField(
                label: 'Years of Experience',
                icon: Icons.timeline,
                value: controller.yearsOfExperience.value,
                items: controller.experienceYears,
                onChanged: (value) =>
                    controller.yearsOfExperience.value = value,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildDropdownField(
                label: 'Team Size',
                icon: Icons.people,
                value: controller.teamSize.value,
                items: controller.teamSizes,
                onChanged: (value) => controller.teamSize.value = value,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),

        // Address
        _buildTextField(
          label: 'Address',
          hintText: 'Enter your business address',
          icon: Icons.location_on,
          value: controller.address.value,
          onChanged: (value) => controller.address.value = value,
        ),
        SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: _buildTextField(
                label: 'City',
                hintText: 'Enter city',
                value: controller.city.value,
                onChanged: (value) => controller.city.value = value,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                label: 'State',
                hintText: 'Enter state',
                value: controller.state.value,
                onChanged: (value) => controller.state.value = value,
              ),
            ),
          ],
        ),
        SizedBox(height: 16),

        _buildTextField(
          label: 'Pincode',
          hintText: 'Enter pincode',
          icon: Icons.map,
          value: controller.pincode.value,
          onChanged: (value) => controller.pincode.value = value,
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildServicesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Services Offered *',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue[800],
              ),
            ),
            Obx(
              () => Text(
                '${controller.selectedServices.length} selected',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          'Select all services you offer',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        SizedBox(height: 16),

        Obx(
          () => Wrap(
            spacing: 8,
            runSpacing: 8,
            children: controller.availableServices.map((service) {
              final isSelected = controller.selectedServices.contains(service);
              return FilterChip(
                label: Text(service),
                selected: isSelected,
                onSelected: (selected) => controller.toggleService(service),
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

        SizedBox(height: 8),
        Obx(() {
          if (controller.selectedServices.isEmpty) {
            return Text(
              '* Please select at least one service',
              style: TextStyle(fontSize: 12, color: Colors.red),
            );
          }
          return SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Business Description',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue[800],
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Describe your business, expertise, and what makes you unique',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        SizedBox(height: 16),

        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[400]!),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText:
                      'Write about your business, expertise, achievements...',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(16),
                ),
                onChanged: (value) => controller.description.value = value,
                controller: TextEditingController(
                  text: controller.description.value,
                ),
                maxLines: 6,
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
                        'This description will be visible to potential clients',
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

  Widget _buildTextField({
    required String label,
    required String hintText,
    String? value,
    IconData? icon,
    required Function(String) onChanged,
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
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
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
          onChanged: onChanged,
          controller: TextEditingController(text: value ?? ''),
          keyboardType: keyboardType,
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required Function(String) onChanged,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
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
              value: value.isEmpty ? null : value,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
              underline: SizedBox(),
              items: items.map((String item) {
                return DropdownMenuItem<String>(value: item, child: Text(item));
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  onChanged(newValue);
                }
              },
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

  Widget _buildBottomActions() {
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
              Expanded(
                child: OutlinedButton(
                  onPressed: controller.cancelEdit,
                  child: Text('Cancel'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    side: BorderSide(color: Colors.grey[400]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: AppButton(
                  title: "Save Changes",
                  onPressed: controller.isSaving.value
                      ? null
                      : controller.saveProfile,
                ),
              ),
              // Expanded(
              //   child: ElevatedButton(
              //     onPressed: controller.isSaving.value
              //         ? null
              //         : controller.saveProfile,
              //     child: controller.isSaving.value
              //         ? SizedBox(
              //             height: 20,
              //             width: 20,
              //             child: CircularProgressIndicator(
              //               strokeWidth: 2,
              //               color: Colors.white,
              //             ),
              //           )
              //         : Text('Save Changes'),
              //     style: ElevatedButton.styleFrom(
              //       backgroundColor: Colors.blue,
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

  void _pickProfileImage() {
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
                'Choose Profile Picture',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(height: 0),
            ListTile(
              leading: Icon(Icons.camera_alt, color: Colors.blue),
              title: Text('Take Photo'),
              onTap: () {
                Get.back();
                _simulateCamera();
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library, color: Colors.blue),
              title: Text('Choose from Gallery'),
              onTap: () {
                Get.back();
                _simulateGallery();
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_outline, color: Colors.red),
              title: Text(
                'Remove Current Photo',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Get.back();
                controller.removeProfileImage();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _simulateCamera() {
    Get.dialog(
      AlertDialog(
        title: Text('Camera'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.camera_alt, size: 64, color: Colors.blue),
            SizedBox(height: 16),
            Text('Camera functionality would open here'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.updateProfileImage('/path/to/camera/image.jpg');
              Get.snackbar(
                'Success',
                'Profile picture updated',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: Text('Use Photo'),
          ),
        ],
      ),
    );
  }

  void _simulateGallery() {
    Get.dialog(
      AlertDialog(
        title: Text('Gallery'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.photo_library, size: 64, color: Colors.blue),
            SizedBox(height: 16),
            Text('Gallery would open here'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.updateProfileImage('/path/to/gallery/image.jpg');
              Get.snackbar(
                'Success',
                'Profile picture updated',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            child: Text('Select Photo'),
          ),
        ],
      ),
    );
  }
}
