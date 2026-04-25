import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'app_color.dart';

class AppCameraDialog {
  static Future<File?> show() async {
    return await Get.dialog<File?>(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: _CameraDialogUI(),
      ),
      barrierDismissible: true,
    );
  }
}

class _CameraDialogUI extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();

  _CameraDialogUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          // Title
          Text(
            "📸 Select Image Source",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Choose how you want to add your product image",
            style: TextStyle(
              fontSize: 14,
              color: AppColors.black,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 25),

          // Camera Button
          _optionButton(
            icon: Icons.camera_alt_rounded,
            title: "Take Photo",
            colors: const [Color(0xFF667eea), Color(0xFF764ba2)],
            onTap: () => _pickImage(ImageSource.camera),
          ),

          const SizedBox(height: 16),

          // Gallery Button
          _optionButton(
            icon: Icons.photo_library_rounded,
            title: "Choose from Gallery",
            colors: const [Color(0xFFf093fb), Color(0xFFf5576c)],
            onTap: () => _pickImage(ImageSource.gallery),
          ),

          const SizedBox(height: 24),

          // Cancel Button
          InkWell(
            onTap: () => Get.back(result: null),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Center(
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _optionButton({
    required IconData icon,
    required String title,
    required List<Color> colors,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.appColor.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: colors),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: Colors.white, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 16),
          ],
        ),
      ),
    );
  }

  // ✅ Image Picker Logic
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (image == null) return;

      final file = File(image.path);

      if (file.existsSync()) {
        Get.back(result: file);
      } else {
        _showError("File not found");
      }
    } catch (e) {
      _showError("Permission denied or picker error");
    }
  }

  void _showError(String message) {
    print("error comingggg");
    Get.snackbar(
      "Image Picker",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.grey17,
      colorText: AppColors.white,
    );
  }
}
