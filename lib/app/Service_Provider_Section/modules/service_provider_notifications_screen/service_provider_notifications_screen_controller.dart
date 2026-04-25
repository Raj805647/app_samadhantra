// lib/app/modules/service_provider/controllers/service_provider_notifications_controller.dart
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:samadhantra/app/data/model/service_notification_model.dart';

class ServiceProviderNotificationsController extends GetxController {
  var isLoading = false.obs;
  var isRefreshing = false.obs;
  var selectedFilter = NotificationFilter.all.obs;
  var unreadCount = 0.obs;

  var notifications = <ServiceNotificationModel>[].obs;

  final List<NotificationFilter> filters = [
    NotificationFilter.all,
    NotificationFilter.unread,
    NotificationFilter.proposal,
    NotificationFilter.assignment,
    NotificationFilter.payment,
  ];

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
    startRealTimeUpdates();
  }

  @override
  void onClose() {
    stopRealTimeUpdates();
    super.onClose();
  }

  void loadNotifications() async {
    isLoading.value = true;

    // Simulate API call
    await Future.delayed(Duration(seconds: 1));

    // Sample notifications data
    notifications.value = [
      ServiceNotificationModel(
        id: '1',
        title: 'Proposal Accepted!',
        message: 'Your proposal for "E-commerce Website Development" has been accepted by ABC Enterprises',
        type: NotificationType.proposal,
        proposalId: 'PROP001',
        requirementId: 'REQ001',
        dateTime: DateTime.now().subtract(Duration(minutes: 5)),
        isRead: false,
        data: {
          'clientName': 'ABC Enterprises',
          'budget': '₹75,000',
          'deadline': '2024-01-30',
        },
      ),
      ServiceNotificationModel(
        id: '2',
        title: 'New Message',
        message: 'You have a new message from XYZ Corp regarding your proposal',
        type: NotificationType.message,
        proposalId: 'PROP002',
        dateTime: DateTime.now().subtract(Duration(hours: 2)),
        isRead: false,
        data: {
          'senderName': 'XYZ Corp',
          'messagePreview': 'Can we discuss the timeline for...',
        },
      ),
      ServiceNotificationModel(
        id: '3',
        title: 'Payment Received',
        message: 'Payment of ₹25,000 has been credited to your account for milestone completion',
        type: NotificationType.payment,
        assignmentId: 'ASG001',
        dateTime: DateTime.now().subtract(Duration(days: 1)),
        isRead: true,
        data: {
          'amount': '₹25,000',
          'assignmentTitle': 'Mobile App Development',
          'clientName': 'Startup Co.',
        },
      ),
      ServiceNotificationModel(
        id: '4',
        title: 'New Review Received',
        message: 'ABC Enterprises has given you a 5-star review for your completed project',
        type: NotificationType.review,
        assignmentId: 'ASG002',
        dateTime: DateTime.now().subtract(Duration(days: 2)),
        isRead: true,
        data: {
          'rating': 5,
          'clientName': 'ABC Enterprises',
          'projectTitle': 'Website Redesign',
        },
      ),
      ServiceNotificationModel(
        id: '5',
        title: 'System Update',
        message: 'New features added: Real-time chat, milestone tracking, and advanced analytics',
        type: NotificationType.system,
        dateTime: DateTime.now().subtract(Duration(days: 3)),
        isRead: true,
        data: {
          'version': '2.0.0',
          'features': ['Real-time Chat', 'Milestone Tracking', 'Analytics'],
        },
      ),
      ServiceNotificationModel(
        id: '6',
        title: 'Assignment Deadline Approaching',
        message: 'Your assignment "Logo Design" is due in 2 days',
        type: NotificationType.assignment,
        assignmentId: 'ASG003',
        dateTime: DateTime.now().subtract(Duration(days: 4)),
        isRead: true,
        data: {
          'assignmentTitle': 'Logo Design',
          'deadline': '2024-01-25',
          'clientName': 'XYZ Corp',
        },
      ),
      ServiceNotificationModel(
        id: '7',
        title: 'New Requirement Match',
        message: 'A new requirement matches your services: "Mobile App Development"',
        type: NotificationType.proposal,
        requirementId: 'REQ005',
        dateTime: DateTime.now().subtract(Duration(days: 5)),
        isRead: true,
        data: {
          'requirementTitle': 'Mobile App Development',
          'budget': '₹50,000 - ₹80,000',
          'deadline': '30 days',
        },
      ),
    ];

    updateUnreadCount();
    isLoading.value = false;
  }

  void refreshNotifications() async {
    isRefreshing.value = true;
    await Future.delayed(Duration(seconds: 1));
    loadNotifications();
    isRefreshing.value = false;
  }

  void updateUnreadCount() {
    unreadCount.value = notifications.where((n) => !n.isRead).length;
  }

  void markAsRead(String notificationId) {
    final index = notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      notifications[index] = ServiceNotificationModel(
        id: notifications[index].id,
        title: notifications[index].title,
        message: notifications[index].message,
        type: notifications[index].type,
        assignmentId: notifications[index].assignmentId,
        proposalId: notifications[index].proposalId,
        requirementId: notifications[index].requirementId,
        dateTime: notifications[index].dateTime,
        isRead: true,
        data: notifications[index].data,
      );
      notifications.refresh();
      updateUnreadCount();
    }
  }

  void markAllAsRead() {
    for (var i = 0; i < notifications.length; i++) {
      if (!notifications[i].isRead) {
        notifications[i] = ServiceNotificationModel(
          id: notifications[i].id,
          title: notifications[i].title,
          message: notifications[i].message,
          type: notifications[i].type,
          assignmentId: notifications[i].assignmentId,
          proposalId: notifications[i].proposalId,
          requirementId: notifications[i].requirementId,
          dateTime: notifications[i].dateTime,
          isRead: true,
          data: notifications[i].data,
        );
      }
    }
    notifications.refresh();
    updateUnreadCount();

    Get.snackbar(
      'Success',
      'All notifications marked as read',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void deleteNotification(String notificationId) {
    Get.defaultDialog(
      title: 'Delete Notification',
      middleText: 'Are you sure you want to delete this notification?',
      textConfirm: 'Delete',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      onConfirm: () {
        notifications.removeWhere((n) => n.id == notificationId);
        updateUnreadCount();
        Get.back();
        Get.snackbar(
          'Deleted',
          'Notification removed',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      },
    );
  }

  void clearAllNotifications() {
    if (notifications.isEmpty) return;

    Get.defaultDialog(
      title: 'Clear All Notifications',
      middleText: 'Are you sure you want to clear all notifications?',
      textConfirm: 'Clear All',
      textCancel: 'Cancel',
      confirmTextColor: Colors.white,
      onConfirm: () {
        notifications.clear();
        unreadCount.value = 0;
        Get.back();
        Get.snackbar(
          'Cleared',
          'All notifications cleared',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      },
    );
  }

  List<ServiceNotificationModel> get filteredNotifications {
    switch (selectedFilter.value) {
      case NotificationFilter.unread:
        return notifications.where((n) => !n.isRead).toList();
      case NotificationFilter.proposal:
        return notifications.where((n) => n.type == NotificationType.proposal).toList();
      case NotificationFilter.assignment:
        return notifications.where((n) => n.type == NotificationType.assignment).toList();
      case NotificationFilter.payment:
        return notifications.where((n) => n.type == NotificationType.payment).toList();
      default:
        return notifications.toList();
    }
  }

  void handleNotificationTap(ServiceNotificationModel notification) {
    // Mark as read first
    markAsRead(notification.id);

    // Navigate based on notification type
    switch (notification.type) {
      case NotificationType.proposal:
        if (notification.proposalId != null) {
          Get.toNamed('/service-provider/proposal-details', arguments: notification.proposalId);
        } else if (notification.requirementId != null) {
          Get.toNamed('/service-provider/requirement-details', arguments: notification.requirementId);
        }
        break;
      case NotificationType.assignment:
        if (notification.assignmentId != null) {
          Get.toNamed('/service-provider/assignment-details', arguments: notification.assignmentId);
        }
        break;
      case NotificationType.payment:
        Get.toNamed('/service-provider/earnings');
        break;
      case NotificationType.message:
        Get.toNamed('/service-provider/messages', arguments: {
          'proposalId': notification.proposalId,
        });
        break;
      case NotificationType.review:
        Get.toNamed('/service-provider/reviews');
        break;
      case NotificationType.system:
      // Show notification details
        showNotificationDetails(notification);
        break;
    }
  }

  void showNotificationDetails(ServiceNotificationModel notification) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: notification.iconColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(notification.icon, color: notification.iconColor),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          notification.formattedDate,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(height: 0),
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                notification.message,
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ),
            if (notification.data != null) ...[
              Divider(height: 0),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    ...notification.data!.entries.map((entry) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${entry.key}: ',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[700],
                              ),
                            ),
                            Expanded(
                              child: Text(
                                entry.value.toString(),
                                style: TextStyle(color: Colors.grey[800]),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ],
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border(top: BorderSide(color: Colors.grey[200]!)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      child: Text('Close'),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        deleteNotification(notification.id);
                      },
                      child: Text('Delete'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void startRealTimeUpdates() {
    // In real app, connect to WebSocket or Firebase for real-time updates
    // For now, simulate periodic updates
    Future.delayed(Duration(minutes: 5), () {
      if (isClosed) return;
      // Simulate new notification
      if (notifications.length < 10) {
        final newNotification = ServiceNotificationModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: 'New Opportunity',
          message: 'A new requirement matches your profile: "Mobile App UI/UX Design"',
          type: NotificationType.proposal,
          requirementId: 'REQ${DateTime.now().millisecondsSinceEpoch}',
          dateTime: DateTime.now(),
          isRead: false,
          data: {
            'requirementTitle': 'Mobile App UI/UX Design',
            'budget': '₹30,000 - ₹50,000',
            'deadline': '15 days',
          },
        );
        notifications.insert(0, newNotification);
        updateUnreadCount();

        // Show local notification
        _showLocalNotification(newNotification);
      }
      startRealTimeUpdates();
    });
  }

  void stopRealTimeUpdates() {
    // Clean up any listeners
  }

  void _showLocalNotification(ServiceNotificationModel notification) {
    // In real app, show local notification using flutter_local_notifications
    Get.snackbar(
      notification.title,
      notification.message,
      backgroundColor: notification.iconColor,
      colorText: Colors.white,
      duration: Duration(seconds: 3),
      onTap: (_) => handleNotificationTap(notification),
    );
  }

  void filterNotifications(NotificationFilter filter) {
    selectedFilter.value = filter;
  }

  bool get hasUnreadNotifications => unreadCount.value > 0;
}

enum NotificationFilter {
  all,
  unread,
  proposal,
  assignment,
  payment,
}