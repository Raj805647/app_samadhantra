import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'notification_screen_controller.dart';

class NotificationsScreen extends StatelessWidget {
  NotificationsScreen({super.key});

  final  controller = Get.put(NotificationsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.notifications.isEmpty) {
          return const Center(
            child: Text("No notifications found"),
          );
        }

        return ListView.builder(
          itemCount: controller.notifications.length,
          itemBuilder: (context, index) {
            final item =
            controller.notifications[index];

            return Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.notifications,
                ),
                title: Text(item.title),
                subtitle: Text(item.body),
                trailing: Text(
                  item.createdAt ?? "",
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                onTap: () =>
                    controller.onNotificationTap(item),
              ),
            );
          },
        );
      }),
    );
  }
}