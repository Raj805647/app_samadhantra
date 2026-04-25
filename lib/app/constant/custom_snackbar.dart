import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class CustomSnackBar {
  static void show({
    required String title,
    required String message,
    required ContentType type,
    int durationSeconds = 3,
  }) {
    Get.showSnackbar(
      GetSnackBar(
        duration: Duration(seconds: durationSeconds),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.transparent,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        padding: EdgeInsets.zero,
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        animationDuration: const Duration(milliseconds: 300),
        messageText: AwesomeSnackbarContent(
          title: title,
          message: message,
          contentType: type,
        ),
      ),
    );
  }

  // ✅ Short helper methods
  static void success(String message, {String title = 'Success'}) {
    show(
      title: title,
      message: message,
      type: ContentType.success,
    );
  }

  static void error(String message, {String title = 'Error'}) {
    show(
      title: title,
      message: message,
      type: ContentType.failure,
    );
  }

  static void warning(String message, {String title = 'Warning'}) {
    show(
      title: title,
      message: message,
      type: ContentType.warning,
    );
  }

  static void info(String message, {String title = 'Info'}) {
    show(
      title: title,
      message: message,
      type: ContentType.help,
    );
  }
}
